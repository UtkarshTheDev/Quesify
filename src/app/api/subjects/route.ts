import { NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { getSubjectsList } from '@/lib/services/syllabus'
import { recordCacheHit, recordCacheMiss, resetCacheHitTracker } from '@/lib/cache/api-cache'

export const dynamic = 'force-dynamic'

export async function GET() {
  resetCacheHitTracker()

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
