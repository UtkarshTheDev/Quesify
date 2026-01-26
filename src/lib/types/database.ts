export type QuestionType = 'MCQ' | 'VSA' | 'SA' | 'LA' | 'CASE_STUDY'
export type Difficulty = 'easy' | 'medium' | 'hard' | 'very_hard'

export interface Question {
  id: string
  owner_id: string
  extracted_text: string | null
  question_text: string
  options: string[]
  type: QuestionType
  has_diagram: boolean
  image_url: string | null
  subject: string | null
  chapter: string | null
  topics: string[]
  difficulty: Difficulty
  importance: number
  hint: string | null
  embedding: number[] | null
  popularity: number
  created_at: string
  updated_at: string
}

export interface Solution {
  id: string
  question_id: string
  contributor_id: string
  solution_text: string
  numerical_answer: string | null
  approach_description: string | null
  likes: number
  is_ai_best: boolean
  correct_option: number | null
  created_at: string
  updated_at: string
}

export interface UserQuestion {
  id: string
  user_id: string
  question_id: string
  is_owner: boolean
  is_contributor: boolean
  added_at: string
}

export interface UserQuestionStats {
  id: string
  user_id: string
  question_id: string
  solved: boolean
  failed: boolean
  struggled: boolean
  attempts: number
  time_spent: number
  user_difficulty: number | null
  last_practiced_at: string | null
  next_review_at: string | null
  in_revise_later: boolean
  created_at: string
  updated_at: string
}

export interface UserProfile {
  id: string
  user_id: string
  display_name: string | null
  avatar_url: string | null
  streak_count: number
  last_streak_date: string | null
  total_solved: number
  total_uploaded: number
  solutions_helped_count: number
  created_at: string
  updated_at: string
}

export interface Syllabus {
  id: string
  class: string | null
  subject: string
  chapter: string
  topics: string[]
  priority: number
  is_verified: boolean
  created_at: string
}

export interface SolutionLike {
  id: string
  user_id: string
  solution_id: string
  created_at: string
}

export interface ReviseLater {
  id: string
  user_id: string
  question_id: string
  added_at: string
}

// Extended types with relations
export interface QuestionWithSolutions extends Question {
  solutions: Solution[]
}

export interface QuestionWithStats extends Question {
  stats: UserQuestionStats | null
  solutions: Solution[]
}

// Supabase join result types
// When joining tables, Supabase may return arrays or single objects depending on the relationship
// These types properly handle both cases

export interface UserQuestionJoinResult {
  added_at: string
  question: Question | Question[] | null
}

export interface UserQuestionWithStatsJoinResult {
  added_at: string
  question: QuestionWithSolutionCount | QuestionWithSolutionCount[] | null
}

export interface QuestionWithSolutionCount extends Question {
  solutions: { count: number }[]
  user_question_stats: UserQuestionStats[]
}

export interface UserQuestionSubjectJoinResult {
  question: { subject: string | null } | { subject: string | null }[] | null
}

// Helper function to extract a single question from join result
export function extractQuestion<T>(joined: T | T[] | null): T | null {
  if (joined === null) return null
  if (Array.isArray(joined)) return joined[0] ?? null
  return joined
}
