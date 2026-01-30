'use server'

import { createClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'

export async function toggleFollow(followingId: string) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) throw new Error('Unauthorized')
  if (user.id === followingId) throw new Error('Cannot follow yourself')

  const { data: existing } = await supabase
    .from('user_follows')
    .select('id')
    .eq('follower_id', user.id)
    .eq('following_id', followingId)
    .single()

  if (existing) {
    await supabase
      .from('user_follows')
      .delete()
      .eq('follower_id', user.id)
      .eq('following_id', followingId)
  } else {
    await supabase
      .from('user_follows')
      .insert({
        follower_id: user.id,
        following_id: followingId
      })
  }

  revalidatePath(`/u`)
}

export async function getFollowStats(userId: string) {
  const supabase = await createClient()
  
  const [followers, following] = await Promise.all([
    supabase.from('user_follows').select('follower_id', { count: 'exact', head: true }).eq('following_id', userId),
    supabase.from('user_follows').select('following_id', { count: 'exact', head: true }).eq('follower_id', userId)
  ])

  return {
    followersCount: followers.count || 0,
    followingCount: following.count || 0
  }
}

export async function checkIsFollowing(followingId: string) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return false

  const { data } = await supabase
    .from('user_follows')
    .select('id')
    .eq('follower_id', user.id)
    .eq('following_id', followingId)
    .single()

  return !!data
}

export async function getFollowers(userId: string) {
  const supabase = await createClient()
  
  const { data, error } = await supabase
    .from('user_follows')
    .select(`
      follower:user_profiles!follower_id (user_id, display_name, avatar_url, username)
    `)
    .eq('following_id', userId)
    .order('created_at', { ascending: false })

  if (error) {
    console.error('Error fetching followers:', error)
    return []
  }

  return data.map(item => item.follower)
}

export async function getFollowing(userId: string) {
  const supabase = await createClient()
  
  const { data, error } = await supabase
    .from('user_follows')
    .select(`
      following:user_profiles!following_id (user_id, display_name, avatar_url, username)
    `)
    .eq('follower_id', userId)
    .order('created_at', { ascending: false })

  if (error) {
    console.error('Error fetching following:', error)
    return []
  }

  return data.map(item => item.following)
}
