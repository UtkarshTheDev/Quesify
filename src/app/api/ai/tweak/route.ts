import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { ai } from '@/lib/ai/services'

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await request.json()
    const { originalContent, contentType, instruction } = body

    if (!originalContent || !instruction) {
      return NextResponse.json({ error: 'Missing required fields' }, { status: 400 })
    }

    const tweakedContent = await ai.tweakContent(
      originalContent,
      contentType || 'solution',
      instruction
    )

    return NextResponse.json({ tweakedContent })
  } catch (error) {
    console.error('AI Tweak Error:', error)
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Internal Server Error' },
      { status: 500 }
    )
  }
}
