import { createClient } from '@/lib/supabase/server'
import { NextRequest, NextResponse } from 'next/server'
import { applyRateLimit } from '@/lib/ratelimit/client'

export async function GET(request: NextRequest) {
    const rateLimitResult = await applyRateLimit(request, 'authCheck')
    if (!rateLimitResult.success && rateLimitResult.response) {
        return rateLimitResult.response
    }

  const searchParams = request.nextUrl.searchParams
  const username = searchParams.get('username')

  if (!username) {
    return NextResponse.json({ error: 'Username required' }, { status: 400 })
  }

  if (username.length < 3) {
    return NextResponse.json({ available: false, message: 'Too short' })
  }

  const supabase = await createClient()

  const { data } = await supabase
    .from('user_profiles')
    .select('username')
    .eq('username', username)
    .single()

  if (data) {
    return NextResponse.json({ available: false })
  }

  return NextResponse.json({ available: true })
}
