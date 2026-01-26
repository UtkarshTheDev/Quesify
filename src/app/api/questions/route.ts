import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import type { GeminiExtractionResult, Question } from '@/lib/types'

interface SaveQuestionRequest extends GeminiExtractionResult {
  image_url: string
  embedding: number[]
}

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body: SaveQuestionRequest = await request.json()

    // TODO: Check for duplicates using embedding similarity
    // For MVP, we'll skip duplicate detection and save directly

    // Create question
    const { data: question, error: questionError } = await supabase
      .from('questions')
      .insert({
        owner_id: user.id,
        question_text: body.question_text,
        options: body.options,
        type: body.type,
        has_diagram: body.has_diagram,
        image_url: body.image_url,
        subject: body.subject,
        chapter: body.chapter,
        topics: body.topics,
        difficulty: body.difficulty,
        importance: body.importance,
        hint: body.hint,
        embedding: body.embedding,
      })
      .select()
      .single()

    if (questionError) {
      console.error('Question insert error:', questionError)
      return NextResponse.json({ error: 'Failed to save question' }, { status: 500 })
    }

    // Create solution if provided
    if (body.solution && body.has_solution) {
      const { error: solutionError } = await supabase
        .from('solutions')
        .insert({
          question_id: question.id,
          contributor_id: user.id,
          solution_text: body.solution,
          numerical_answer: body.numerical_answer,
          is_ai_best: true,
        })

      if (solutionError) {
        console.error('Solution insert error:', solutionError)
      }
    }

    // Create user-question link
    const { error: linkError } = await supabase
      .from('user_questions')
      .insert({
        user_id: user.id,
        question_id: question.id,
        is_owner: true,
      })

    if (linkError) {
      console.error('User-question link error:', linkError)
    }

    // Update user profile stats
    const { data: profile } = await supabase
      .from('user_profiles')
      .select('total_uploaded')
      .eq('user_id', user.id)
      .single()

    if (profile) {
      await supabase
        .from('user_profiles')
        .update({
          total_uploaded: (profile.total_uploaded || 0) + 1,
        })
        .eq('user_id', user.id)
    }

    return NextResponse.json({
      success: true,
      question: question
    })
  } catch (error) {
    console.error('Save question error:', error)
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Save failed' },
      { status: 500 }
    )
  }
}

export async function GET(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const { searchParams } = new URL(request.url)
    const subject = searchParams.get('subject')
    const chapter = searchParams.get('chapter')
    const limit = parseInt(searchParams.get('limit') || '20')
    const offset = parseInt(searchParams.get('offset') || '0')

    const query = supabase
      .from('user_questions')
      .select(`
        question:questions(
          *,
          solutions(*)
        )
      `)
      .eq('user_id', user.id)
      .range(offset, offset + limit - 1)
      .order('added_at', { ascending: false })

    const { data, error } = await query

    if (error) {
      return NextResponse.json({ error: 'Failed to fetch questions' }, { status: 500 })
    }

    // Filter by subject/chapter if provided (post-query filtering)
    let questions = (data?.map(d => d.question).filter(Boolean) || []) as unknown as Question[]

    if (subject) {
      questions = questions.filter((q) => q.subject === subject)
    }
    if (chapter) {
      questions = questions.filter((q) => q.chapter === chapter)
    }

    return NextResponse.json({
      questions
    })
  } catch (error) {
    console.error('Fetch questions error:', error)
    return NextResponse.json(
      { error: 'Failed to fetch questions' },
      { status: 500 }
    )
  }
}
