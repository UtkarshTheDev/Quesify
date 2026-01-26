/**
 * Syllabus Service
 *
 * Provides efficient access to syllabus data for AI prompts and question extraction.
 * Uses database when available, falls back to static data for server-side operations.
 */

import { createClient } from '@/lib/supabase/server'
import { class12Syllabus, getChaptersBySubject, getSyllabusBySubject } from '@/lib/syllabus-data'

export interface SyllabusChapter {
  chapter: string
  topics: string[]
  priority: number
}

export interface SyllabusData {
  subject: string
  chapters: SyllabusChapter[]
}

export interface SyllabusChapterProgress extends SyllabusChapter {
  questionCount: number
}

export interface SyllabusProgressData {
  subject: string
  chapters: SyllabusChapterProgress[]
}

/**
 * Get syllabus data with user question counts
 */
export async function getUserSyllabusProgress(userId: string, subject?: string): Promise<Record<string, SyllabusProgressData>> {
  try {
    const supabase = await createClient()

    // 1. Get the base syllabus first (database or static)
    let syllabusMap: Record<string, SyllabusData> = {}

    if (subject) {
      const data = await getSyllabus(subject)
      syllabusMap[subject] = data
    } else {
      syllabusMap = await getAllSyllabus()
    }

    // 2. Get user's questions to count per chapter
    // We fetch minimal data needed for counting
    let query = supabase
      .from('user_questions')
      .select(`
        question:questions!inner(
          subject,
          chapter
        )
      `)
      .eq('user_id', userId)

    if (subject) {
      query = query.eq('question.subject', subject)
    }

    const { data: userQuestions, error } = await query

    if (error) {
      console.error('Error fetching user questions for progress:', error)
      // Return syllabus with 0 counts
      return Object.entries(syllabusMap).reduce((acc, [subj, data]) => {
        acc[subj] = {
          subject: subj,
          chapters: data.chapters.map(ch => ({ ...ch, questionCount: 0 }))
        }
        return acc
      }, {} as Record<string, SyllabusProgressData>)
    }

    // 3. Aggregate counts
    const counts: Record<string, Record<string, number>> = {} // Subject -> Chapter -> Count

    interface UserQuestionRow {
      question: {
        subject: string | null
        chapter: string | null
      } | {
        subject: string | null
        chapter: string | null
      }[] | null
    }

    (userQuestions as unknown as UserQuestionRow[])?.forEach((row) => {
      // Handle Supabase join response (could be array or object)
      const q = Array.isArray(row.question) ? row.question[0] : row.question
      if (!q) return

      const subj = q.subject || 'Uncategorized'
      const chap = q.chapter || 'Uncategorized'

      if (!counts[subj]) counts[subj] = {}
      if (!counts[subj][chap]) counts[subj][chap] = 0
      counts[subj][chap]++
    })

    // 4. Merge counts into syllabus
    const result: Record<string, SyllabusProgressData> = {}

    Object.entries(syllabusMap).forEach(([subj, data]) => {
      result[subj] = {
        subject: subj,
        chapters: data.chapters.map(ch => ({
          ...ch,
          questionCount: counts[subj]?.[ch.chapter] || 0
        }))
      }
    })

    return result
  } catch (error) {
    console.error('Error in getUserSyllabusProgress:', error)
    return {}
  }
}

/**
 * Fetch syllabus data from database for a specific subject
 */
export async function getSyllabusFromDB(subject: string): Promise<SyllabusData | null> {
  try {
    const supabase = await createClient()

    const { data, error } = await supabase
      .from('syllabus')
      .select('chapter, topics, priority')
      .eq('class', '12')
      .eq('subject', subject)
      .order('priority', { ascending: false })

    if (error) {
      console.error('Error fetching syllabus from DB:', error)
      return null
    }

    if (!data || data.length === 0) {
      return null
    }

    return {
      subject,
      chapters: data.map(entry => ({
        chapter: entry.chapter,
        topics: Array.isArray(entry.topics) ? entry.topics : [],
        priority: entry.priority ?? 3
      }))
    }
  } catch (error) {
    console.error('Error in getSyllabusFromDB:', error)
    return null
  }
}

/**
 * Fetch syllabus data for all subjects from database
 */
export async function getAllSyllabusFromDB(): Promise<Record<string, SyllabusData>> {
  try {
    const supabase = await createClient()

    const { data, error } = await supabase
      .from('syllabus')
      .select('subject, chapter, topics, priority')
      .eq('class', '12')
      .order('subject')
      .order('priority', { ascending: false })

    if (error) {
      console.error('Error fetching all syllabus from DB:', error)
      return {}
    }

    if (!data || data.length === 0) {
      return {}
    }

    // Group by subject
    const grouped = data.reduce((acc, entry) => {
      if (!acc[entry.subject]) {
        acc[entry.subject] = {
          subject: entry.subject,
          chapters: []
        }
      }

      acc[entry.subject].chapters.push({
        chapter: entry.chapter,
        topics: Array.isArray(entry.topics) ? entry.topics : [],
        priority: entry.priority ?? 3
      })

      return acc
    }, {} as Record<string, SyllabusData>)

    return grouped
  } catch (error) {
    console.error('Error in getAllSyllabusFromDB:', error)
    return {}
  }
}

// Simple in-memory cache
const syllabusCache: Record<string, SyllabusData> = {}
const allSyllabusCache: { data: Record<string, SyllabusData> | null, timestamp: number } = { data: null, timestamp: 0 }
const CACHE_TTL = 1000 * 60 * 60 // 1 hour

/**
 * Get syllabus data for a subject with fallback to static data
 */
