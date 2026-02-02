import { createClient } from '@/lib/supabase/server'
import { Button } from '@/components/ui/button'
import { Upload, LayoutGrid, Sparkles, BookOpen, ChevronRight } from 'lucide-react'
import Link from 'next/link'
import { QuestionCard } from '@/components/questions/question-card'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { ChartsSection, ChartsSkeleton } from '@/components/dashboard/charts-section'
import { EmptyDashboard } from '@/components/dashboard/empty-state'
import { Suspense } from 'react'
import {
  UserQuestionWithStatsJoinResult,
  UserQuestionSubjectJoinResult,
  extractQuestion
} from '@/lib/types'

export default async function DashboardPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  const { count: questionCount } = await supabase
    .from('user_questions')
    .select('*', { count: 'exact', head: true })
    .eq('user_id', user?.id)

  if (!questionCount || questionCount === 0) {
    return <EmptyDashboard />
  }

  const { data: recentQuestions } = await supabase
    .from('user_questions')
    .select(`
      added_at,
      question:questions(
        *,
        solutions(count),
        user_question_stats(*)
      )
    `)
    .eq('user_id', user?.id)
    .order('added_at', { ascending: false })
    .limit(6)

  const { data: allQuestions } = await supabase
    .from('user_questions')
    .select(`
      question:questions(subject)
    `)
    .eq('user_id', user?.id)

  const subjectCounts: Record<string, number> = {}
  const questionsData = allQuestions as UserQuestionSubjectJoinResult[] | null
  questionsData?.forEach((item) => {
    const q = extractQuestion(item.question)
    const subject = q?.subject || 'Uncategorized'
    subjectCounts[subject] = (subjectCounts[subject] || 0) + 1
  })

  const subjects = Object.entries(subjectCounts)
    .sort(([, a], [, b]) => b - a)
    .slice(0, 5)

  return (
    <div className="space-y-8">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-2xl md:text-3xl font-bold">Dashboard</h1>
          <p className="text-sm md:text-base text-muted-foreground">
            You have {questionCount} {questionCount === 1 ? 'question' : 'questions'} in your bank
          </p>
        </div>
        <div className="flex items-center gap-2">
          <Button asChild variant="outline" size="sm" className="h-9 md:h-10 px-3 md:px-4">
            <Link href="/dashboard/questions">
              <LayoutGrid className="mr-2 h-4 w-4" />
              <span className="whitespace-nowrap">All Questions</span>
            </Link>
          </Button>
          <Button asChild size="sm" className="h-9 md:h-10 px-3 md:px-4">
            <Link href="/upload">
              <Upload className="mr-2 h-4 w-4" />
              <span className="whitespace-nowrap">Upload New</span>
            </Link>
          </Button>
        </div>
      </div>

      <section>
        <h2 className="text-lg font-semibold mb-4 flex items-center gap-2">
          <Sparkles className="h-5 w-5 text-yellow-500 fill-yellow-500/20" />
          Recommended Practice
        </h2>
        <Suspense fallback={<ChartsSkeleton />}>
          <ChartsSection userId={user!.id} />
        </Suspense>
      </section>

      <section>
        <h2 className="text-lg font-semibold mb-4 flex items-center gap-2">
          <BookOpen className="h-5 w-5" />
          Your Subjects
        </h2>
        <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-4">
          {subjects.map(([subject, count]) => (
            <Link key={subject} href={`/dashboard/questions?subject=${encodeURIComponent(subject)}`}>
              <Card className="hover:bg-muted/50 transition-colors cursor-pointer h-full">
                <CardHeader className="p-4">
                  <CardTitle className="text-sm font-medium">{subject}</CardTitle>
                </CardHeader>
                <CardContent className="p-4 pt-0">
                  <div className="text-2xl font-bold">{count}</div>
                  <p className="text-xs text-muted-foreground">questions</p>
                </CardContent>
              </Card>
            </Link>
          ))}
        </div>
      </section>

      <section>
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-semibold">Recently Added</h2>
          <Button variant="link" asChild className="text-muted-foreground">
            <Link href="/dashboard/questions">
              View all
              <ChevronRight className="ml-1 h-4 w-4" />
            </Link>
          </Button>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {(recentQuestions as UserQuestionWithStatsJoinResult[] | null)?.map((item) => {
             const question = extractQuestion(item.question)
             if (!question) return null
             return (
              <QuestionCard
                key={question.id}
                question={question}
              />
            )
          })}
        </div>
      </section>
    </div>
  )
}
