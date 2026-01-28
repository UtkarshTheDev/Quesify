import { GoogleGenerativeAI, GenerativeModel } from '@google/generative-ai'
import { AI_CONFIG, ModelType } from './config'

// Singleton AI client
class AIClient {
  private static instance: AIClient
  private genAI: GoogleGenerativeAI
  private models: Map<string, GenerativeModel> = new Map()

  private constructor() {
    const apiKey = process.env.GOOGLE_API_KEY
    if (!apiKey) {
      throw new Error('GOOGLE_API_KEY environment variable is not set')
    }
    this.genAI = new GoogleGenerativeAI(apiKey)
  }

  static getInstance(): AIClient {
    if (!AIClient.instance) {
      AIClient.instance = new AIClient()
    }
    return AIClient.instance
  }

  // Get a model instance (cached)
  getModel(type: ModelType = 'fast'): GenerativeModel {
    const modelName = AI_CONFIG.models[type]

    if (!this.models.has(modelName)) {
      this.models.set(modelName, this.genAI.getGenerativeModel({ model: modelName }))
    }

    return this.models.get(modelName)!
  }

  // Generate text content
  async generateText(prompt: string, modelType: ModelType = 'fast'): Promise<string> {
    const start = performance.now()
    const model = this.getModel(modelType)
    const result = await model.generateContent(prompt)
    const duration = performance.now() - start
    if (AI_CONFIG.debug) {
      console.log(`[AI/Text] ${modelType} took ${duration.toFixed(2)}ms`)
    }
    return result.response.text()
  }

  // Generate content from image
  async generateFromImage(
    imageBase64: string,
    mimeType: string,
    prompt: string,
    modelType: ModelType = 'vision'
  ): Promise<string> {
    const start = performance.now()
    const model = this.getModel(modelType)
    const result = await model.generateContent([
      {
        inlineData: {
          mimeType,
          data: imageBase64,
        },
      },
      { text: prompt },
    ])
    const duration = performance.now() - start
    if (AI_CONFIG.debug) {
      console.log(`[AI/Vision] ${modelType} took ${duration.toFixed(2)}ms`)
    }
    return result.response.text()
  }

  // Generate embeddings
  async generateEmbedding(text: string): Promise<number[]> {
    const start = performance.now()
    const model = this.getModel('embedding')
    // Explicitly set output dimensionality to 768 to match database constraints
    const result = await model.embedContent({
      content: { parts: [{ text }] },
      outputDimensionality: 768,
    })
    const duration = performance.now() - start
    if (AI_CONFIG.debug) {
      console.log(`[AI/Embedding] took ${duration.toFixed(2)}ms`)
    }
    return result.embedding.values
  }

  /**
   * Universal JSON handler for AI responses.
   * Extracts JSON from markdown blocks (```json ... ```) or raw strings.
   * Includes a 3-tier repair layer for "lazy" JSON with unescaped backslashes and literal newlines.
   */
  parseAiJson<T>(response: string): T {
    try {
      // 1. Extract content from code blocks
      const jsonMatch = response.match(/```(?:json)?\s*([\s\S]*?)\s*```/)
      const rawText = jsonMatch ? jsonMatch[1] : response
      let cleaned = rawText.trim().replace(/^JSON:\s*/i, '')

      // TIER 1: Standard Parse
      try {
        return JSON.parse(cleaned) as T
      } catch (e) {
        // Continue to Tier 2
      }

      // TIER 2: SMART BACKSLASH REPAIR
      // LLMs often forget to escape backslashes in JSON strings (e.g., writing \int instead of \\int)
      // We escape every backslash, then REVERT the ones that were already correctly escaped 
      // or are part of valid JSON escape sequences.
      let repaired = cleaned
        .replace(/\\/g, '\\\\') // Step 1: Double every backslash
        // Step 2: Revert valid JSON escapes (", \, /, b, f, n, r, t, uXXXX)
        // We look for \\ followed by the escape char or u + 4 digits
        .replace(/\\\\(["\\\/bfnrt])/g, '\\$1')
        .replace(/\\\\u([0-9a-fA-F]{4})/g, '\\u$1')

      try {
        return JSON.parse(repaired) as T
      } catch (e) {
        // Continue to Tier 3
      }

      // TIER 3: AGGRESSIVE LITERAL CLEANUP
      // Some models return literal newlines or tabs INSIDE strings, which is invalid JSON.
      // We try to escape them IF they look like they are inside a JSON string.
      // This is a last resort as it's regex-heavy.
      let aggressiveRepaired = repaired
        // Replace literal newlines/tabs ONLY inside "..." blocks
        .replace(/"([\s\S]*?)"/g, (match, p1) => {
          return `"${p1.replace(/\n/g, '\\n').replace(/\t/g, '\\t')}"`
        })

      try {
        return JSON.parse(aggressiveRepaired) as T
      } catch (error) {
        console.error('Final Parse Failure. Repaired text:', aggressiveRepaired)
        throw new Error(`Failed to parse AI response as JSON: ${error instanceof Error ? error.message : 'Unknown error'}`)
      }
    } catch (error) {
      console.error('JSON Extraction Failure:', error)
      throw new Error(`Failed to process AI response: ${error instanceof Error ? error.message : 'Unknown error'}`)
    }
  }
}

// Export singleton instance getter
export const getAIClient = () => AIClient.getInstance()

// Export client class for type usage
export { AIClient }
