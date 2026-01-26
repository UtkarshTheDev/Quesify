export * from './database'

// API response types
export interface ApiResponse<T> {
  data: T | null
  error: string | null
}

// Gemini extraction result
export interface GeminiExtractionResult {
  question_text: string
  options: string[]
  type: 'MCQ' | 'VSA' | 'SA' | 'LA' | 'CASE_STUDY'
  has_diagram: boolean
  has_solution: boolean
  solution: string
  numerical_answer: string | null
  subject: string
  chapter: string
  topics: string[]
  difficulty: 'easy' | 'medium' | 'hard' | 'very_hard'
  importance: number
  hint: string
  correct_option?: number | null
}

// Duplicate check result
export interface DuplicateCheckResult {
  is_duplicate: boolean
  match_type: 'SAME' | 'DIFFERENT_APPROACH' | 'DIFFERENT_QUESTION'
  matched_question_id: string | null
  confidence: number
  differences: string | null
}

// Chart/Feed types
export interface Chart {
  id: string
  name: string
  description: string
  question_ids: string[]
  count: number
  type: 'daily_feed' | 'topic_review' | 'quick_mcq' | 'weak_areas' | 'custom'
}
