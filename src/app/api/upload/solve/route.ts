import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { ai } from '@/lib/ai'

export async function POST(request: NextRequest) {
    const routeStart = performance.now()
    try {
        const supabase = await createClient()
        const { data: { user } } = await supabase.auth.getUser()

        if (!user) {
            return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
        }

        const { question_text, type, subject, options } = await request.json()

        if (!question_text) {
            return NextResponse.json({ error: 'Question text is required' }, { status: 400 })
        }

        // Filter out placeholders
        const cleanSubject = subject === 'Extracting...' || subject === 'Pending...' ? 'General' : subject
        const cleanType = type || 'SA'
        const cleanOptions = Array.isArray(options) ? options : []

        // Generate Solution
        const solStart = performance.now()
        const solutionResult = await ai.generateSolution(
            question_text,
            cleanType,
            cleanSubject,
            cleanOptions
        )
        console.log(`[Route/Solve] AI Solution generation took ${(performance.now() - solStart).toFixed(2)}ms`)

        // Normalize output
        const normalizedSolution = {
            solution: solutionResult.solution_text,
            numerical_answer: solutionResult.numerical_answer || null,
            hint: solutionResult.approach_description || '',
            correct_option: solutionResult.correct_option ?? null,
            avg_solve_time: solutionResult.avg_solve_time || 0,
        }

        console.log(`[Route/Solve] Total route execution: ${(performance.now() - routeStart).toFixed(2)}ms`)

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
