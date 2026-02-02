import { createClient } from '@/lib/supabase/server'
import { NextResponse } from 'next/server'

export async function POST(request: Request) {
  const supabase = await createClient()
  await supabase.auth.signOut()

  const { origin } = new URL(request.url)
  // Use 303 See Other to ensure the redirect is a GET request
  return NextResponse.redirect(`${origin}/login`, 303)
}
