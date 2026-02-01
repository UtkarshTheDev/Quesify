import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'

export async function POST(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const { id: solutionId } = await params

    const { data, error } = await supabase.rpc('toggle_solution_like', {
      sol_id: solutionId
    })

    if (error) throw error

    return NextResponse.json({ success: true, ...data })
  } catch (err) {
    console.error('Like error:', err)
    return NextResponse.json(
      { error: err instanceof Error ? err.message : 'Internal Server Error' },
      { status: 500 }
    )
  }
}

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ liked: false })
    }

    const { id: solutionId } = await params

    const { data: like } = await supabase
      .from('solution_likes')
      .select('id')
      .eq('user_id', user.id)
      .eq('solution_id', solutionId)
      .maybeSingle()

    return NextResponse.json({ liked: !!like })
  } catch {
    return NextResponse.json({ liked: false })
  }
}
