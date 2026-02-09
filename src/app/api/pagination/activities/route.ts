import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { getCache, recordCacheHit, recordCacheMiss, resetCacheHitTracker, setCache, CACHE_KEYS, CACHE_TTL } from '@/lib/cache/api-cache'

export const dynamic = 'force-dynamic'

export async function GET(request: NextRequest) {
  resetCacheHitTracker()

  try {
    const supabase = await createClient()
    const { searchParams } = new URL(request.url)

    const userId = searchParams.get('user_id')
    const cursor = searchParams.get('cursor')
    const limit = Math.min(50, Math.max(1, parseInt(searchParams.get('limit') || '20')))

    if (!userId) {
      return NextResponse.json(
        { error: 'user_id is required' },
        { status: 400 }
      )
    }

    const cacheKey = CACHE_KEYS.PAGINATION.ACTIVITIES(userId, cursor)
    const cached = await getCache(cacheKey)

    if (cached.fromCache) {
      recordCacheHit()
      console.log(`[Cache] HIT ${cacheKey}`)
      return NextResponse.json(cached.data)
    }

    recordCacheMiss()
    console.log(`[Cache] MISS ${cacheKey}`)

    const query = supabase
      .from('user_activities')
      .select('*')
      .eq('user_id', userId)
      .order('created_at', { ascending: false })

    let data: {
      id: string
      created_at: string
      activity_type: string
      [key: string]: unknown
    }[] = []
    let hasMore = false
    let nextCursor: string | null = null

    if (cursor) {
      const { data: rawData, error } = await query
        .lt('created_at', cursor)
        .limit(limit + 1)

      if (error) {
        console.error('Error fetching activities with cursor:', error)
        return NextResponse.json(
          { error: 'Failed to fetch activities' },
          { status: 500 }
        )
      }

      data = rawData || []
      hasMore = data.length > limit

      if (hasMore) {
        data = data.slice(0, limit)
      }

      if (data.length > 0) {
        nextCursor = data[data.length - 1].created_at
      }
    } else {
      const { data: rawData, error } = await query.limit(limit + 1)

      if (error) {
        console.error('Error fetching activities:', error)
        return NextResponse.json(
          { error: 'Failed to fetch activities' },
          { status: 500 }
        )
      }

      data = rawData || []
      hasMore = data.length > limit

      if (hasMore) {
        data = data.slice(0, limit)
      }

      if (data.length > 0) {
        nextCursor = data[data.length - 1].created_at
      }
    }

    const result = {
      data,
      next_cursor: nextCursor,
      has_more: hasMore,
    }

    await setCache(cacheKey, result, CACHE_TTL.PAGINATION)

    return NextResponse.json({
      ...result,
      fromCache: false,
    })
  } catch (error) {
    console.error('Unexpected error in activities pagination:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
