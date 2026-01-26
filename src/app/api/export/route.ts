import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { extractQuestion } from '@/lib/types'

interface ExportQuestionData {
  id: string
  question_text: string
  subject: string | null
  chapter: string | null
  difficulty: string | null
  type: string | null
  topics: string[]
}

interface ExportJoinResult {
  added_at: string
  question: ExportQuestionData | ExportQuestionData[] | null
}

export async function GET(_request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    // Fetch all questions for the user
    const { data: questions, error } = await supabase
      .from('user_questions')
      .select(`
        added_at,
        question:questions (
          id,
          question_text,
          subject,
          chapter,
          difficulty,
          type,
          topics,
          created_at
        )
      `)
      .eq('user_id', user.id)
      .order('added_at', { ascending: false })

    if (error) {
      console.error('Export fetch error:', error)
      return NextResponse.json({ error: 'Failed to fetch data' }, { status: 500 })
    }

    // Convert to CSV
    const headers = ['ID', 'Subject', 'Chapter', 'Type', 'Difficulty', 'Question Text', 'Topics', 'Added Date']
    const rows = (questions as ExportJoinResult[])?.map((item) => {
      const q = extractQuestion(item.question)
      if (!q) return null
      return [
        q.id,
        q.subject || '',
        q.chapter || '',
        q.type || '',
        q.difficulty || '',
        // Escape quotes in text
        `"${(q.question_text || '').replace(/"/g, '""')}"`,
        `"${(q.topics || []).join(', ')}"`,
        new Date(item.added_at).toISOString()
      ].join(',')
    }).filter(Boolean)

    const csvContent = [headers.join(','), ...(rows || [])].join('\n')

    // Return as downloadable file
    return new NextResponse(csvContent, {
      headers: {
        'Content-Type': 'text/csv',
        'Content-Disposition': `attachment; filename="quesify_export_${new Date().toISOString().split('T')[0]}.csv"`,
      },
    })

  } catch (error) {
    console.error('Export error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
