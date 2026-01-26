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

        const { question_text } = await request.json()

        if (!question_text) {
            return NextResponse.json({ error: 'Question text is required' }, { status: 400 })
        }

        // Step 1: Generate embedding
        const embedding = await ai.generateEmbedding(question_text)

        // Step 2: Check for duplicates
        let duplicateResult = null
        try {
            const { data: similarQuestions } = await supabase.rpc('match_questions', {
                query_embedding: embedding,
                match_threshold: 0.85,
                match_count: 1
            })

            if (similarQuestions && similarQuestions.length > 0) {
                const topMatch = similarQuestions[0]
                const analysis = await ai.checkDuplicate(question_text, topMatch.question_text)

                if (analysis.is_duplicate) {
                    duplicateResult = {
                        ...analysis,
                        matched_question_id: topMatch.id
                    }
                }
            }
        } catch (err) {
            console.error('[Upload/Finalize] Duplicate check failed:', err)
        }

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
