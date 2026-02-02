import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { getCache, setCache, CACHE_KEYS, CACHE_TTL } from '@/lib/cache/api-cache'

export const dynamic = 'force-dynamic'

export interface FeedItem {
    id: string
    type: 'question' | 'user_suggestion'
    data: RecommendedQuestion | RecommendedUser
    score: number
    createdAt: string
}

export interface RecommendedQuestion {
    id: string
    question_text: string
    subject: string | null
    chapter: string | null
    topics: string[]
    difficulty: string
    popularity: number
    image_url: string | null
    type: string
    has_diagram: boolean
    solutions_count: number
    is_in_bank: boolean
    due_for_review: boolean
    uploader: {
        user_id: string
        display_name: string | null
        username: string | null
        avatar_url: string | null
    }
}

export interface RecommendedUser {
    user_id: string
    display_name: string | null
    username: string | null
    avatar_url: string | null
    common_subjects: string[]
    mutual_follows_count: number
    total_questions: number
    total_solutions: number
    is_following: boolean
}

export async function GET(request: NextRequest) {
    try {
        const supabase = await createClient()
        const { data: { user } } = await supabase.auth.getUser()

        if (!user) {
            return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
        }

        const { searchParams } = new URL(request.url)
        const cursor = searchParams.get('cursor') // timestamp-based cursor
        const limit = Math.min(parseInt(searchParams.get('limit') || '20'), 50)
        const offset = parseInt(searchParams.get('offset') || '0')

        // Check cache first
        const cacheKey = `feed:mixed:${user.id}:${offset}:${limit}`
        const cached = await getCache(cacheKey)

        if (cached.fromCache && cached.data) {
            console.log(`[Feed] Cache HIT for ${user.id}`)
            return NextResponse.json(cached.data)
        }

        console.log(`[Feed] Cache MISS for ${user.id}, fetching from database`)

        // Fetch mixed feed from database
        const { data: feedData, error } = await supabase.rpc('get_mixed_feed', {
            p_user_id: user.id,
            p_limit: limit,
            p_offset: offset
        })

        if (error) {
            console.error('[Feed] RPC error:', error)
            return NextResponse.json(
                { error: 'Failed to fetch feed' },
                { status: 500 }
            )
        }

        // Transform to API response format
        const items: FeedItem[] = (feedData || []).map((item: {
            item_id: string
            item_type: 'question' | 'user_suggestion'
            item_data: RecommendedQuestion | RecommendedUser
            score: number
            created_at: string
        }) => ({
            id: item.item_id,
            type: item.item_type,
            data: item.item_data,
            score: item.score,
            createdAt: item.created_at
        }))

        const response = {
            items,
            nextCursor: items.length === limit ? items[items.length - 1]?.createdAt : null,
            hasMore: items.length === limit,
            offset: offset + items.length
        }

        // Cache for 1 hour
        await setCache(cacheKey, response, CACHE_TTL.FEED || 3600)

        return NextResponse.json(response)
    } catch (error) {
        console.error('[Feed] Error:', error)
        return NextResponse.json(
            { error: error instanceof Error ? error.message : 'Feed fetch failed' },
            { status: 500 }
        )
    }
}
