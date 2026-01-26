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
    const model = this.getModel(modelType)
    const result = await model.generateContent(prompt)
    return result.response.text()
  }

  // Generate content from image
  async generateFromImage(
    imageBase64: string,
    mimeType: string,
    prompt: string,
    modelType: ModelType = 'vision'
  ): Promise<string> {
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
    return result.response.text()
  }

  // Generate embeddings
  async generateEmbedding(text: string): Promise<number[]> {
    const model = this.getModel('embedding')
    const result = await model.embedContent(text)
    return result.embedding.values
  }

  /**
   * Universal JSON handler for AI responses.
   * Extracts JSON from markdown blocks (```json ... ```) or raw strings.
   * Includes a repair layer for "lazy" JSON with unescaped backslashes (common in LaTeX).
   */
  parseAiJson<T>(response: string): T {
    if (AI_CONFIG.debug) {
      console.log('--- AI RAW OUTPUT ---')
      console.log(response)
      console.log('----------------------')
    }

    try {
      // 1. Extract content from code blocks if present
      const jsonMatch = response.match(/```(?:json)?\s*([\s\S]*?)\s*```/)
      let cleaned = jsonMatch ? jsonMatch[1] : response

      // 2. Initial cleanup
      cleaned = cleaned.trim().replace(/^JSON:\s*/i, '')

      // 3. REPAIR LAYER: Handle unescaped backslashes in LaTeX
      // LLMs often forget to double-escape backslashes in JSON strings (e.g., writing \pi instead of \\pi)
      // We escape all backslashes first, then "revert" the valid JSON escape sequences.
      let repaired = cleaned
        .replace(/\\/g, '\\\\') // Double every backslash
        // Revert valid JSON escapes: \", \\, \/, \b, \f, \n, \r, \t
        // We look for \\ followed by the escape char and turn it into \ followed by the char
        .replace(/\\\\(["\\\/bfnrt])/g, '\\$1')
        // Revert unicode escapes: \uXXXX
        .replace(/\\\\u([0-9a-fA-F]{4})/g, '\\u$1')

      // 4. Handle a common edge case where the AI returns raw multiline strings that are technically invalid JSON
      // but meant to be newlines
      repaired = repaired.replace(/\n/g, '\\n')

      // Wait, if I replace literal newlines with \n, I might break the JSON structure if they are OUTSIDE strings.
      // Actually, standard AI JSON uses literal newlines for readability.
      // Most of the time, the AI returns valid JSON structure with multiline strings.
      // Let's try parsing first, and only do more invasive repairs if it fails.

      try {
        return JSON.parse(repaired) as T
      } catch (innerError) {
        // If the double-escape failed (likely due to newlines outside strings), try the original cleaned version
        // but with a lighter repair.
        const lightRepair = cleaned.replace(/\\(?![/"\\bfnrtu])/g, '\\\\')
        return JSON.parse(lightRepair) as T
      }
    } catch (error) {
      console.error('JSON Parse Failure. Error:', error)
      throw new Error(`Failed to parse AI response as JSON: ${error instanceof Error ? error.message : 'Unknown error'}`)
    }
  }
}

// Export singleton instance getter
export const getAIClient = () => AIClient.getInstance()

// Export client class for type usage
export { AIClient }
