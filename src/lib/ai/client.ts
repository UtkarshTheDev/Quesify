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
  getModel(type: ModelType = 'default'): GenerativeModel {
    const modelName = AI_CONFIG.models[type]

    if (!this.models.has(modelName)) {
      this.models.set(modelName, this.genAI.getGenerativeModel({ model: modelName }))
    }

    return this.models.get(modelName)!
  }

  // Generate text content
  async generateText(prompt: string): Promise<string> {
    const model = this.getModel('default')
    const result = await model.generateContent(prompt)
    return result.response.text()
  }

  // Generate content from image
  async generateFromImage(
    imageBase64: string,
    mimeType: string,
    prompt: string
  ): Promise<string> {
    const model = this.getModel('default')
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

  // Parse JSON response with cleanup
  parseJsonResponse<T>(response: string): T {
    const cleaned = response
      .replace(/```json\n?/g, '')
      .replace(/```\n?/g, '')
      .trim()

    try {
      return JSON.parse(cleaned) as T
    } catch (error) {
      console.error('Failed to parse AI response:', cleaned)
      throw new Error('Failed to parse AI response. Please try again.')
    }
  }
}

// Export singleton instance getter
export const getAIClient = () => AIClient.getInstance()

// Export client class for type usage
export { AIClient }
