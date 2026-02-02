import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { getCache, setCache, CACHE_KEYS, CACHE_TTL } from '@/lib/cache/api-cache'

export const dynamic = 'force-dynamic'

export async function GET(request: NextRequest) {
    try {
        const supabase = await createClient()
        const { data: { user } } = await supabase.auth.getUser()

        if (!user) {
            return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
        }

        const { searchParams } = new URL(request.url)
        const limit = Math.min(parseInt(searchParams.get('limit') || '10'), 30)
        const offset = parseInt(searchParams.get('offset') || '0')

        // Check cache
        const cacheKey = `feed:users:${user.id}:${offset}:${limit}`
        const cached = await getCache(cacheKey)

        if (cached.fromCache && cached.data) {
            return NextResponse.json(cached.data)
        }

        // Fetch recommended users
        const { data: users, error } = await supabase.rpc('get_recommended_users', {
            p_user_id: user.id,
            p_limit: limit,
            p_offset: offset
        })

        if (error) {
            console.error('[Feed/Users] RPC error:', error)
            return NextResponse.json(
                { error: 'Failed to fetch users' },
                { status: 500 }
            )
        }

        // Transform to cleaner format
        const transformedUsers = (users || []).map((u: {
            user_id: string
            display_name: string | null
            username: string | null
            avatar_url: string | null
            common_subjects: string[]
            mutual_follows_count: number
            total_questions: number
            total_solutions: number
            is_following: boolean
            last_active: string
            score: number
        }) => ({
            user_id: u.user_id,
            display_name: u.display_name,
            username: u.username,
            avatar_url: u.avatar_url,
            common_subjects: u.common_subjects || [],
            mutual_follows_count: u.mutual_follows_count,
            total_questions: u.total_questions,
            total_solutions: u.total_solutions,
            is_following: u.is_following,
            last_active: u.last_active,
            score: u.score
        }))

        const response = {
            users: transformedUsers,
            hasMore: transformedUsers.length === limit,
            offset: offset + transformedUsers.length
        }

        // Cache for 1 hour
        await setCache(cacheKey, response, CACHE_TTL.FEED || 3600)

        return NextResponse.json(response)
    } catch (error) {
        console.error('[Feed/Users] Error:', error)
        return NextResponse.json(
            { error: error instanceof Error ? error.message : 'Fetch failed' },
            { status: 500 }
        )
    }
}
