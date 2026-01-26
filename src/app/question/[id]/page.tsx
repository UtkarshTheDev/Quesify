import { Suspense } from 'react'
import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import { QuestionDetail } from '@/components/questions/question-detail'
import { Question, Solution, UserQuestionStats } from '@/lib/types'
import { PublicNav } from '@/components/layout/public-nav'

interface PageProps {
    params: Promise<{ id: string }>
}

export default async function PublicQuestionPage({ params }: PageProps) {
    const { id } = await params
    const supabase = await createClient()

    // We don't use auth.getUser() here to keep it truly public and fast for guests
    // Getting session user if available for personalized UI (like "Add to Bank")
    const { data: { user } } = await supabase.auth.getUser()

    // Fetch question with solutions and author profile
    const { data: question, error } = await supabase
        .from('questions')
        .select(`
      *,
      solutions (
        *
      ),
      user_question_stats (
        *
      ),
      user_questions (
        id
      ),
      author:user_profiles!owner_id (
        display_name,
        avatar_url
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
        user_questions: { id: string }[]
        author?: {
            display_name: string | null
            avatar_url: string | null
        }
    }

    return (
        <div className="min-h-screen flex flex-col">
            <PublicNav userId={user?.id} />
            <main className="flex-1 container mx-auto px-4 py-12">
                <Suspense fallback={
                    <div className="max-w-4xl mx-auto space-y-6">
                        <div className="h-10 w-24 bg-muted animate-pulse rounded-md" />
                        <div className="h-[400px] w-full bg-muted animate-pulse rounded-xl" />
                    </div>
                }>
                    <QuestionDetail
                        question={question as unknown as QuestionWithDetails}
                        userId={user?.id || null}
                        isPublic={true}
                    />
                </Suspense>
            </main>
        </div>
    )
}
