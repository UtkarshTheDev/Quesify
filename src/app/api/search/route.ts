import { createClient } from '@/lib/supabase/server'
import { NextRequest, NextResponse } from 'next/server'
import { SearchResponse, SearchedUser, SearchedQuestion } from '@/lib/types'
import { applyRateLimit } from '@/lib/ratelimit/client'

export const dynamic = 'force-dynamic'

export async function GET(request: NextRequest) {
    const rateLimitResult = await applyRateLimit(request, 'search')
    if (!rateLimitResult.success && rateLimitResult.response) {
        return rateLimitResult.response
    }

    try {
        const requestUrl = new URL(request.url)
        const queryRaw = requestUrl.searchParams.get('q')?.trim() || ''
        const supabase = await createClient()

        // Auth check
        const { data: { user } } = await supabase.auth.getUser()
        if (!user) {
            return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
        }

        if (!queryRaw) {
            // Fetch explore questions and recommended users for empty search state
            const [exploreQuestionsRes, recommendedUsersRes] = await Promise.all([
                supabase.rpc('get_explore_questions', { p_user_id: user.id }),
                supabase.rpc('get_recommended_users', { p_user_id: user.id, p_limit: 4 })
            ])

            if (exploreQuestionsRes.error) console.error('Explore Questions Error:', exploreQuestionsRes.error)
            if (recommendedUsersRes.error) console.error('Recommended Users Error:', recommendedUsersRes.error)

            const questions: SearchedQuestion[] = (exploreQuestionsRes.data || []).map((q: any) => ({
                id: q.question_id,
                question_text: q.question_text,
                subject: q.subject,
                chapter: q.chapter,
                topics: q.topics,
                difficulty: q.difficulty,
                popularity: q.popularity,
                image_url: q.image_url,
                type: q.type,
                has_diagram: q.has_diagram,
                solutions_count: q.solutions_count,
                is_in_bank: q.is_in_bank,
                due_for_review: q.due_for_review,
                created_at: q.created_at,
                uploader: {
                    user_id: q.uploader_user_id,
                    display_name: q.uploader_display_name,
                    username: q.uploader_username,
                    avatar_url: q.uploader_avatar_url
                },
                similarity_score: 0
            }))

            const users: SearchedUser[] = (recommendedUsersRes.data || []).map((u: any) => ({
                user_id: u.user_id,
                username: u.username,
                display_name: u.display_name,
                avatar_url: u.avatar_url,
                similarity_score: 0,
                common_subjects: u.common_subjects || [],
                mutual_follows_count: u.mutual_follows_count || 0,
                total_questions: u.total_questions || 0,
                total_solutions: u.total_solutions || 0,
                is_following: u.is_following || false
            }))

            return NextResponse.json({ users, questions })
        }

        const isUserSearchOnly = queryRaw.startsWith('@')
        const queryText = isUserSearchOnly ? queryRaw.slice(1) : queryRaw // Remove @ if present

        // Execute searches in parallel if needed
        const promises = []

        // 1. Search Users (Always run, unless empty after @ trim)
        if (queryText.length > 0) {
            promises.push(
                supabase.rpc('search_users', {
                    p_query: queryText,
                    p_viewer_id: user.id,
                    p_limit: 10
                })
            )
        } else {
            promises.push(Promise.resolve({ data: [], error: null }))
        }

        // 2. Search Questions (Only run if NOT @ search)
        if (!isUserSearchOnly && queryText.length > 0) {
            promises.push(
                supabase.rpc('search_questions', {
                    p_query: queryText,
                    p_user_id: user.id,
                    p_limit: 20
                })
            )
        } else {
            promises.push(Promise.resolve({ data: [], error: null }))
        }

        const [usersRes, questionsRes] = await Promise.all(promises)

        if (usersRes?.error) {
            console.error('Error searching users:', usersRes.error)
        }
        if (questionsRes?.error) {
            console.error('Error searching questions:', questionsRes.error)
        }

        // Map results safely
        const users: SearchedUser[] = (usersRes?.data || []).map((u: any) => ({
            user_id: u.user_id,
            username: u.username,
            display_name: u.display_name,
            avatar_url: u.avatar_url,
            similarity_score: u.similarity_score,
            common_subjects: u.common_subjects || [],
            mutual_follows_count: u.mutual_follows_count || 0,
            total_questions: u.total_questions || 0,
            total_solutions: u.total_solutions || 0,
            is_following: u.is_following || false
        }))

        const questions: SearchedQuestion[] = (questionsRes?.data || []).map((q: any) => ({
            id: q.question_id,
            question_text: q.question_text,
            subject: q.subject,
            chapter: q.chapter,
            topics: q.topics,
            difficulty: q.difficulty,
            popularity: q.popularity,
            image_url: q.image_url,
            type: q.type,
            has_diagram: q.has_diagram,
            solutions_count: q.solutions_count,
            is_in_bank: q.is_in_bank,
            due_for_review: q.due_for_review,
            created_at: q.created_at,
            uploader: {
                user_id: q.uploader_user_id,
                display_name: q.uploader_display_name,
                username: q.uploader_username,
                avatar_url: q.uploader_avatar_url
            },
            similarity_score: q.similarity_score
        }))

        const response: SearchResponse = {
            users,
            questions
        }

        return NextResponse.json(response)

    } catch (error) {
        console.error('Search API Error:', error)
        return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 })
    }
}
