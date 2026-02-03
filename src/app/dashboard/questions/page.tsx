import { createClient } from '@/lib/supabase/server'
import { InfiniteQuestionList } from '@/components/questions/infinite-question-list'
import { Button } from '@/components/ui/button'
import { Filter, ChevronRight } from 'lucide-react'
import Link from 'next/link'
import { redirect } from 'next/navigation'
import {
  Question,
  UserQuestionWithStatsJoinResult,
  UserQuestionSubjectJoinResult,
  extractQuestion
} from '@/lib/types'
import { getUserSyllabusProgress } from '@/lib/services/syllabus'
import { cn } from '@/lib/utils'

interface QuestionsPageProps {
  searchParams: Promise<{
    subject?: string
    chapter?: string
    search?: string
    ids?: string
    title?: string
    difficulty?: string
    isMCQ?: string
  }>
}

export default async function QuestionsPage({ searchParams }: QuestionsPageProps) {
  const params = await searchParams
  const subject = params.subject
  const chapter = params.chapter
  const difficulty = params.difficulty
  const isMCQ = params.isMCQ
  const idsParam = params.ids
  const title = params.title
  const limit = 20

  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    redirect('/login')
  }

  const syllabusProgress = await getUserSyllabusProgress(user.id, subject)
  const currentSubjectData = subject ? syllabusProgress[subject] : null

  let query = supabase
    .from('user_questions')
    .select(`
      added_at,
      question:questions!inner(
        *,
        solutions(count),
        user_question_stats(*)
      )
    `)
    .eq('user_id', user.id)
    .order('added_at', { ascending: false })
    .limit(limit + 1)

  if (idsParam) {
    const ids = idsParam.split(',')
    query = query.in('question_id', ids)
  } else {
    if (subject) {
      query = query.eq('question.subject', subject)
    }
    if (chapter) {
      query = query.eq('question.chapter', chapter)
    }
    if (difficulty) {
      query = query.eq('question.difficulty', difficulty)
    }
    if (isMCQ !== undefined) {
      if (isMCQ === 'true') {
        query = query.eq('question.type', 'MCQ')
      } else {
        query = query.neq('question.type', 'MCQ')
      }
    }
  }

  const { data: questionsData, error } = await query

  if (error) {
    console.error('Error fetching questions:', error)
  }

  const allQuestions = (questionsData as UserQuestionWithStatsJoinResult[] | null)?.map((q) => {
    return extractQuestion(q.question)
  }).filter(Boolean) as Question[] ?? []

  const hasMore = allQuestions.length > limit
  const questions = hasMore ? allQuestions.slice(0, limit) : allQuestions
  const initialCursor = hasMore && questions.length > 0
    ? questionsData?.[questions.length - 1]?.added_at
    : null

  const { data: allSubjects } = await supabase
    .from('user_questions')
    .select('question:questions(subject)')
    .eq('user_id', user.id)

  const usedSubjects = new Set((allSubjects as UserQuestionSubjectJoinResult[] | null)?.map((item) => {
    const q = extractQuestion(item.question)
    return q?.subject
  }).filter(Boolean) as string[])

  const defaultSubjects = ['Physics', 'Chemistry', 'Mathematics']
  defaultSubjects.forEach(s => usedSubjects.add(s))

  const subjects = Array.from(usedSubjects).sort()

  const sortedChapters = currentSubjectData ? (() => {
    const withQuestions = currentSubjectData.chapters
      .filter(ch => ch.questionCount > 0)
      .sort((a, b) => b.questionCount - a.questionCount)

    const withoutQuestions = currentSubjectData.chapters
      .filter(ch => ch.questionCount === 0)
      .sort((a, b) => b.priority - a.priority)

    return [...withQuestions, ...withoutQuestions]
  })() : []

  return (
    <div className="space-y-6">
      <div className="flex flex-col md:flex-row gap-4 items-start md:items-center justify-between">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <h1 className="text-3xl font-bold">
              {title ? title : (subject || 'All Questions')}
            </h1>
            {chapter && (
              <>
                <ChevronRight className="h-5 w-5 text-muted-foreground" />
                <span className="text-xl text-muted-foreground">{chapter}</span>
              </>
            )}
          </div>
          <p className="text-muted-foreground">
            {title ? 'Practice session based on your analytics' : 'Manage and review your question bank'}
          </p>
        </div>
      </div>

      <div className="flex flex-col gap-4">
        <div className="w-full overflow-x-auto pb-2 border-b">
          <div className="flex items-center gap-2 mb-2">
            <Filter className="h-4 w-4 text-muted-foreground shrink-0" />
            <span className="text-sm font-medium text-muted-foreground">Subjects:</span>
            <Button
              variant={!subject ? "secondary" : "ghost"}
              size="sm"
              asChild
              className="rounded-full"
            >
              <Link href="/dashboard/questions">All</Link>
            </Button>
            {subjects.map((subj) => (
              <Button
                key={subj}
                variant={subject === subj ? "secondary" : "ghost"}
                size="sm"
                asChild
                className="rounded-full"
              >
                <Link href={`/dashboard/questions?subject=${encodeURIComponent(subj)}`}>
                  {subj}
                </Link>
              </Button>
            ))}
          </div>
        </div>

        {subject && currentSubjectData && (
          <div className="w-full overflow-x-auto pb-2">
            <div className="flex items-center gap-2">
              <span className="text-sm font-medium text-muted-foreground shrink-0">Chapters:</span>
              <Button
                variant={!chapter ? "secondary" : "outline"}
                size="sm"
                asChild
                className="rounded-full h-8"
              >
                <Link href={`/dashboard/questions?subject=${encodeURIComponent(subject)}${difficulty ? `&difficulty=${difficulty}` : ''}${isMCQ ? `&isMCQ=${isMCQ}` : ''}`}>
                  All Chapters
                </Link>
              </Button>
              {sortedChapters.map((ch) => (
                <Button
                  key={ch.chapter}
                  variant={chapter === ch.chapter ? "secondary" : "outline"}
                  size="sm"
                  asChild
                  className={cn(
                    "rounded-full h-8 whitespace-nowrap",
                    chapter === ch.chapter ? "border-primary" : "border-dashed"
                  )}
                >
                  <Link href={`/dashboard/questions?subject=${encodeURIComponent(subject)}&chapter=${encodeURIComponent(ch.chapter)}${difficulty ? `&difficulty=${difficulty}` : ''}${isMCQ ? `&isMCQ=${isMCQ}` : ''}`}>
                    {ch.chapter}
                    <span className={cn(
                      "ml-1.5 text-xs px-1.5 py-0.5 rounded-full",
                      ch.questionCount > 0
                        ? "bg-primary/10 text-primary font-medium"
                        : "bg-muted-foreground/10 text-muted-foreground"
                    )}>
                      {ch.questionCount}
                    </span>
                  </Link>
                </Button>
              ))}
            </div>
          </div>
        )}

        <div className="flex items-center gap-4 flex-wrap">
          <div className="flex items-center gap-2">
            <span className="text-sm font-medium text-muted-foreground">Difficulty:</span>
            <div className="flex gap-1">
              {['easy', 'medium', 'hard', 'very_hard'].map((d) => (
                <Button
                  key={d}
                  variant={difficulty === d ? "secondary" : "ghost"}
                  size="sm"
                  asChild
                  className="h-7 text-xs capitalize rounded-full px-3"
                >
                  <Link href={`/dashboard/questions?${new URLSearchParams({
                    ...(subject ? { subject } : {}),
                    ...(chapter ? { chapter } : {}),
                    ...(isMCQ ? { isMCQ } : {}),
                    ...(difficulty === d ? {} : { difficulty: d })
                  }).toString()}`}>
                    {d.replace('_', ' ')}
                  </Link>
                </Button>
              ))}
            </div>
          </div>

          <div className="w-px h-4 bg-border hidden md:block" />

          <div className="flex items-center gap-2">
            <span className="text-sm font-medium text-muted-foreground">Type:</span>
            <div className="flex gap-1">
              <Button
                variant={isMCQ === 'true' ? "secondary" : "ghost"}
                size="sm"
                asChild
                className="h-7 text-xs rounded-full px-3"
              >
                <Link href={`/dashboard/questions?${new URLSearchParams({
                  ...(subject ? { subject } : {}),
                  ...(chapter ? { chapter } : {}),
                  ...(difficulty ? { difficulty } : {}),
                  ...(isMCQ === 'true' ? {} : { isMCQ: 'true' })
                }).toString()}`}>
                  MCQ
                </Link>
              </Button>
              <Button
                variant={isMCQ === 'false' ? "secondary" : "ghost"}
                size="sm"
                asChild
                className="h-7 text-xs rounded-full px-3"
              >
                <Link href={`/dashboard/questions?${new URLSearchParams({
                  ...(subject ? { subject } : {}),
                  ...(chapter ? { chapter } : {}),
                  ...(difficulty ? { difficulty } : {}),
                  ...(isMCQ === 'false' ? {} : { isMCQ: 'false' })
                }).toString()}`}>
                  Subjective
                </Link>
              </Button>
            </div>
          </div>

          {(difficulty || isMCQ) && (
            <Button variant="ghost" size="sm" asChild className="h-7 text-xs text-muted-foreground hover:text-foreground ml-auto">
              <Link href={`/dashboard/questions?${new URLSearchParams({
                ...(subject ? { subject } : {}),
                ...(chapter ? { chapter } : {})
              }).toString()}`}>
                Clear filters
              </Link>
            </Button>
          )}
        </div>
      </div>

      <InfiniteQuestionList
        userId={user.id}
        initialQuestions={questions}
        initialCursor={initialCursor}
        filters={{
          subject,
          chapter,
          difficulty,
          isMCQ,
          ids: idsParam,
        }}
        key={JSON.stringify({
          subject,
          chapter,
          difficulty,
          isMCQ,
          ids: idsParam
        })}
      />
    </div>
  )
}
