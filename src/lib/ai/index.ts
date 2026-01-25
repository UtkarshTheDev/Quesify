// AI Module - Clean exports for the entire app
// Usage: import { ai } from '@/lib/ai'

export { ai } from './services'
export { AI_CONFIG } from './config'
export { PROMPTS, formatPrompt } from './prompts'
export { getAIClient } from './client'

// Re-export types
export type { AIService } from './services'
export type { ModelType } from './config'
