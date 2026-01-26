import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { ai } from '@/lib/ai'
import { uploadQuestionImage } from '@/lib/storage/upload'

export async function POST(request: NextRequest) {
    try {
        const supabase = await createClient()
        const { data: { user } } = await supabase.auth.getUser()

        if (!user) {
            return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
        }

        const formData = await request.formData()
        const file = formData.get('file') as File
        const subject = formData.get('subject') as string | null

        if (!file) {
            return NextResponse.json({ error: 'No file provided' }, { status: 400 })
        }

        // Convert to base64 for AI processing
        const bytes = await file.arrayBuffer()
        const base64 = Buffer.from(bytes).toString('base64')

        // Step 1: Validate image (is it a question?)
        const validation = await ai.validateImage(base64, file.type)
        if (!validation.isValid) {
            return NextResponse.json({
                error: validation.reason || 'Invalid image. Please upload a clear question image.'
            }, { status: 400 })
        }

        // Step 2: Extract base question content
        const rawExtraction = await ai.extractQuestion(
            base64,
            file.type,
            "General Syllabus Context"
        )

        // Data Normalization (Fix "object object" and missing fields)
        const normalizedData = {
            ...rawExtraction,
            // Ensure options are plain strings, handles { A: "..." } format
            options: (rawExtraction.options || []).map(opt =>
                typeof opt === 'object' ? Object.values(opt)[0] : String(opt)
            ),
            // Ensure specific fields have defaults
            subject: rawExtraction.subject || 'Extracting...',
            chapter: rawExtraction.chapter || 'Extracting...',
            topics: Array.isArray(rawExtraction.topics) ? rawExtraction.topics : [],
            difficulty: rawExtraction.difficulty || 'medium',
            importance: rawExtraction.importance || 3,
        }

        // Step 3: Upload image to storage
        const imageUrl = await uploadQuestionImage(file, user.id)

        // Return Stage 1 results
        return NextResponse.json({
            success: true,
            data: {
                ...normalizedData,
                image_url: imageUrl,
            },
        })
    } catch (error) {
        console.error('[Upload/Extract] Error:', error)
        return NextResponse.json(
            { error: error instanceof Error ? error.message : 'Extraction failed' },
            { status: 500 }
        )
    }
}
