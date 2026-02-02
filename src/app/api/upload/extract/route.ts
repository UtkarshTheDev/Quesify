import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { ai } from '@/lib/ai'
import { uploadQuestionImage } from '@/lib/storage/upload'
import { getSubjectsList } from '@/lib/services/syllabus'
import { applyRateLimit } from '@/lib/ratelimit/client'

export async function POST(request: NextRequest) {
    const routeStart = performance.now()
    
    const rateLimitResult = await applyRateLimit(request, 'upload')
    if (!rateLimitResult.success && rateLimitResult.response) {
        return rateLimitResult.response
    }
    
    try {
        const supabase = await createClient()
        const { data: { user } } = await supabase.auth.getUser()

        if (!user) {
            return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
        }

        const formData = await request.formData()
        const file = formData.get('file') as File
        const isRegeneration = formData.get('regenerate') === 'true'

        if (!file) {
            return NextResponse.json({ error: 'No file provided' }, { status: 400 })
        }

        // Convert to base64 for AI processing
        const bytes = await file.arrayBuffer()
        const base64 = Buffer.from(bytes).toString('base64')

        // Fetch subjects for AI context (Optimized)
        const subjectsList = await getSubjectsList()

        // Step 1: Validate & Extract (Consolidated Phase)
        const extStart = performance.now()
        const rawExtraction = await ai.extractQuestion(
            base64,
            file.type,
            subjectsList,
            { useBestModel: isRegeneration }
        )
        console.log(`[Route/Extract] Consolidated AI Extraction took ${(performance.now() - extStart).toFixed(2)}ms`)

        if (!rawExtraction.isValid) {
            return NextResponse.json({
                error: rawExtraction.reason || 'Invalid image. Please upload a clear question image.'
            }, { status: 400 })
        }

        const isActuallyMCQ = !!rawExtraction.isMCQ;
        const normalizedData = {
            ...rawExtraction,
            options: isActuallyMCQ 
                ? (rawExtraction.options || []).map(opt =>
                    typeof opt === 'object' ? Object.values(opt)[0] : String(opt)
                  )
                : [],
            isMCQ: isActuallyMCQ,
            type: rawExtraction.type || (isActuallyMCQ ? 'MCQ' : 'SA'),
            subject: rawExtraction.subject || 'Uncategorized',
            chapter: 'Pending...', // Will be filled in Classify phase
            topics: [],
            difficulty: 'medium',
            importance: 3,
            correct_option: null, // Will be filled in Solution phase
            has_diagram: rawExtraction.has_diagram ?? false,
        }

        // Step 2: Upload image to storage
        const storageStart = performance.now()
        const imageUrl = await uploadQuestionImage(file, user.id)
        console.log(`[Route/Extract] Storage Upload took ${(performance.now() - storageStart).toFixed(2)}ms`)

        console.log(`[Route/Extract] Total route execution: ${(performance.now() - routeStart).toFixed(2)}ms`)

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
