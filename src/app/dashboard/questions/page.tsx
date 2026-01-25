import { createClient } from '@/lib/supabase/server'
import { QuestionCard } from '@/components/questions/question-card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Input } from '@/components/ui/input'
import { Search, Filter, X } from 'lucide-react'
import Link from 'next/link'
import { redirect } from 'next/navigation'

interface QuestionsPageProps {
  searchParams: Promise<{
    subject?: string
    search?: string
    page?: string
    ids?: string
    title?: string
  }>
}

export default async function QuestionsPage({ searchParams }: QuestionsPageProps) {
  const params = await searchParams
  const subject = params.subject
  const search = params.search
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
  } else if (subject) {
    query = query.eq('question.subject', subject)
  }

  // Note: Text search on related table is tricky in Supabase JS client without a specific RPC or view
  // For now, if there is a search term, we might have to rely on a different approach or accept
  // that we can't easily search across the joined relation in a single query efficiently without setup.
  // However, we can search on the top level if we had the text there.
  // We'll skip text search implementation in the DB query for this MVP step to avoid complex PostgREST syntax errors
  // or use a simple client-side filter if the dataset was small (but it's not guaranteed).
  // Alternatively, we can use the `textSearch` filter if we assume questions are text indexed.
  // query = query.textSearch('question.question_text', search) // This implies 'question' is the alias, but dot notation in filter might work depending on PostgREST version.

  // Let's stick to Subject filtering which is the main requirement.

  const { data: questionsData, count, error } = await query

  if (error) {
    console.error('Error fetching questions:', error)
  }

  const questions = questionsData?.map((q: any) => q.question) || []
  const totalPages = count ? Math.ceil(count / limit) : 0

  // Fetch unique subjects for filter list
  // We need to get all user questions to find all subjects
  // This might be heavy if user has many questions.
  // A better way is to use a distinct query.
  const { data: allSubjects } = await supabase
    .from('user_questions')
    .select('question:questions(subject)')
    .eq('user_id', user.id)

  const subjects = Array.from(new Set(allSubjects?.map((item: any) => item.question?.subject).filter(Boolean) as string[]))

  return (
    <div className="space-y-6">
      <div className="flex flex-col md:flex-row gap-4 items-start md:items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold">
            {title ? title : 'All Questions'}
          </h1>
          <p className="text-muted-foreground">
            {title ? 'Practice session based on your analytics' : 'Manage and review your question bank'}
          </p>
        </div>
      </div>

      {/* Filters */}
      <div className="flex flex-col md:flex-row gap-4 items-center">
        {/* Subject Filter (Horizontal Scroll) */}
        <div className="w-full overflow-x-auto pb-2">
          <div className="flex items-center gap-2">
            <Filter className="h-4 w-4 text-muted-foreground shrink-0" />
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
      </div>

      {/* Results */}
      {questions.length === 0 ? (
        <div className="text-center py-12 border rounded-lg bg-muted/10 border-dashed">
          <p className="text-muted-foreground">No questions found.</p>
          {subject && (
            <Button variant="link" asChild className="mt-2">
              <Link href="/dashboard/questions">Clear filters</Link>
            </Button>
          )}
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {questions.map((question: any) => (
            <QuestionCard key={question.id} question={question} />
          ))}
        </div>
      )}

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="flex justify-center gap-2 mt-8">
          {page > 1 && (
            <Button variant="outline" size="sm" asChild>
              <Link href={`/dashboard/questions?page=${page - 1}${subject ? `&subject=${subject}` : ''}`}>
                Previous
              </Link>
            </Button>
          )}
          <div className="flex items-center px-4 text-sm font-medium">
            Page {page} of {totalPages}
          </div>
          {page < totalPages && (
            <Button variant="outline" size="sm" asChild>
              <Link href={`/dashboard/questions?page=${page + 1}${subject ? `&subject=${subject}` : ''}`}>
                Next
              </Link>
            </Button>
          )}
        </div>
      )}
    </div>
  )
}
