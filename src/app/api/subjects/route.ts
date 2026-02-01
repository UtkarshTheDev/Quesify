import { NextResponse } from 'next/server'
import { getSubjectsList } from '@/lib/services/syllabus'

export const dynamic = 'force-dynamic'

export async function GET() {
  try {
    const subjects = await getSubjectsList()

    return NextResponse.json({
      subjects,
      fromCache: true,
    })
  } catch (error) {
    console.error('Error fetching subjects:', error)
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Failed to fetch subjects' },
      { status: 500 }
    )
  }
}
