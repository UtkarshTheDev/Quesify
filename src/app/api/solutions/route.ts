import { createClient } from '@/lib/supabase/server'
import { NextResponse } from 'next/server'

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url)
  const questionId = searchParams.get('questionId')
  const offset = parseInt(searchParams.get('offset') || '0')
  const limit = parseInt(searchParams.get('limit') || '5')

  if (!questionId) {
    return NextResponse.json({ error: 'Question ID is required' }, { status: 400 })
  }

  const supabase = await createClient()

  try {
    const { data: solutions, error } = await supabase
      .from('solutions')
      .select(`
        *,
        author:user_profiles!contributor_id (
          display_name,
          avatar_url
        )
      `)
      .eq('question_id', questionId)
      .order('likes', { ascending: false })
      .order('is_ai_best', { ascending: false })
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1)

    if (error) {
      console.error('Supabase error fetching solutions:', error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    return NextResponse.json({ solutions: solutions || [] })
  } catch (err) {
    console.error('API error in solutions route:', err)
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 })
  }
}
