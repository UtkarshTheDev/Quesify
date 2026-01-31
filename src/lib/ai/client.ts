import { GoogleGenerativeAI, GenerativeModel, EmbedContentRequest } from '@google/generative-ai'
import Groq from 'groq-sdk'
import { AI_CONFIG, ModelType } from './config'

class AIClient {
  private static instance: AIClient
  private genAI: GoogleGenerativeAI
  private groq: Groq
  private geminiModels: Map<string, GenerativeModel> = new Map()

  private constructor() {
    const geminiKey = process.env.GEMINI_API_KEY
    if (!geminiKey) {
      throw new Error('GEMINI_API_KEY environment variable is not set')
    }
    this.genAI = new GoogleGenerativeAI(geminiKey)

    const groqKey = process.env.GROQ_API_KEY
    if (!groqKey) {
      throw new Error('GROQ_API_KEY environment variable is not set')
    }
    this.groq = new Groq({ apiKey: groqKey })
  }

  static getInstance(): AIClient {
    if (!AIClient.instance) {
      AIClient.instance = new AIClient()
    }
    return AIClient.instance
  }

  private getGeminiModel(modelName: string): GenerativeModel {
    if (!this.geminiModels.has(modelName)) {
      this.geminiModels.set(modelName, this.genAI.getGenerativeModel({ model: modelName }))
    }
    return this.geminiModels.get(modelName)!
  }

  async generateText(prompt: string, modelType: ModelType = 'fast'): Promise<string> {
    const config = AI_CONFIG.models[modelType]
    const start = performance.now()
    let text = ""

    if (config.provider === 'gemini') {
      const model = this.getGeminiModel(config.model)
      const result = await model.generateContent(prompt)
      text = result.response.text()
    } else if (config.provider === 'groq') {
      const completion = await this.groq.chat.completions.create({
        messages: [{ role: 'user', content: prompt }],
        model: config.model,
        temperature: AI_CONFIG.generation.temperature,
      })
      text = completion.choices[0]?.message?.content || ""
    }

    const duration = performance.now() - start
    if (AI_CONFIG.debug) {
      console.log(`[AI/Text] ${modelType} (${config.provider}/${config.model}) took ${duration.toFixed(2)}ms`)
    }
    return text
  }

  async generateFromImage(
    imageBase64: string,
    mimeType: string,
    prompt: string,
    modelType: ModelType = 'vision'
  ): Promise<string> {
    const config = AI_CONFIG.models[modelType]
    const start = performance.now()
    let text = ""

    if (config.provider === 'gemini') {
      const model = this.getGeminiModel(config.model)
      const result = await model.generateContent([
        {
          inlineData: {
            mimeType,
            data: imageBase64,
          },
        },
        { text: prompt },
      ])
      text = result.response.text()
    } else if (config.provider === 'groq') {
      const completion = await this.groq.chat.completions.create({
        messages: [
          {
            role: 'user',
            content: [
              { type: 'text', text: prompt },
              {
                type: 'image_url',
                image_url: {
                  url: `data:${mimeType};base64,${imageBase64}`,
                },
              },
            ],
          },
        ],
        model: config.model,
      })
      text = completion.choices[0]?.message?.content || ""
    }

    const duration = performance.now() - start
    if (AI_CONFIG.debug) {
      console.log(`[AI/Vision] ${modelType} (${config.provider}/${config.model}) took ${duration.toFixed(2)}ms`)
    }
    return text
  }

  async generateEmbedding(text: string): Promise<number[]> {
    const config = AI_CONFIG.models.embedding
    const start = performance.now()
    
    if (config.provider !== 'gemini') {
      throw new Error('Only Gemini provider is supported for embeddings currently')
    }

    const model = this.getGeminiModel(config.model)
    
    const request = {
      content: { role: 'user', parts: [{ text }] },
      outputDimensionality: 768,
    } as unknown as EmbedContentRequest
    
    const result = await model.embedContent(request)

    const duration = performance.now() - start
    if (AI_CONFIG.debug) {
      console.log(`[AI/Embedding] took ${duration.toFixed(2)}ms`)
    }
    return result.embedding.values
  }

  parseAiJson<T>(response: string): T {
    try {
      // Step 1: Handle Gemini's common markdown blocks (```json ... ``` or ``` ... ```)
      // Also handles cases where response is just "Here is the JSON: { ... }"
      let rawText = response

      // Check for markdown code blocks
      const jsonMatch = response.match(/```(?:json)?\s*([\s\S]*?)\s*```/)
      if (jsonMatch) {
        rawText = jsonMatch[1]
      } else {
        // If no code block, check for common prefixes like "Here is the JSON:" or "Response:"
        const prefixMatch = response.match(/^(?:Here is|Here is the|Sure, here).*?:\s*([\s\S]*)$/i)
        if (prefixMatch) {
          rawText = prefixMatch[1]
        }
      }

      // Step 2: Trim and clean leading/trailing whitespace
      const cleaned = rawText.trim().replace(/^JSON:\s*/i, '')

      // Step 3: Attempt direct parse
      try {
        return JSON.parse(cleaned) as T
      } catch (e) {}


        const repaired = cleaned.replace(/(\\\\)|(\\)(?![n"\\/u])/g, (match, p1) => {
        if (p1) return p1 
        return "\\\\" 
      })



      try {
        return JSON.parse(repaired) as T
      } catch (e) {}

      // Step 5: Aggressive repair - try to fix broken quotes
      // This is a last resort for malformed JSON
      const aggressiveRepaired = repaired
        .replace(/"([\s\S]*?)"/g, (match, p1) => {
          // Escape newlines and tabs inside string values
          return `"${p1.replace(/\n/g, '\\n').replace(/\t/g, '\\t')}"`
        })

      try {
        return JSON.parse(aggressiveRepaired) as T
      } catch (error) {
        console.error('Final Parse Failure. Raw text:', cleaned)
        throw new Error(`Failed to parse AI response as JSON: ${error instanceof Error ? error.message : 'Unknown error'}`)
      }
    } catch (error) {
      console.error('JSON Extraction Failure:', error)
      throw new Error(`Failed to process AI response: ${error instanceof Error ? error.message : 'Unknown error'}`)
    }
  }
}

export const getAIClient = () => AIClient.getInstance()
export { AIClient }
