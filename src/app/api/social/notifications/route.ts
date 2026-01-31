import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'

export async function GET(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const { searchParams } = new URL(request.url)
    const limit = parseInt(searchParams.get('limit') || '20')
    const offset = parseInt(searchParams.get('offset') || '0')

    const { data, error } = await supabase
      .from('notifications')
      .select(`
        *,
        sender:user_profiles!sender_id (
          display_name,
          avatar_url,
          username
        )
      `)
      .eq('recipient_id', user.id)
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1)

    if (error) throw error

    // Fetch entity details based on type if needed (can be optimized later)
    const enrichedNotifications = await Promise.all(data.map(async (notif) => {
      let entityDetails = null
      
      if (notif.entity_type === 'solution' && notif.entity_id) {
        const { data: sol } = await supabase
          .from('solutions')
          .select('question_id, question:questions(subject, chapter)')
          .eq('id', notif.entity_id)
          .single()
        entityDetails = sol
      } else if (notif.entity_type === 'question' && notif.entity_id) {
        const { data: question } = await supabase
          .from('questions')
          .select('id, subject, chapter')
          .eq('id', notif.entity_id)
          .single()
        
        if (question) {
          entityDetails = {
            question_id: question.id,
            question: {
              subject: question.subject,
              chapter: question.chapter
            }
          }
        }
      }

      return {
        ...notif,
        entityDetails
      }
    }))

    return NextResponse.json({ notifications: enrichedNotifications })
  } catch (error) {
    console.error('Fetch notifications error:', error)
    return NextResponse.json(
      { error: 'Failed to fetch notifications' },
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
    const { id, mark_all } = body

    if (mark_all) {
      const { error } = await supabase
        .from('notifications')
        .update({ is_read: true })
        .eq('recipient_id', user.id)
        .eq('is_read', false)

      if (error) throw error
    } else if (id) {
      const { error } = await supabase
        .from('notifications')
        .update({ is_read: true })
        .eq('id', id)
        .eq('recipient_id', user.id)

      if (error) throw error
    }

    return NextResponse.json({ success: true })
  } catch (error) {
    console.error('Update notification error:', error)
    return NextResponse.json(
      { error: 'Failed to update notification' },
      { status: 500 }
    )
  }
}
