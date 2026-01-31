import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'

export async function PATCH(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await request.json()
    const { display_name, username, subjects } = body

    // Validate username format (lowercase, numbers, underscores only)
    if (username && !username.match(/^[a-z0-9_]+$/)) {
      return NextResponse.json(
        { error: 'Username can only contain lowercase letters, numbers, and underscores' },
        { status: 400 }
      )
    }

    // Check if username is already taken (if changing username)
    if (username) {
      const { data: existingUser } = await supabase
        .from('user_profiles')
        .select('id')
        .eq('username', username)
        .neq('user_id', user.id)
        .single()

      if (existingUser) {
        return NextResponse.json(
          { error: 'Username is already taken' },
          { status: 409 }
        )
      }
    }

    // Build update object with only provided fields
    const updateData: Record<string, string | string[] | null> = {
      updated_at: new Date().toISOString()
    }

    if (display_name !== undefined) updateData.display_name = display_name
    if (username !== undefined) updateData.username = username
    if (subjects !== undefined) updateData.subjects = subjects

    const { data: updatedProfile, error: updateError } = await supabase
      .from('user_profiles')
      .update(updateData)
      .eq('user_id', user.id)
      .select()
      .single()

    if (updateError) {
      console.error('Profile update error:', updateError)
      return NextResponse.json(
        { error: 'Failed to update profile' },
        { status: 500 }
      )
    }

    return NextResponse.json({
      success: true,
      data: updatedProfile
    })

  } catch (error) {
    console.error('Profile update error:', error)
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Internal Server Error' },
      { status: 500 }
    )
  }
}
