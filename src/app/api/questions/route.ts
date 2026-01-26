import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import type { GeminiExtractionResult, Question } from '@/lib/types'

interface SaveQuestionRequest extends GeminiExtractionResult {
  image_url: string
  embedding: number[]
  existing_question_id?: string
}

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body: SaveQuestionRequest = await request.json()

    // Scenario 1: Linking to an existing question (Duplicate/Variation)
    if (body.existing_question_id) {
      const questionId = body.existing_question_id

      // Verify question exists
      const { data: existingQuestion, error: fetchError } = await supabase
        .from('questions')
        .select('id')
        .eq('id', questionId)
        .single()

      if (fetchError || !existingQuestion) {
        return NextResponse.json({ error: 'Existing question not found' }, { status: 404 })
      }

      // Check if already linked
      const { data: existingLink } = await supabase
        .from('user_questions')
        .select('id')
        .eq('user_id', user.id)
        .eq('question_id', questionId)
        .single()

      if (!existingLink) {
        // Create link
        await supabase
          .from('user_questions')
          .insert({
            user_id: user.id,
            question_id: questionId,
            is_owner: false, // Not the original uploader
            is_contributor: !!body.solution // Is a contributor if adding a solution
          })
      }

      // Add new solution if provided (rely on content presence)
      if (body.solution && body.solution.trim().length > 0) {
        console.log('Adding solution for linked question:', questionId)
        const { error: solutionError } = await supabase
          .from('solutions')
          .insert({
            question_id: questionId,
            contributor_id: user.id,
            solution_text: body.solution,
            numerical_answer: body.numerical_answer || null,
            correct_option: body.correct_option ?? null,
            approach_description: body.hint ? `Approach (Hint: ${body.hint})` : 'Alternative solution',
            is_ai_best: false, // variation solution
            updated_at: new Date().toISOString(),
          })

        if (solutionError) {
          console.error('Solution insert error:', solutionError)
        } else {
          // Increment solutions count/stats if needed
          await supabase.rpc('increment_solutions_count', { question_id: questionId })
        }
      }

      return NextResponse.json({
        success: true,
        question: existingQuestion,
        linked: true
      })
    }

    // Scenario 2: Creating a new question
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

    // Create solution if provided (rely on content presence)
    if (body.solution && body.solution.trim().length > 0) {
      console.log('Saving solution for new question:', question.id)
      const { error: solutionError } = await supabase
        .from('solutions')
        .insert({
          question_id: question.id,
          contributor_id: user.id,
          solution_text: body.solution,
          numerical_answer: body.numerical_answer || null,
          correct_option: body.correct_option ?? null,
          is_ai_best: true,
          updated_at: new Date().toISOString(),
        })

      if (solutionError) {
        console.error('Solution insert error:', solutionError)
      } else {
        console.log('Solution saved successfully')
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
