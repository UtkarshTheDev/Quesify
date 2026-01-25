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

    if (!file) {
      return NextResponse.json({ error: 'No file provided' }, { status: 400 })
    }

    // Check file type
    if (!file.type.startsWith('image/')) {
      return NextResponse.json({ error: 'File must be an image' }, { status: 400 })
    }

    // Check file size (max 10MB)
    if (file.size > 10 * 1024 * 1024) {
      return NextResponse.json({ error: 'File size must be less than 10MB' }, { status: 400 })
    }

    // Convert to base64 for AI processing
    const bytes = await file.arrayBuffer()
    const base64 = Buffer.from(bytes).toString('base64')

    // Step 1: Validate image
    const validation = await ai.validateImage(base64, file.type)
    if (!validation.isValid) {
      return NextResponse.json({
        error: validation.reason || 'Invalid image. Please upload a clear question image.'
      }, { status: 400 })
    }

    // Step 2: Extract question data with AI
    const extractionResult = await ai.extractQuestion(base64, file.type)

    // Step 3: Upload image to storage
    const imageUrl = await uploadQuestionImage(file, user.id)

    // Step 4: Generate embedding for duplicate detection
    const embedding = await ai.generateEmbedding(extractionResult.question_text)

    // Step 5: Check for duplicates
    let duplicateResult = null
    try {
      // 5a. Vector search for similar questions
      const { data: similarQuestions } = await supabase.rpc('match_questions', {
        query_embedding: embedding,
        match_threshold: 0.85, // 85% similarity threshold
        match_count: 3
      })

      if (similarQuestions && similarQuestions.length > 0) {
        // 5b. AI verification for the most similar question
        // We only check the top match to save AI tokens and time
        const topMatch = similarQuestions[0]

        console.log('Found similar question:', topMatch.id, 'Similarity:', topMatch.similarity)

        const analysis = await ai.checkDuplicate(
          extractionResult.question_text,
          topMatch.question_text
        )

        if (analysis.is_duplicate) {
          duplicateResult = {
            ...analysis,
            matched_question_id: topMatch.id
          }
        }
      }
    } catch (err) {
      console.error('Duplicate check failed:', err)
      // Continue without duplicate check - don't block upload
    }

    // Return extracted data for user review (don't save yet)
    return NextResponse.json({
      success: true,
      data: {
        ...extractionResult,
        image_url: imageUrl,
        embedding,
        duplicate_check: duplicateResult
      },
    })
  } catch (error) {
    console.error('Upload error:', error)
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Upload failed' },
      { status: 500 }
    )
  }
}
