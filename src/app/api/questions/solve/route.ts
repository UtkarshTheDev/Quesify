import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { UserProfile, UserQuestionStats } from '@/lib/types'

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await request.json()
    const { questionId, solved, timeSpent = 0 } = body

    if (!questionId) {
      return NextResponse.json({ error: 'Question ID is required' }, { status: 400 })
    }

    // 1. Upsert user_question_stats
    const { data: currentStats } = await supabase
      .from('user_question_stats')
      .select('*')
      .eq('user_id', user.id)
      .eq('question_id', questionId)
      .single()

    const newAttempts = (currentStats?.attempts || 0) + 1

    // Determine status updates
    const updates: Partial<UserQuestionStats> = {
      user_id: user.id,
      question_id: questionId,
      attempts: newAttempts,
      last_practiced_at: new Date().toISOString(),
      time_spent: (currentStats?.time_spent || 0) + timeSpent,
      updated_at: new Date().toISOString()
    }

    if (solved) {
      updates.solved = true
      updates.failed = false // If solved now, it's not in failed state anymore
    } else {
      // If marked as failed/not solved, we might want to track that
      // But typically "failed" is explicit. For now, if not solved, we assume it's a failed attempt if explicitly sent as false
      updates.failed = true
    }

    const { error: upsertError } = await supabase
      .from('user_question_stats')
      .upsert(updates)

    if (upsertError) {
      console.error('Error updating question stats:', upsertError)
      return NextResponse.json({ error: 'Failed to update stats' }, { status: 500 })
    }

    // 2. Update User Profile (Streaks & Counts)
    if (solved) {
      // Fetch current profile data
      const { data: profile } = await supabase
        .from('user_profiles')
        .select('streak_count, last_streak_date, total_solved')
        .eq('user_id', user.id)
        .single()

      if (profile) {
        const today = new Date().toISOString().split('T')[0] // YYYY-MM-DD
        const lastStreakDate = profile.last_streak_date

        let newStreak = profile.streak_count || 0
        let shouldUpdateStreak = false

        if (lastStreakDate === today) {
          // Already practiced today, keep streak
          shouldUpdateStreak = false
        } else if (lastStreakDate) {
          // Check if yesterday
          const yesterday = new Date()
          yesterday.setDate(yesterday.getDate() - 1)
          const yesterdayStr = yesterday.toISOString().split('T')[0]

          if (lastStreakDate === yesterdayStr) {
            newStreak += 1
            shouldUpdateStreak = true
          } else {
            // Streak broken
            newStreak = 1
            shouldUpdateStreak = true
          }
        } else {
          // First time
          newStreak = 1
          shouldUpdateStreak = true
        }

        const profileUpdates: Partial<UserProfile> = {
          total_solved: (profile.total_solved || 0) + 1,
          updated_at: new Date().toISOString()
        }

        if (shouldUpdateStreak) {
          profileUpdates.streak_count = newStreak
          profileUpdates.last_streak_date = today
        }

        await supabase
          .from('user_profiles')
          .update(profileUpdates)
          .eq('user_id', user.id)
      }
    }

    return NextResponse.json({ success: true })

  } catch (error) {
    console.error('Error in solve route:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