export async function getSyllabus(subject: string): Promise<SyllabusData> {
  // Check cache
  if (syllabusCache[subject]) {
    return syllabusCache[subject]
  }

  // Try database first
  const dbData = await getSyllabusFromDB(subject)
  if (dbData) {
    syllabusCache[subject] = dbData
    return dbData
  }

  // Fallback to static data
  console.log(`Using static syllabus data for ${subject}`)
  const staticEntries = getSyllabusBySubject(subject)

  const result = {
    subject,
    chapters: staticEntries.map(entry => ({
      chapter: entry.chapter,
      topics: entry.topics,
      priority: entry.priority
    }))
  }

  syllabusCache[subject] = result
  return result
}

/**
 * Get syllabus data for all subjects with fallback to static data
 */
export async function getAllSyllabus(): Promise<Record<string, SyllabusData>> {
  // Check cache
  if (allSyllabusCache.data && (Date.now() - allSyllabusCache.timestamp < CACHE_TTL)) {
    return allSyllabusCache.data
  }

  // Try database first
  const dbData = await getAllSyllabusFromDB()
  if (Object.keys(dbData).length > 0) {
    allSyllabusCache.data = dbData
    allSyllabusCache.timestamp = Date.now()
    return dbData
  }

  // Fallback to static data
  console.log('Using static syllabus data for all subjects')
  const grouped = class12Syllabus.reduce((acc, entry) => {
    if (!acc[entry.subject]) {
      acc[entry.subject] = {
        subject: entry.subject,
        chapters: []
      }
    }

    acc[entry.subject].chapters.push({
      chapter: entry.chapter,
      topics: entry.topics,
      priority: entry.priority
    })

    return acc
  }, {} as Record<string, SyllabusData>)

  allSyllabusCache.data = grouped
  allSyllabusCache.timestamp = Date.now()
  return grouped
}

/**
 * Format syllabus data for AI prompt including TOPICS
 * Returns a detailed hierarchy: Subject -> Chapter -> Topics
 */
export function formatSyllabusWithTopics(syllabusData: SyllabusData): string {
  const sortedChapters = [...syllabusData.chapters].sort((a, b) => b.priority - a.priority)

  return sortedChapters
    .map(ch => {
      const topicsList = ch.topics.length > 0
        ? ch.topics.map(t => `    - ${t}`).join('\n')
        : '    - (General)'

      return `- Chapter: ${ch.chapter} (Priority: ${ch.priority}/5)\n  Topics:\n${topicsList}`
    })
    .join('\n\n')
}

/**
 * Format all syllabus data for AI prompt including TOPICS
 */
export function formatAllSyllabusWithTopics(allSyllabus: Record<string, SyllabusData>): string {
  return Object.entries(allSyllabus)
    .map(([subject, data]) => {
      const chapters = formatSyllabusWithTopics(data)
      return `=== SUBJECT: ${subject} ===\n\n${chapters}`
    })
    .join('\n\n')
}

/**
 * Format syllabus data for AI prompt
 * Returns a concise, readable list of chapters for AI to reference
 */
export function formatSyllabusForPrompt(syllabusData: SyllabusData): string {
  const sortedChapters = [...syllabusData.chapters].sort((a, b) => b.priority - a.priority)

  return sortedChapters
    .map(ch => `- ${ch.chapter} (Priority: ${ch.priority}/5)`)
    .join('\n')
}

/**
 * Format all syllabus data for AI prompt
 * Now optimized for JSON retrieval by providing clear subject-chapter hierarchy
 */
export function formatAllSyllabusForPrompt(allSyllabus: Record<string, SyllabusData>): string {
  return Object.entries(allSyllabus)
    .map(([subject, data]) => {
      const chapters = data.chapters
        .map(ch => `- ${ch.chapter}`)
        .join('\n')
      return `[SUBJECT: ${subject}]\n${chapters}`
    })
    .join('\n\n')
}

/**
 * Get just chapter names for a subject (lightweight query)
 */
export async function getChapterNames(subject: string): Promise<string[]> {
  try {
    const supabase = await createClient()

    const { data, error } = await supabase
      .from('syllabus')
      .select('chapter')
      .eq('class', '12')
      .eq('subject', subject)
      .order('priority', { ascending: false })

    if (error || !data) {
      // Fallback to static data
      return getChaptersBySubject(subject)
    }

    return data.map(entry => entry.chapter)
  } catch (error) {
    // Fallback to static data
    return getChaptersBySubject(subject)
  }
}

/**
 * Get chapter names for all subjects (lightweight)
 */
export async function getAllChapterNames(): Promise<Record<string, string[]>> {
  try {
    const supabase = await createClient()

    const { data, error } = await supabase
      .from('syllabus')
      .select('subject, chapter')
      .eq('class', '12')
      .order('subject')
      .order('priority', { ascending: false })

    if (error || !data) {
      // Fallback to static data
      return getFallbackChapterNames()
    }

    const grouped = data.reduce((acc, entry) => {
      if (!acc[entry.subject]) {
        acc[entry.subject] = []
      }
      acc[entry.subject].push(entry.chapter)
      return acc
    }, {} as Record<string, string[]>)

    return grouped
  } catch (error) {
    // Fallback to static data
    return getFallbackChapterNames()
  }
}

/**
 * Helper to get chapter names from static data
 */
function getFallbackChapterNames(): Record<string, string[]> {
  return class12Syllabus.reduce((acc, entry) => {
    if (!acc[entry.subject]) {
      acc[entry.subject] = []
    }
    acc[entry.subject].push(entry.chapter)
    return acc
  }, {} as Record<string, string[]>)
}
