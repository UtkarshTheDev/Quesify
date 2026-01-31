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

        const { question_text, solution_text, regenerate } = await request.json()

        if (!question_text) {
            return NextResponse.json({ error: 'Question text is required' }, { status: 400 })
        }

        // Step 1: Generate embedding
        const embedStart = performance.now()
        const embedding = await ai.generateEmbedding(question_text)
        console.log(`[Route/Finalize] AI Embedding generated. Length: ${embedding.length}, Sample: [${embedding.slice(0, 3)}...]`)
        console.log(`[Route/Finalize] AI Embedding took ${(performance.now() - embedStart).toFixed(2)}ms`)

        // Step 2: Check for duplicates
        let duplicateResult = null
        try {
            const dupStart = performance.now()
            // We join with solutions to get the existing solution for comparison
            // DEBUG: Lowered threshold to 0.6 to debug matching issues
            const { data: similarQuestions, error: matchError } = await supabase.rpc('match_questions_with_solutions', {
                query_embedding: embedding,
                match_threshold: 0.60, 
                match_count: 1
            })

            if (matchError) {
                console.error('[Route/Finalize] Match RPC Error:', matchError)
            } else {
                console.log(`[Route/Finalize] RPC found ${similarQuestions?.length || 0} matches. Top similarity: ${similarQuestions?.[0]?.similarity}`)
            }

            if (similarQuestions && similarQuestions.length > 0) {
                const topMatch = similarQuestions[0]
                console.log(`[Route/Finalize] Checking duplicate against ID: ${topMatch.id}`)
                
                const analysis = await ai.checkDuplicate(
                    question_text,
                    solution_text || '',
                    topMatch.question_text,
                    topMatch.matched_solution_text || '',
                    { useBestModel: !!regenerate }
                )

                console.log(`[Route/Finalize] AI Verdict: ${analysis.match_type}, Confidence: ${analysis.confidence}`)

                if (analysis.is_duplicate) {
                    // Fetch original author profile
                    let author = null
                    if (topMatch.owner_id) {
                        const { data: profile } = await supabase
                            .from('user_profiles')
                            .select('display_name, avatar_url')
                            .eq('user_id', topMatch.owner_id)
                            .single()
                        
                        if (profile) {
                            author = profile
                        }
                    }

                    duplicateResult = {
                        ...analysis,
                        matched_question_id: topMatch.id,
                        author
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
