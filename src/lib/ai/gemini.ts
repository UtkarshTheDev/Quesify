import { GoogleGenerativeAI } from '@google/generative-ai'
import { EXTRACTION_PROMPT, DUPLICATE_ANALYSIS_PROMPT } from './prompts'
import type { GeminiExtractionResult, DuplicateCheckResult } from '@/lib/types'

const genAI = new GoogleGenerativeAI(process.env.GOOGLE_API_KEY!)

export async function extractQuestionFromImage(
  imageBase64: string,
  mimeType: string
): Promise<GeminiExtractionResult> {
  const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' })

  const result = await model.generateContent([
    {
      inlineData: {
        mimeType,
        data: imageBase64,
      },
    },
    { text: EXTRACTION_PROMPT },
  ])

  const response = result.response.text()

  // Clean up response - remove markdown code blocks if present
  const cleanedResponse = response
    .replace(/```json\n?/g, '')
    .replace(/```\n?/g, '')
    .trim()

  try {
    return JSON.parse(cleanedResponse) as GeminiExtractionResult
  } catch (error) {
    console.error('Failed to parse Gemini response:', cleanedResponse)
    throw new Error('Failed to parse AI response. Please try again.')
  }
}

export async function checkDuplicate(
  questionA: string,
  questionB: string
): Promise<DuplicateCheckResult> {
  const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' })

  const prompt = DUPLICATE_ANALYSIS_PROMPT
    .replace('{questionA}', questionA)
    .replace('{questionB}', questionB)

  const result = await model.generateContent(prompt)
  const response = result.response.text()

  const cleanedResponse = response
    .replace(/```json\n?/g, '')
    .replace(/```\n?/g, '')
    .trim()

  try {
    const parsed = JSON.parse(cleanedResponse)
    return {
      is_duplicate: parsed.verdict === 'SAME',
      match_type: parsed.verdict,
      matched_question_id: null, // Will be set by caller
      confidence: parsed.confidence,
      differences: parsed.differences,
    }
  } catch (error) {
    console.error('Failed to parse duplicate check response:', cleanedResponse)
    throw new Error('Failed to analyze duplicate. Please try again.')
  }
}

export async function generateEmbedding(text: string): Promise<number[]> {
  const model = genAI.getGenerativeModel({ model: 'text-embedding-004' })

  const result = await model.embedContent(text)
  return result.embedding.values
}

export async function validateImage(
  imageBase64: string,
  mimeType: string
): Promise<{ isValid: boolean; reason?: string }> {
  const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' })

  const result = await model.generateContent([
    {
      inlineData: {
        mimeType,
        data: imageBase64,
      },
    },
    {
      text: `Is this image a valid educational question (from a textbook, exam, worksheet, etc.)?

Return JSON:
{
  "isValid": true | false,
  "isBlurry": true | false,
  "reason": "Brief explanation if invalid"
}

Return ONLY valid JSON.`,
    },
  ])

  const response = result.response.text()
  const cleanedResponse = response
    .replace(/```json\n?/g, '')
    .replace(/```\n?/g, '')
    .trim()

  try {
    const parsed = JSON.parse(cleanedResponse)
    if (parsed.isBlurry) {
      return { isValid: false, reason: 'Image is too blurry. Please upload a clearer image.' }
    }
    return { isValid: parsed.isValid, reason: parsed.reason }
  } catch {
    return { isValid: true } // Default to valid if parsing fails
  }
}
