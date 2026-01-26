import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { ai } from '@/lib/ai'
import { getAllSyllabus } from '@/lib/services/syllabus'
import { formatSyllabusAsToon } from '@/lib/ai/toon'

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

        // Prepare Syllabus Context
        const allSyllabus = await getAllSyllabus()
        const syllabusPromptText = formatSyllabusAsToon(allSyllabus)

        // Analyze Classification
        const classificationResult = await ai.classifyQuestion(
            question_text,
            syllabusPromptText
        )

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
