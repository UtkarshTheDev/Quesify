import { createClient } from '@/lib/supabase/server'
import { NextResponse } from 'next/server'

export async function GET() {
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('syllabus')
    .select('subject')
    
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }

  const subjects = Array.from(new Set(data.map(item => item.subject))).sort()

  return NextResponse.json({ subjects })
}
