import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { getCache, recordCacheHit, recordCacheMiss, resetCacheHitTracker, setCache, CACHE_KEYS, CACHE_TTL } from '@/lib/cache/api-cache'
import type { CachedResult } from '@/lib/cache/api-cache'

export const dynamic = 'force-dynamic'

export async function GET(request: NextRequest) {
  resetCacheHitTracker()

  try {
    const supabase = await createClient()
    const { searchParams } = new URL(request.url)

    const userId = searchParams.get('user_id')
    const subject = searchParams.get('subject') || undefined
    const chapter = searchParams.get('chapter') || undefined
    const difficulty = searchParams.get('difficulty') || undefined
    const isMCQ = searchParams.get('isMCQ')
    const cursor = searchParams.get('cursor')
    const page = Math.max(1, parseInt(searchParams.get('page') || '1'))
    const limit = Math.min(50, Math.max(1, parseInt(searchParams.get('limit') || '20')))

    const cacheKey = CACHE_KEYS.PAGINATION.QUESTIONS(userId, {
      subject,
      chapter,
      difficulty,
      isMCQ,
    })

    const cached = await getCache(cacheKey)

    if (cached.fromCache) {
      recordCacheHit()
      console.log(`[Cache] HIT ${cacheKey}`)
      return NextResponse.json(cached.data)
    }

    recordCacheMiss()
    console.log(`[Cache] MISS ${cacheKey}`)

    let query = supabase
      .from('user_questions')
      .select(`
        added_at,
        question:questions!inner(
          *,
          solutions(count),
          user_question_stats(*)
        )
      `, { count: 'exact' })
      .order('added_at', { ascending: false })

    if (userId) {
      query = query.eq('user_id', userId)
    }

    if (subject) {
      query = query.eq('question.subject', subject)
    }

    if (chapter) {
      query = query.eq('question.chapter', chapter)
    }

    if (difficulty) {
      query = query.eq('question.difficulty', difficulty)
    }

    if (isMCQ) {
      query = query.eq('question.type', 'MCQ')
    }

    let data: any[] = []
    let count = 0
    let hasMore = false
    let nextCursor: string | null = null

    if (cursor) {
      const { data: rawData, error, count: totalCount } = await query
        .lt('added_at', cursor)
        .limit(limit + 1)

      if (error) {
        console.error('Error fetching questions with cursor:', error)
        return NextResponse.json(
          { error: 'Failed to fetch questions' },
          { status: 500 }
        )
      }

      data = rawData || []
      count = totalCount || 0
      hasMore = data.length > limit

      if (hasMore) {
        data = data.slice(0, limit)
      }

      if (data.length > 0) {
        nextCursor = data[data.length - 1].added_at
      }
    } else {
      const offset = (page - 1) * limit

      const { data: rawData, error, count: totalCount } = await query.range(
        offset,
        offset + limit - 1
      )

      if (error) {
        console.error('Error fetching questions with offset:', error)
        return NextResponse.json(
          { error: 'Failed to fetch questions' },
          { status: 500 }
        )
      }

      data = rawData || []
      count = totalCount || 0
      hasMore = Boolean(count && offset + data.length < count)

      if (hasMore && data.length > 0) {
        nextCursor = data[data.length - 1].added_at
      }
    }

    const questions = data.map((item: any) => {
      const q = item.question
      return {
        ...q,
        user_question_stats: q.user_question_stats?.[0] || null,
      }
    })

    const result = {
      data: questions,
      next_cursor: nextCursor,
      has_more: hasMore,
      total_count: count,
    }

    await setCache(cacheKey, result, CACHE_TTL.PAGINATION)

    return NextResponse.json({
      ...result,
      fromCache: false,
    })
  } catch (error) {
    console.error('Unexpected error in questions pagination:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
