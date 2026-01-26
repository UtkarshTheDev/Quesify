import { Suspense } from 'react'
import { createClient } from '@/lib/supabase/server'
import { notFound, redirect } from 'next/navigation'
import { QuestionDetail } from '@/components/questions/question-detail'
import { Question, Solution, UserQuestionStats } from '@/lib/types'

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

  // Fetch question with solutions and user stats
  // We DON'T fetch the author here as per request (cleaner dashboard view)
  const { data: question, error } = await supabase
    .from('questions')
    .select(`
      *,
      solutions (
        *
      ),
      user_question_stats (
        *
      )
    `)
    .eq('id', id)
    .order('likes', { referencedTable: 'solutions', ascending: false })
    .single()

  if (error || !question) {
    console.error('Error fetching question:', error)
    notFound()
  }

  type QuestionWithDetails = Question & {
    solutions: Solution[]
    user_question_stats: UserQuestionStats[]
  }

  return (
    <div className="container py-6">
      <Suspense fallback={<div className="h-24 w-full bg-muted animate-pulse rounded-md" />}>
        <QuestionDetail
          question={question as unknown as QuestionWithDetails}
          userId={user.id}
          isPublic={false}
        />
      </Suspense>
    </div>
  )
}
