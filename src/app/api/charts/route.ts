import { NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { ai } from '@/lib/ai'

export async function POST() {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

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
      .eq('user_id', user.id)

    // Calculate stats per chapter
    const chapterStats: Record<string, { total: number; failed: number }> = {}
    const recentSubjects = new Set<string>()

    // Also build a map of available questions for the AI to choose from
    // Chapter -> [Question IDs]
    const questionMap: Record<string, string[]> = {}
    let totalQuestions = 0

    type StatWithQuestion = {
      solved: boolean
      failed: boolean
      attempts: number
      question: {
        id: string
        chapter: string | null
        subject: string | null
        topics: string[]
      }
    }

    stats?.forEach((statData) => {
      const stat = statData as unknown as StatWithQuestion
      const question = stat.question
      if (!question) return

      // Track recent subjects (simple approach: just all subjects user has interacted with)
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
      .filter(([, data]) => (data.failed / data.total) > 0.3)
      .map(([chapter]) => chapter)

    // Calculate struggle rates for AI context
    const struggleRates: Record<string, number> = {}
    Object.entries(chapterStats).forEach(([chapter, data]) => {
      struggleRates[chapter] = Math.round((data.failed / data.total) * 100) / 100
    })

    // If no questions, return empty
    if (totalQuestions < 5) {
      return NextResponse.json({
        charts: []
      })
    }

    // 2. Generate charts using AI
    const charts = await ai.generateCharts({
      weakChapters,
      recentSubjects: Array.from(recentSubjects),
      struggleRates,
      totalQuestions,
      questionCategories: questionMap
    })

    return NextResponse.json({
      success: true,
      charts
    })

  } catch (error) {
    console.error('Chart generation error:', error)
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Failed to generate charts' },
      { status: 500 }
    )
  }
}
