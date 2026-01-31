import { Suspense } from 'react'
import { createClient } from '@/lib/supabase/server'
import { notFound, redirect } from 'next/navigation'
import { QuestionDetail } from '@/components/questions/question-detail'
import { QuestionSkeleton } from '@/components/questions/question-skeleton'
import { Question, Solution, UserQuestionStats } from '@/lib/types'

export const dynamic = 'force-dynamic'
export const revalidate = 0

interface PageProps {
  params: Promise<{ id: string }>
}

export default async function DashboardQuestionPage({ params }: PageProps) {
  const { id } = await params
  const supabase = await createClient()

  // Get current session
  const { data: { user } } = await supabase.auth.getUser()

  // 1. If not logged in -> Redirect to public route
  if (!user) {
    redirect(`/question/${id}`)
  }

  // Check if user has access to this question in their dashboard (bank)
  const { data: access } = await supabase
    .from('user_questions')
    .select('id')
    .eq('question_id', id)
    .eq('user_id', user.id)
    .single()

  // 2. If skip/not in bank -> Redirect to public route
  if (!access) {
    redirect(`/question/${id}`)
  }

  // Fetch question with top solution and user stats
  const { data: question, error } = await supabase
    .from('questions')
    .select(`
      *,
      solutions:solutions (
        *,
        author:user_profiles!contributor_id (
          display_name,
          avatar_url
        )
      ),
      user_question_stats (
        *
      )
    `)
    .eq('id', id)
    .order('likes', { referencedTable: 'solutions', ascending: false })
    .order('is_ai_best', { referencedTable: 'solutions', ascending: false })
    .order('created_at', { referencedTable: 'solutions', ascending: false })
    .limit(1, { referencedTable: 'solutions' })
    .single()

  // Fetch total solutions count
  const { count: totalSolutionsCount } = await supabase
    .from('solutions')
    .select('*', { count: 'exact', head: true })
    .eq('question_id', id)

  if (error || !question) {
    console.error('Error fetching question:', error)
    notFound()
  }

  type QuestionWithDetails = Question & {
    solutions: Solution[]
    user_question_stats: UserQuestionStats[]
  }

  return (
    <div className="py-6">
      <Suspense fallback={<QuestionSkeleton isPublic={false} />}>
        <QuestionDetail
          question={question as unknown as QuestionWithDetails}
          userId={user.id}
          isPublic={false}
          totalSolutionsCount={totalSolutionsCount || 0}
        />
      </Suspense>
    </div>
  )
}
