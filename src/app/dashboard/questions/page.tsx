import { createClient } from '@/lib/supabase/server'
import { QuestionCard } from '@/components/questions/question-card'
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
    page?: string
    ids?: string
    title?: string
  }>
}

export default async function QuestionsPage({ searchParams }: QuestionsPageProps) {
  const params = await searchParams
  const subject = params.subject
  const chapter = params.chapter
  // const search = params.search // Search temporarily disabled
  const idsParam = params.ids
  const title = params.title
  const page = Number(params.page) || 1
  const limit = 20
  const offset = (page - 1) * limit

  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    redirect('/login')
  }

  // Fetch syllabus progress (subjects and chapters with counts)
  const syllabusProgress = await getUserSyllabusProgress(user.id, subject)
  const currentSubjectData = subject ? syllabusProgress[subject] : null

  // Build query
  // We use !inner on questions to filter by question properties
  let query = supabase
    .from('user_questions')
    .select(`
      added_at,
      question:questions!inner(
        *,
        solutions(count),
        user_question_stats(*)
      )
    `, { count: 'exact' })
    .eq('user_id', user.id)
    .order('added_at', { ascending: false })
    .range(offset, offset + limit - 1)

  // Apply filters
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
  }

  // Note: Text search on related table is tricky in Supabase JS client without a specific RPC or view
  // For now, if there is a search term, we might have to rely on a different approach or accept
  // that we can't easily search across the joined relation in a single query efficiently without setup.
  // However, we can search on the top level if we had the text there.
  // We'll skip text search implementation in the DB query for this MVP step to avoid complex PostgREST syntax errors
  // or use a simple client-side filter if the dataset was small (but it's not guaranteed).
  // Alternatively, we can use the `textSearch` filter if we assume questions are text indexed.
  // query = query.textSearch('question.question_text', search) // This implies 'question' is the alias, but dot notation in filter might work depending on PostgREST version.

  const { data: questionsData, count, error } = await query

  if (error) {
    console.error('Error fetching questions:', error)
  }

  const questions = (questionsData as UserQuestionWithStatsJoinResult[] | null)?.map((q) => {
    return extractQuestion(q.question)
  }).filter(Boolean) as Question[] ?? []
  const totalPages = count ? Math.ceil(count / limit) : 0

  // Fetch unique subjects for filter list from actual usage to ensure we show what users have
  // But also we want to show available subjects from syllabus?
  // Let's stick to the existing method for the top-level subject filter to show what they have,
  // or use the keys from getAllSyllabus if we want to show everything.
  // Mixing both: show keys from syllabusProgress since it covers both static and DB.

  // Actually, we can just use syllabusProgress keys if we fetched all subjects (when subject is undefined)
  // But getUserSyllabusProgress(userId, subject) only returns one if subject is defined.
  // So we need a list of ALL subjects for the top bar.

  // Let's get all subjects efficiently just for the top bar
  const { data: allSubjects } = await supabase
    .from('user_questions')
    .select('question:questions(subject)')
    .eq('user_id', user.id)

  const usedSubjects = new Set((allSubjects as UserQuestionSubjectJoinResult[] | null)?.map((item) => {
    const q = extractQuestion(item.question)
    return q?.subject
  }).filter(Boolean) as string[])

  // Add Physics, Chemistry, Mathematics to the set if not present (to encourage usage)
  const defaultSubjects = ['Physics', 'Chemistry', 'Mathematics']
  defaultSubjects.forEach(s => usedSubjects.add(s))

  const subjects = Array.from(usedSubjects).sort()

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

      {/* Filters */}
      <div className="flex flex-col gap-4">
        {/* Subject Filter (Horizontal Scroll) */}
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

        {/* Chapter Filter (Only if subject is selected) */}
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
                  <Link href={`/dashboard/questions?subject=${encodeURIComponent(subject)}`}>
                    All Chapters
                  </Link>
                </Button>
                {currentSubjectData.chapters.map((ch) => (
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
                    <Link href={`/dashboard/questions?subject=${encodeURIComponent(subject)}&chapter=${encodeURIComponent(ch.chapter)}`}>
                      {ch.chapter}
                      <span className="ml-1.5 text-xs text-muted-foreground bg-muted-foreground/10 px-1.5 py-0.5 rounded-full">
                        {ch.questionCount}
                      </span>
                    </Link>
                  </Button>
                ))}
             </div>
          </div>
        )}
      </div>

      {/* Results */}
      {questions.length === 0 ? (
        <div className="text-center py-12 border rounded-lg bg-muted/10 border-dashed">
          <p className="text-muted-foreground">No questions found.</p>
          {(subject || chapter) && (
            <Button variant="link" asChild className="mt-2">
              <Link href={subject ? `/dashboard/questions?subject=${encodeURIComponent(subject)}` : "/dashboard/questions"}>
                Clear filters
              </Link>
            </Button>
          )}
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {questions.map((question: Question) => (
            <QuestionCard key={question.id} question={question} />
          ))}
        </div>
      )}

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="flex justify-center gap-2 mt-8">
          {page > 1 && (
            <Button variant="outline" size="sm" asChild>
              <Link href={`/dashboard/questions?page=${page - 1}${subject ? `&subject=${subject}` : ''}${chapter ? `&chapter=${chapter}` : ''}`}>
                Previous
              </Link>
            </Button>
          )}
          <div className="flex items-center px-4 text-sm font-medium">
            Page {page} of {totalPages}
          </div>
          {page < totalPages && (
            <Button variant="outline" size="sm" asChild>
              <Link href={`/dashboard/questions?page=${page + 1}${subject ? `&subject=${subject}` : ''}${chapter ? `&chapter=${chapter}` : ''}`}>
                Next
              </Link>
            </Button>
          )}
        </div>
      )}
    </div>
  )
}