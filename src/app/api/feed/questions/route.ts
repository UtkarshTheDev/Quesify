import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { getCache, setCache, CACHE_KEYS, CACHE_TTL } from '@/lib/cache/api-cache'
import { applyRateLimit } from '@/lib/ratelimit/client'

export const dynamic = 'force-dynamic'

export async function GET(request: NextRequest) {
    const rateLimitResult = await applyRateLimit(request, 'feed')
    if (!rateLimitResult.success && rateLimitResult.response) {
        return rateLimitResult.response
    }

    try {
        const supabase = await createClient()
        const { data: { user } } = await supabase.auth.getUser()

        if (!user) {
            return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
        }

        const { searchParams } = new URL(request.url)
        const limit = Math.min(parseInt(searchParams.get('limit') || '20'), 50)
        const offset = parseInt(searchParams.get('offset') || '0')

        // Check cache
        const cacheKey = `feed:questions:${user.id}:${offset}:${limit}`
        const cached = await getCache(cacheKey)

        if (cached.fromCache && cached.data) {
            return NextResponse.json(cached.data)
        }

        // Fetch recommended questions
        const { data: questions, error } = await supabase.rpc('get_recommended_questions', {
            p_user_id: user.id,
            p_limit: limit,
            p_offset: offset
        })

        if (error) {
            console.error('[Feed/Questions] RPC error:', error)
            return NextResponse.json(
                { error: 'Failed to fetch questions' },
                { status: 500 }
            )
        }

        // Transform to cleaner format
        const transformedQuestions = (questions || []).map((q: {
            question_id: string
            question_text: string
            subject: string | null
            chapter: string | null
            topics: string[]
            difficulty: string
            popularity: number
            created_at: string
            image_url: string | null
            type: string
            has_diagram: boolean
            uploader_user_id: string
            uploader_display_name: string | null
            uploader_username: string | null
            uploader_avatar_url: string | null
            solutions_count: number
            is_in_bank: boolean
            due_for_review: boolean
            score: number
        }) => ({
            id: q.question_id,
            question_text: q.question_text,
            subject: q.subject,
            chapter: q.chapter,
            topics: q.topics || [],
            difficulty: q.difficulty,
            popularity: q.popularity,
            created_at: q.created_at,
            image_url: q.image_url,
            type: q.type,
            has_diagram: q.has_diagram,
            uploader: {
                user_id: q.uploader_user_id,
                display_name: q.uploader_display_name,
                username: q.uploader_username,
                avatar_url: q.uploader_avatar_url
            },
            solutions_count: q.solutions_count,
            is_in_bank: q.is_in_bank,
            due_for_review: q.due_for_review,
            score: q.score
        }))

        const response = {
            questions: transformedQuestions,
            hasMore: transformedQuestions.length === limit,
            offset: offset + transformedQuestions.length
        }

        // Cache for 1 hour
        await setCache(cacheKey, response, CACHE_TTL.FEED || 3600)

        return NextResponse.json(response)
    } catch (error) {
        console.error('[Feed/Questions] Error:', error)
        return NextResponse.json(
            { error: error instanceof Error ? error.message : 'Fetch failed' },
            { status: 500 }
        )
    }
}
