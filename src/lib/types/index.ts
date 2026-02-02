import type { Difficulty, QuestionType } from './database'
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
  isMCQ: boolean
  has_diagram: boolean
  has_solution: boolean
  solution: string
  type: 'MCQ' | 'VSA' | 'SA' | 'LA' | 'CASE_STUDY'
  numerical_answer: string | null
  subject: string
  chapter: string
  topics: string[]
  difficulty: 'easy' | 'medium' | 'hard' | 'very_hard'
  importance: number
  hint: string
  correct_option?: number | null
  avg_solve_time?: number
}

// Duplicate check result
export interface DuplicateCheckResult {
  is_duplicate: boolean
  match_type: 'SAME' | 'DIFFERENT_APPROACH' | 'DIFFERENT_QUESTION'
  matched_question_id: string | null
  confidence: number
  differences: string | null
  author?: {
    display_name: string | null
    avatar_url: string | null
  }
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

// Feed Recommendation Types
export interface FeedItem {
  id: string
  type: 'question' | 'user_suggestion'
  data: RecommendedQuestion | RecommendedUser
  score: number
  createdAt: string
}

export interface RecommendedQuestion {
  id: string
  question_text: string
  subject: string | null
  chapter: string | null
  topics: string[]
  difficulty: Difficulty
  popularity: number
  image_url: string | null
  type: QuestionType
  has_diagram: boolean
  solutions_count: number
  is_in_bank: boolean
  due_for_review: boolean
  uploader: {
    user_id: string
    display_name: string | null
    username: string | null
    avatar_url: string | null
  }
}

export interface RecommendedUser {
  user_id: string
  display_name: string | null
  username: string | null
  avatar_url: string | null
  common_subjects: string[]
  mutual_follows_count: number
  total_questions: number
  total_solutions: number
  is_following: boolean
}

export interface FeedResponse {
  items: FeedItem[]
  nextCursor: string | null
  hasMore: boolean
  offset: number
}


// Search Result Types
export interface SearchedUser extends RecommendedUser {
  similarity_score: number
}

export interface SearchedQuestion extends RecommendedQuestion {
  similarity_score: number
}

export interface SearchResponse {
  users: SearchedUser[]
  questions: SearchedQuestion[]
}
