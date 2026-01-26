import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { ai } from '@/lib/ai'
import { uploadQuestionImage } from '@/lib/storage/upload'
import {
  getSyllabus,
  getAllSyllabus,
  formatSyllabusWithTopics,
  formatAllSyllabusWithTopics
} from '@/lib/services/syllabus'

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

    // Step 2: Prepare Syllabus Context (Smart Single-Pass)
    // If user selected a subject, we send only that subject's detailed syllabus.
    // Otherwise, we send the full syllabus. Gemini Flash can handle the context easily.
    let syllabusPromptText = ''

    if (subject && ['Physics', 'Chemistry', 'Mathematics'].includes(subject)) {
      const syllabusData = await getSyllabus(subject)
      syllabusPromptText = `SELECTED SUBJECT: ${subject}\n\n` + formatSyllabusWithTopics(syllabusData)
    } else {
      const allSyllabus = await getAllSyllabus()
      syllabusPromptText = formatAllSyllabusWithTopics(allSyllabus)
    }

    // Step 3: Extract question data with AI (using detailed syllabus for snapping)
    const extractionResult = await ai.extractQuestion(
      base64,
      file.type,
      syllabusPromptText
    )

    // Step 4: Upload image to storage
    const imageUrl = await uploadQuestionImage(file, user.id)

    // Step 5: Generate embedding for duplicate detection
    const embedding = await ai.generateEmbedding(extractionResult.question_text)

    // Step 6: Check for duplicates
    let duplicateResult = null
    try {
      // 6a. Vector search for similar questions
      const { data: similarQuestions } = await supabase.rpc('match_questions', {
        query_embedding: embedding,
        match_threshold: 0.85, // 85% similarity threshold
        match_count: 3
      })

      if (similarQuestions && similarQuestions.length > 0) {
        // 6b. AI verification for the most similar question
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

