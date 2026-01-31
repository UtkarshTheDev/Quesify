import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { getCache, setCache, deleteCache, recordCacheHit, recordCacheMiss, resetCacheHitTracker, CACHE_KEYS, CACHE_TTL } from '@/lib/cache/api-cache'

export const dynamic = 'force-dynamic'

export async function GET(request: NextRequest) {
  resetCacheHitTracker()

  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const cacheKey = CACHE_KEYS.USER.PROFILE(user.id)
    const cached = await getCache(cacheKey)

    if (cached.fromCache) {
      recordCacheHit()
      console.log(`[Cache] HIT ${cacheKey}`)
      return NextResponse.json({
        success: true,
        data: cached.data,
        fromCache: true,
      })
    }

    recordCacheMiss()
    console.log(`[Cache] MISS ${cacheKey}`)

    const { data: profile, error } = await supabase
      .from('user_profiles')
      .select('*')
      .eq('user_id', user.id)
      .single()

    if (error) {
      console.error('Profile fetch error:', error)
      return NextResponse.json(
        { error: 'Failed to fetch profile' },
        { status: 500 }
      )
    }

    await setCache(cacheKey, profile, CACHE_TTL.USER_DATA)

    return NextResponse.json({
      success: true,
      data: profile,
      fromCache: false,
    })
  } catch (error) {
    console.error('Profile fetch error:', error)
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Internal Server Error' },
      { status: 500 }
    )
  }
}

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

    const cacheKey = CACHE_KEYS.USER.PROFILE(user.id)
    await deleteCache(cacheKey)
    console.log(`[Cache] INVALIDATED ${cacheKey} after profile update`)

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
