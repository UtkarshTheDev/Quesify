import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { ai } from '@/lib/ai/services'
import { applyRateLimit } from '@/lib/ratelimit/client'

export async function POST(request: NextRequest) {
    const rateLimitResult = await applyRateLimit(request, 'aiTweak')
    if (!rateLimitResult.success && rateLimitResult.response) {
        return rateLimitResult.response
    }

  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const { oldSolution, newSolution } = await request.json()

    if (!oldSolution || !newSolution) {
      return NextResponse.json({ error: 'Missing content for analysis' }, { status: 400 })
    }

    const analysis = await ai.analyzeSolutionChange(oldSolution, newSolution)

    return NextResponse.json(analysis)
  } catch (error) {
    console.error('Change Analysis Error:', error)
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Internal Server Error' },
      { status: 500 }
    )
  }
}
