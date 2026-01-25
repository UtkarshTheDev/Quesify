import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { ai } from '@/lib/ai'

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await request.json()
    const { questionId } = body

    if (!questionId) {
      return NextResponse.json({ error: 'Question ID is required' }, { status: 400 })
    }

    // Fetch the question to generate solution for
    const { data: question, error: fetchError } = await supabase
      .from('questions')
      .select('question_text, type, subject')
      .eq('id', questionId)
      .single()

    if (fetchError || !question) {
      return NextResponse.json({ error: 'Question not found' }, { status: 404 })
    }

    // Generate solution using AI
    const solutionData = await ai.generateSolution(
      question.question_text,
      question.type,
      question.subject || 'General'
    )

    // Save solution to database
    const { data: savedSolution, error: saveError } = await supabase
      .from('solutions')
      .insert({
        question_id: questionId,
        contributor_id: user.id, // The user (or system bot user) who requested generation
        solution_text: solutionData.solution_text,
        numerical_answer: solutionData.numerical_answer,
        approach_description: solutionData.approach_description,
        is_ai_best: true, // Mark as AI generated/best
        likes: 0
      })
      .select()
      .single()

    if (saveError) {
      console.error('Error saving solution:', saveError)
      return NextResponse.json({ error: 'Failed to save solution' }, { status: 500 })
    }

    return NextResponse.json({
      success: true,
      data: savedSolution
    })

  } catch (error) {
    console.error('Solution generation error:', error)
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Failed to generate solution' },
      { status: 500 }
    )
  }
}
