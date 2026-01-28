// AI Services - High-level AI operations for the app

import { getAIClient } from './client'
import { PROMPTS, formatPrompt } from './prompts'
import { AI_CONFIG } from './config'
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
  correct_option: number | null
  avg_solve_time: number
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
      const parsed = client.parseAiJson<ImageValidationResponse>(response)

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
   * Now performs Validation + Extraction + Subject ID in one shot
   */
  async extractQuestion(
    imageBase64: string,
    mimeType: string,
    subjectsList: string[]
  ): Promise<GeminiExtractionResult & { isValid: boolean; reason?: string }> {
    const client = getAIClient()

    const prompt = formatPrompt(PROMPTS.extraction, {
      subjectsList: subjectsList.join(', ')
    })

    const response = await client.generateFromImage(
      imageBase64,
      mimeType,
      prompt,
      'vision'
    )

    const result = client.parseAiJson<GeminiExtractionResult & { isValid: boolean; reason?: string }>(response)

    // Default to true if not present (legacy support)
    if (result.isValid === undefined) {
      result.isValid = true
    }

    return result
  },

  /**
   * Check if two questions are duplicates
   */
  async checkDuplicate(
    questionA: string,
    solutionA: string,
    questionB: string,
    solutionB: string
  ): Promise<DuplicateCheckResult> {
    const client = getAIClient()

    const prompt = formatPrompt(PROMPTS.duplicateAnalysis, {
      questionA,
      solutionA,
      questionB,
      solutionB,
    })

    const response = await client.generateText(prompt, 'fast')
    const parsed = client.parseAiJson<DuplicateAnalysisResponse>(response)

    if (AI_CONFIG.debug) {
      console.log('[AI/CheckDuplicate] Response:', JSON.stringify(parsed, null, 2))
    }

    return {
      is_duplicate: parsed.verdict === 'SAME' || parsed.verdict === 'DIFFERENT_APPROACH',
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
    subject: string,
    options: string[] = []
  ): Promise<SolutionGenerationResponse> {
    const client = getAIClient()

    const optionsText = options.length > 0
      ? options.map((opt, i) => `${i}. ${opt}`).join('\n')
      : 'No specific options provided.'

    const prompt = formatPrompt(PROMPTS.solutionGeneration, {
      questionText,
      questionType,
      subject,
      options: optionsText
    })

    const response = await client.generateText(prompt, 'reasoning')
    return client.parseAiJson<SolutionGenerationResponse>(response)
  },

  /**
   * Classify a question and map to syllabus
   */
  async classifyQuestion(
    questionText: string,
    syllabusChapters: string
  ): Promise<GeminiExtractionResult> {
    const client = getAIClient()

    const prompt = formatPrompt(PROMPTS.classification, {
      questionText,
      syllabusChapters,
    })

    const response = await client.generateText(prompt, 'fast')
    return client.parseAiJson<GeminiExtractionResult>(response)
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
    const parsed = client.parseAiJson<ChartGenerationResponse>(response)

    return parsed.charts.map((chart, index) => ({
      id: `chart-${Date.now()}-${index}`,
      ...chart,
      type: chart.type as Chart['type'],
    }))
  },

  /**
   * Sync/Regenerate approach description from solution text
   */
  async syncApproachFromSolution(solutionText: string): Promise<string> {
    const client = getAIClient()
    const prompt = formatPrompt(PROMPTS.approachSync, { solutionText })
    const response = await client.generateText(prompt, 'fast')
    return response.trim()
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
    return client.parseAiJson<T>(response)
  },
}

export type AIService = typeof ai
