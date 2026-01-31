import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const { target_id } = await request.json()

    if (!target_id) {
      return NextResponse.json({ error: 'Target ID required' }, { status: 400 })
    }

    if (target_id === user.id) {
      return NextResponse.json({ error: 'Cannot follow yourself' }, { status: 400 })
    }

    const { error } = await supabase
      .from('follows')
      .insert({
        follower_id: user.id,
        following_id: target_id
      })

    if (error) {
      if (error.code === '23505') { // Unique violation
        return NextResponse.json({ success: true, message: 'Already following' })
      }
      throw error
    }

    return NextResponse.json({ success: true })
  } catch (error) {
    console.error('Follow error:', error)
    return NextResponse.json(
      { error: 'Failed to follow user' },
      { status: 500 }
    )
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const { target_id } = await request.json()

    if (!target_id) {
      return NextResponse.json({ error: 'Target ID required' }, { status: 400 })
    }

    const { error } = await supabase
      .from('follows')
      .delete()
      .match({
        follower_id: user.id,
        following_id: target_id
      })

    if (error) throw error

    return NextResponse.json({ success: true })
  } catch (error) {
    console.error('Unfollow error:', error)
    return NextResponse.json(
      { error: 'Failed to unfollow user' },
      { status: 500 }
    )
  }
}

export async function GET(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { searchParams } = new URL(request.url)
    const target_id = searchParams.get('target_id')
    const { data: { user } } = await supabase.auth.getUser()

    if (!target_id) {
      return NextResponse.json({ error: 'Target ID required' }, { status: 400 })
    }

    // Get counts
    const [followersCount, followingCount] = await Promise.all([
      supabase.from('follows')
        .select('*', { count: 'exact', head: true })
        .eq('following_id', target_id),
      supabase.from('follows')
        .select('*', { count: 'exact', head: true })
        .eq('follower_id', target_id)
    ])

    // Check if current user is following target
    let isFollowing = false
    if (user) {
      const { data } = await supabase
        .from('follows')
        .select('created_at')
        .match({
          follower_id: user.id,
          following_id: target_id
        })
        .single()
      
      isFollowing = !!data
    }

    return NextResponse.json({
      followers: followersCount.count || 0,
      following: followingCount.count || 0,
      isFollowing
    })
  } catch (error) {
    console.error('Fetch stats error:', error)
    return NextResponse.json(
      { error: 'Failed to fetch stats' },
      { status: 500 }
    )
  }
}
