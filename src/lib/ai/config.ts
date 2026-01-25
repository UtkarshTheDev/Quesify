// AI Configuration - Single source of truth for all AI settings
export const AI_CONFIG = {
  // Models
  models: {
    // Main model for text generation, image analysis, etc.
    default: 'gemini-2.0-flash',
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
} as const

export type ModelType = keyof typeof AI_CONFIG.models
