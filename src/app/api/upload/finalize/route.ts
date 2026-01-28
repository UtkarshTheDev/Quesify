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

        const { question_text, solution_text } = await request.json()

        if (!question_text) {
            return NextResponse.json({ error: 'Question text is required' }, { status: 400 })
        }

        // Step 1: Generate embedding
        const embedStart = performance.now()
        const embedding = await ai.generateEmbedding(question_text)
        console.log(`[Route/Finalize] AI Embedding took ${(performance.now() - embedStart).toFixed(2)}ms`)

        // Step 2: Check for duplicates
        let duplicateResult = null
        try {
            const dupStart = performance.now()
            // We join with solutions to get the existing solution for comparison
            const { data: similarQuestions } = await supabase.rpc('match_questions_with_solutions', {
                query_embedding: embedding,
                match_threshold: 0.85,
                match_count: 1
            })

            if (similarQuestions && similarQuestions.length > 0) {
                const topMatch = similarQuestions[0]
                const analysis = await ai.checkDuplicate(
                    question_text,
                    solution_text || '',
                    topMatch.question_text,
                    topMatch.solution_text || ''
                )

                if (analysis.is_duplicate) {
                    duplicateResult = {
                        ...analysis,
                        matched_question_id: topMatch.id
                    }
                }
            }
            console.log(`[Route/Finalize] Duplicate check took ${(performance.now() - dupStart).toFixed(2)}ms`)
        } catch (err) {
            console.error('[Upload/Finalize] Duplicate check failed:', err)
        }

        console.log(`[Route/Finalize] Total route execution: ${(performance.now() - routeStart).toFixed(2)}ms`)

        return NextResponse.json({
            success: true,
            data: {
                embedding,
                duplicate_check: duplicateResult
            }
        })
    } catch (error) {
        console.error('[Upload/Finalize] Error:', error)
        return NextResponse.json(
            { error: error instanceof Error ? error.message : 'Finalization failed' },
            { status: 500 }
        )
    }
}
