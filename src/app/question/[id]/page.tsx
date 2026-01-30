import { Suspense } from 'react'
import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import { QuestionDetail } from '@/components/questions/question-detail'
import { Question, Solution, UserQuestionStats } from '@/lib/types'
import { PublicNav } from '@/components/layout/public-nav'
import type { Metadata } from 'next'

export const dynamic = 'force-dynamic'
export const revalidate = 0

interface PageProps {
    params: Promise<{ id: string }>
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
    const { id } = await params
    const supabase = await createClient()

    const { data: question } = await supabase
        .from('questions')
        .select('subject, chapter, question_text')
        .eq('id', id)
        .single()

    if (!question) return { title: 'Question Not Found - Quesify' }

    const cleanText = (question.question_text || '')
        .replace(/[$#*`]/g, '')
        .replace(/\\(.*?)\{/g, '')
        .replace(/\}/g, '')
        .trim()

    const truncatedTitle = cleanText.length > 50 
        ? `${cleanText.substring(0, 50)}...` 
        : cleanText

    const title = `${truncatedTitle} - Quesify`
    const description = `Practice ${question.subject} - ${question.chapter}: ${cleanText.substring(0, 150)}...`

    return {
        title,
        description,
        openGraph: {
            title,
            description,
            type: 'article',
        },
        twitter: {
            card: 'summary_large_image',
            title,
            description,
        }
    }
}

export default async function PublicQuestionPage({ params }: PageProps) {
    const { id } = await params
    const supabase = await createClient()

    // We don't use auth.getUser() here to keep it truly public and fast for guests
    // Getting session user if available for personalized UI (like "Add to Bank")
    const { data: { user } } = await supabase.auth.getUser()

    const { data: question, error } = await supabase
        .from('questions')
        .select(`
      *,
      user_question_stats (
        *
      ),
      user_questions (
        id
      ),
      author:user_profiles!owner_id (
        display_name,
        avatar_url,
        username
      )
    `)
        .eq('id', id)
        .single()

    if (error || !question) {
        console.error('Error fetching question:', error)
        notFound()
    }

    const { data: topSolutions } = await supabase
        .from('solutions')
        .select(`
        *,
        author:user_profiles!contributor_id (
            display_name,
            avatar_url,
            username
        )
        `)
        .eq('question_id', id)
        .order('likes', { ascending: false })
        .order('is_ai_best', { ascending: false })
        .order('created_at', { ascending: false })
        .limit(1)

    const { count: totalSolutionsCount } = await supabase
        .from('solutions')
        .select('*', { count: 'exact', head: true })
        .eq('question_id', id)

    const questionWithDetails = {
        ...question,
        solutions: topSolutions || [],
    }

    type QuestionWithDetails = Question & {
        solutions: Solution[]
        user_question_stats: UserQuestionStats[]
        user_questions: { id: string }[]
        author?: {
            display_name: string | null
            avatar_url: string | null
            username?: string | null
        }
    }

    return (
        <div className="min-h-screen flex flex-col">
            <PublicNav userId={user?.id} />
            <main className="flex-1 mx-auto px-4 py-12">
                <Suspense fallback={
                    <div className="max-w-4xl mx-auto space-y-6">
                        <div className="h-10 w-24 bg-muted animate-pulse rounded-md" />
                        <div className="h-[400px] w-full bg-muted animate-pulse rounded-xl" />
                    </div>
                }>
                    <QuestionDetail
                        question={questionWithDetails as unknown as QuestionWithDetails}
                        userId={user?.id || null}
                        isPublic={true}
                        totalSolutionsCount={totalSolutionsCount || 0}
                    />
                </Suspense>
            </main>
        </div>
    )
}
