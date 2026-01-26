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

        const { question_text, type, subject, chapter } = await request.json()

        if (!question_text) {
            return NextResponse.json({ error: 'Question text is required' }, { status: 400 })
        }

        // Filter out placeholders
        const cleanSubject = subject === 'Extracting...' || subject === 'Pending...' ? 'General' : subject
        const cleanType = type || 'SA'

        // Generate Solution
        const solutionResult = await ai.generateSolution(
            question_text,
            cleanType,
            cleanSubject
        )

        // Normalize output
        const normalizedSolution = {
            solution: solutionResult.solution_text,
            numerical_answer: solutionResult.numerical_answer || null,
            hint: solutionResult.approach_description || '',
        }

        return NextResponse.json({
            success: true,
            data: normalizedSolution,
        })
    } catch (error) {
        console.error('[Upload/Solve] Error:', error)
        return NextResponse.json(
            { error: error instanceof Error ? error.message : 'Solution generation failed' },
            { status: 500 }
        )
    }
}
