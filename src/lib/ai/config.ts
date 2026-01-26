// AI Configuration - Single source of truth for all AI settings
export const AI_CONFIG = {
  // Models
  models: {
    // Default/Fast model for high-speed tasks (extraction, validation)
    fast: 'gemini-2.5-flash-lite',
    // Reasoning model for complex logic (solutions)
    reasoning: 'gemini-3-flash-preview',
    // Vision model for image analysis
    vision: 'gemini-2.5-flash',
    // Embedding model for vector search
    embedding: 'text-embedding-004',
  },

  // Generation settings
  generation: {
    temperature: 0.7,
    maxOutputTokens: 4096,
  },

  // Retry settings
  retry: {
    maxAttempts: 3,
    delayMs: 1000,
  },

  // Debugging
  debug: process.env.NODE_ENV === 'development',
} as const

export type ModelType = keyof typeof AI_CONFIG.models
