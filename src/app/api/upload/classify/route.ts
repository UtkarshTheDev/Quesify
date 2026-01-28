import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { getSyllabus, formatSyllabusWithTopics } from '@/lib/services/syllabus'
import { ai } from '@/lib/ai'

export async function POST(request: NextRequest) {
    const routeStart = performance.now()
    try {
        const supabase = await createClient()
        const { data: { user } } = await supabase.auth.getUser()

        if (!user) {
            return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
        }

        const { question_text, subject } = await request.json()

        if (!question_text) {
            return NextResponse.json({ error: 'Question text is required' }, { status: 400 })
        }

        // Prepare Syllabus Context (Optimized)
        let syllabusPromptText = ''

        if (subject && subject !== 'Uncategorized' && subject !== 'General') {
            // Context-aware: fetch only relevant subject
            const subjectSyllabus = await getSyllabus(subject)
            syllabusPromptText = formatSyllabusWithTopics(subjectSyllabus)
        } else {
            // Fallback: minimal context or skip
            syllabusPromptText = "Subject unknown. Please infer based on general knowledge."
        }

        // Analyze Classification
        const classStart = performance.now()
        const classificationResult = await ai.classifyQuestion(
            question_text,
            syllabusPromptText
        )
        console.log(`[Route/Classify] AI Classification took ${(performance.now() - classStart).toFixed(2)}ms`)

        console.log(`[Route/Classify] Total route execution: ${(performance.now() - routeStart).toFixed(2)}ms`)

        return NextResponse.json({
            success: true,
            data: classificationResult
        })
    } catch (error) {
        console.error('[Upload/Classify] Error:', error)
        return NextResponse.json(
            { error: error instanceof Error ? error.message : 'Classification failed' },
            { status: 500 }
        )
    }
}
