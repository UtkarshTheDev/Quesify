import { createClient } from '@/lib/supabase/server'
import { NextRequest, NextResponse } from 'next/server'

export const dynamic = 'force-dynamic'

export async function GET(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { searchParams } = new URL(request.url)
    
    const userId = searchParams.get('user_id')
    const subject = searchParams.get('subject')
    const chapter = searchParams.get('chapter')
    const difficulty = searchParams.get('difficulty')
    const isMCQ = searchParams.get('isMCQ')
    const cursor = searchParams.get('cursor')
    const page = Math.max(1, parseInt(searchParams.get('page') || '1'))
    const limit = Math.min(50, Math.max(1, parseInt(searchParams.get('limit') || '20')))
    
    let query = supabase
      .from('user_questions')
      .select(
        `
        added_at,
        question:questions!inner(
          *,
          solutions(count),
          user_question_stats(*)
        )
      `,
        { count: 'exact' }
      )
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
    
    if (isMCQ !== null) {
      if (isMCQ === 'true') {
        query = query.eq('question.type', 'MCQ')
      } else if (isMCQ === 'false') {
        query = query.neq('question.type', 'MCQ')
      }
    }
    
    let data: any[]
    let count: number | null
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
      count = totalCount
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
      count = totalCount
      hasMore = count ? offset + data.length < count : false
      
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
    
    return NextResponse.json({
      data: questions,
      next_cursor: nextCursor,
      has_more: hasMore,
      total_count: count,
    })
  } catch (error) {
    console.error('Unexpected error in questions pagination:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
