import { createClient } from '@/lib/supabase/server'
import { ai } from '@/lib/ai'
import type { Chart } from '@/lib/types'

export async function generateUserCharts(userId: string): Promise<Chart[]> {
  const supabase = await createClient()

  // 1. Fetch user's question stats to identify weak areas
  const { data: stats } = await supabase
    .from('user_question_stats')
    .select(`
      solved,
      failed,
      attempts,
      question:questions!inner(
        id,
        chapter,
        subject,
        topics
      )
    `)
    .eq('user_id', userId)

  // Calculate stats per chapter
  const chapterStats: Record<string, { total: number; failed: number }> = {}
  const recentSubjects = new Set<string>()

  // Also build a map of available questions for the AI to choose from
  // Chapter -> [Question IDs]
  const questionMap: Record<string, string[]> = {}
  let totalQuestions = 0

  stats?.forEach((stat: any) => {
    const question = stat.question
    if (!question) return

    // Track recent subjects
    if (question.subject) recentSubjects.add(question.subject)

    // Group questions by chapter
    const chapter = question.chapter || 'Uncategorized'
    if (!questionMap[chapter]) {
      questionMap[chapter] = []
    }
    questionMap[chapter].push(question.id)
    totalQuestions++

    // Calc failure rates
    if (!chapterStats[chapter]) {
      chapterStats[chapter] = { total: 0, failed: 0 }
    }
    chapterStats[chapter].total++
    if (stat.failed || (stat.attempts > 1 && !stat.solved)) {
      chapterStats[chapter].failed++
    }
  })

  // Determine weak chapters (> 30% fail rate)
  const weakChapters = Object.entries(chapterStats)
    .filter(([_, data]) => (data.failed / data.total) > 0.3)
    .map(([chapter]) => chapter)

  // Calculate struggle rates for AI context
  const struggleRates: Record<string, number> = {}
  Object.entries(chapterStats).forEach(([chapter, data]) => {
    struggleRates[chapter] = Math.round((data.failed / data.total) * 100) / 100
  })

  // If minimal data, return empty or default
  if (totalQuestions < 3) {
    return []
  }

  // 2. Generate charts using AI
  // We wrap this in a try/catch because AI services might flake,
  // and we don't want to crash the whole dashboard.
  try {
    const charts = await ai.generateCharts({
      weakChapters,
      recentSubjects: Array.from(recentSubjects),
      struggleRates,
      totalQuestions,
      questionCategories: questionMap
    })
    return charts
  } catch (error) {
    console.error('Error generating AI charts:', error)
    return []
  }
}
