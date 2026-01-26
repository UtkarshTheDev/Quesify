import { createClient } from '@/lib/supabase/server'
import { notFound, redirect } from 'next/navigation'
import { QuestionDetail } from '@/components/questions/question-detail'
import { Question, Solution, UserQuestionStats } from '@/lib/types'

interface PageProps {
  params: Promise<{ id: string }>
}

export default async function QuestionPage({ params }: PageProps) {
  const { id } = await params
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) {
    redirect('/login')
  }

  // Fetch question with solutions and user stats
  // We use the spread operator to get all fields, and join relations
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
    .order('likes', { referencedTable: 'solutions', ascending: false }) // Order solutions by likes
    .single()

  if (error || !question) {
    console.error('Error fetching question:', error)
    notFound()
  }

  // The types from Supabase query result might need casting or validation
  // specific to how the component expects them.
  // The component expects: question: Question & { solutions: Solution[], user_question_stats: UserQuestionStats[] }
  type QuestionWithDetails = Question & {
    solutions: Solution[]
    user_question_stats: UserQuestionStats[]
  }

  return (
    <div className="container py-6">
      <QuestionDetail
        question={question as unknown as QuestionWithDetails}
        userId={user.id}
      />
    </div>
  )
}
