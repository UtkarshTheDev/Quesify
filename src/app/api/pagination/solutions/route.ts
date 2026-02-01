import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { getCache, recordCacheHit, recordCacheMiss, resetCacheHitTracker, setCache, CACHE_KEYS, CACHE_TTL } from '@/lib/cache/api-cache'

interface QuestionBasic {
  id: string
  question_text: string
  subject: string | null
  chapter: string | null
  owner_id: string
}

interface SolutionAuthor {
  display_name: string | null
  avatar_url: string | null
  username: string | null
}

interface SolutionWithQuestion {
  id: string
  question_id: string
  contributor_id: string
  solution_text: string
  numerical_answer: string | null
  approach_description: string | null
  likes: number
  is_ai_best: boolean
  correct_option: number | null
  avg_solve_time: number
  created_at: string
  updated_at: string
  question: QuestionBasic | QuestionBasic[] | null
  author: SolutionAuthor | SolutionAuthor[] | null
}

export const dynamic = 'force-dynamic'

export async function GET(request: NextRequest) {
  resetCacheHitTracker()

  try {
    const supabase = await createClient()
    const { searchParams } = new URL(request.url)

    const userId = searchParams.get('user_id')
    const cursor = searchParams.get('cursor')
    const limit = Math.min(50, Math.max(1, parseInt(searchParams.get('limit') || '20')))
    const excludeOwnQuestions = searchParams.get('exclude_own') === 'true'

    if (!userId) {
      return NextResponse.json(
        { error: 'user_id is required' },
        { status: 400 }
      )
    }

    const cacheKey = CACHE_KEYS.PAGINATION.SOLUTIONS(userId)
    const cached = await getCache(cacheKey)

    if (cached.fromCache) {
      recordCacheHit()
      console.log(`[Cache] HIT ${cacheKey}`)
      return NextResponse.json(cached.data)
    }

    recordCacheMiss()
    console.log(`[Cache] MISS ${cacheKey}`)

    let query = supabase
      .from('solutions')
      .select(
        `
        *,
        question:questions (id, question_text, subject, chapter, owner_id),
        author:user_profiles!contributor_id (display_name, avatar_url, username)
      `
      )
      .eq('contributor_id', userId)
      .order('created_at', { ascending: false })

    if (excludeOwnQuestions) {
      query = query.neq('question.owner_id', userId)
    }

    let data: SolutionWithQuestion[] = []
    let hasMore = false
    let nextCursor: string | null = null

    if (cursor) {
      const { data: rawData, error } = await query
        .lt('created_at', cursor)
        .limit(limit + 1)

      if (error) {
        console.error('Error fetching solutions with cursor:', error)
        return NextResponse.json(
          { error: 'Failed to fetch solutions' },
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
        console.error('Error fetching solutions:', error)
        return NextResponse.json(
          { error: 'Failed to fetch solutions' },
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
    console.error('Unexpected error in solutions pagination:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
