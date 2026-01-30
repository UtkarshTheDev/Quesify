import { createClient } from '@/lib/supabase/server'
import { NextRequest, NextResponse } from 'next/server'

export async function POST(request: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  const body = await request.json()
  const { username, subjects } = body

  if (!username || !subjects || !Array.isArray(subjects)) {
    return NextResponse.json({ error: 'Invalid data' }, { status: 400 })
  }

  const { data: existing } = await supabase
    .from('user_profiles')
    .select('username')
    .eq('username', username)
    .single()

  if (existing) {
     return NextResponse.json({ error: 'Username taken' }, { status: 409 })
  }

  const { error } = await supabase
    .from('user_profiles')
    .update({ 
        username, 
        subjects,
        updated_at: new Date().toISOString()
    })
    .eq('user_id', user.id)

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }

  return NextResponse.json({ success: true })
}
