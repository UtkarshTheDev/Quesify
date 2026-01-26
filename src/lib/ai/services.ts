// AI Services - High-level AI operations for the app

import { getAIClient } from './client'
import { PROMPTS, formatPrompt } from './prompts'
import type { GeminiExtractionResult, DuplicateCheckResult, Chart } from '@/lib/types'

// Response types for internal use
interface ImageValidationResponse {
  isValid: boolean
  isBlurry: boolean
  reason?: string
}

interface DuplicateAnalysisResponse {
  same_concept: boolean
  same_approach: boolean
  differences: string
  verdict: 'SAME' | 'DIFFERENT_APPROACH' | 'DIFFERENT_QUESTION'
  confidence: number
}

interface ChartGenerationResponse {
  charts: Array<{
    name: string
    description: string
    question_ids: string[]
    count: number
    type: 'daily_feed' | 'topic_review' | 'quick_mcq' | 'weak_areas'
  }>
}

interface SolutionGenerationResponse {
  solution_text: string
  numerical_answer: string | null
  approach_description: string
}

/**
 * AI Service - Centralized AI operations
 */
export const ai = {
  /**
   * Validate if an image is a valid educational question
   */
  async validateImage(
    imageBase64: string,
    mimeType: string
  ): Promise<{ isValid: boolean; reason?: string }> {
    const client = getAIClient()

    const response = await client.generateFromImage(
      imageBase64,
      mimeType,
      PROMPTS.imageValidation,
      'fast'
    )

    try {
      const parsed = client.parseJsonResponse<ImageValidationResponse>(response)

      if (parsed.isBlurry) {
        return { isValid: false, reason: 'Image is too blurry. Please upload a clearer image.' }
      }

      return { isValid: parsed.isValid, reason: parsed.reason }
    } catch {
      // Default to valid if parsing fails
      return { isValid: true }
    }
  },

  /**
   * Extract question data from an image
   */
  async extractQuestion(
    imageBase64: string,
    mimeType: string,
    syllabusChapters?: string
  ): Promise<GeminiExtractionResult> {
    const client = getAIClient()

    // Format the extraction prompt with syllabus chapters if provided
    const prompt = syllabusChapters
      ? formatPrompt(PROMPTS.extraction, { syllabusChapters })
      : formatPrompt(PROMPTS.extraction, {
        syllabusChapters: 'No syllabus available - use your best judgment for chapter names'
      })

    const response = await client.generateFromImage(
      imageBase64,
      mimeType,
      prompt,
      'vision'
    )

    return client.parseToonResponse<GeminiExtractionResult>(response)
  },

  /**
   * Check if two questions are duplicates
   */
  async checkDuplicate(
    questionA: string,
    questionB: string
  ): Promise<DuplicateCheckResult> {
    const client = getAIClient()

    const prompt = formatPrompt(PROMPTS.duplicateAnalysis, {
      questionA,
      questionB,
    })

    const response = await client.generateText(prompt, 'fast')
    const parsed = client.parseJsonResponse<DuplicateAnalysisResponse>(response)

    return {
      is_duplicate: parsed.verdict === 'SAME',
      match_type: parsed.verdict,
      matched_question_id: null, // Set by caller
      confidence: parsed.confidence,
      differences: parsed.differences,
    }
  },

  /**
   * Generate a solution for a question
   */
  async generateSolution(
    questionText: string,
    questionType: string,
    subject: string
  ): Promise<SolutionGenerationResponse> {
    const client = getAIClient()

    const prompt = formatPrompt(PROMPTS.solutionGeneration, {
      questionText,
      questionType,
      subject,
    })

    const response = await client.generateText(prompt, 'reasoning')
    return client.parseToonResponse<SolutionGenerationResponse>(response)
  },

  /**
   * Tweak content based on user instruction
   */
  async tweakContent(
    originalContent: string,
    contentType: 'solution' | 'hint' | 'question' | 'tags',
    userInstruction: string
  ): Promise<string> {
    const client = getAIClient()

    const prompt = formatPrompt(PROMPTS.contentTweaking, {
      originalContent,
      contentType,
      userInstruction,
    })

    const response = await client.generateText(prompt, 'fast')
    return response.trim()
  },

  /**
   * Generate text embedding for semantic search
   */
  async generateEmbedding(text: string): Promise<number[]> {
    const client = getAIClient()
    return client.generateEmbedding(text)
  },

  /**
   * Generate personalized charts/feeds for a user
   */
  async generateCharts(params: {
    weakChapters: string[]
    recentSubjects: string[]
    struggleRates: Record<string, number>
    totalQuestions: number
    questionCategories: Record<string, string[]>
  }): Promise<Chart[]> {
    const client = getAIClient()

    const prompt = formatPrompt(PROMPTS.chartGeneration, {
      weakChapters: JSON.stringify(params.weakChapters),
      recentSubjects: JSON.stringify(params.recentSubjects),
      struggleRates: JSON.stringify(params.struggleRates),
      totalQuestions: String(params.totalQuestions),
      questionCategories: JSON.stringify(params.questionCategories),
    })

    const response = await client.generateText(prompt, 'reasoning')
    const parsed = client.parseToonResponse<ChartGenerationResponse>(response)

    return parsed.charts.map((chart, index) => ({
      id: `chart-${Date.now()}-${index}`,
      ...chart,
      type: chart.type as Chart['type'],
    }))
  },

  /**
   * Generic text generation
   */
  async generateText(prompt: string): Promise<string> {
    const client = getAIClient()
    return client.generateText(prompt, 'fast')
  },

  /**
   * Generic image analysis
   */
  async analyzeImage<T>(
    imageBase64: string,
    mimeType: string,
    prompt: string
  ): Promise<T> {
    const client = getAIClient()
    const response = await client.generateFromImage(imageBase64, mimeType, prompt, 'vision')
    return client.parseJsonResponse<T>(response)
  },
}

export type AIService = typeof ai
