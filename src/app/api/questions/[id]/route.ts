import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { deleteCache, CACHE_KEYS } from '@/lib/cache/api-cache'

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const { id } = await params

    // 1. Verify ownership and check existence
    const { data: question, error: fetchError } = await supabase
      .from('questions')
      .select('owner_id, id, image_url')
      .eq('id', id)
      .single()

    if (fetchError || !question) {
      return NextResponse.json({ error: 'Question not found' }, { status: 404 })
    }

    const isOwner = question.owner_id === user.id
    
    const { data: otherUsersCount, error: countError } = await supabase.rpc('get_other_users_count', { 
      q_id: id 
    })

    if (countError) {
      console.error('[Delete] Failed to check usage stats:', countError)
      return NextResponse.json({ error: 'Failed to verify question usage' }, { status: 500 })
    }

    const { error: luqErr } = await supabase
      .from('user_questions')
      .delete()
      .eq('user_id', user.id)
      .eq('question_id', id)

    if (luqErr) {
      console.error('[Delete] Link deletion failed:', luqErr)
      return NextResponse.json({ error: luqErr.message }, { status: 500 })
    }

    if (!otherUsersCount || otherUsersCount === 0) {
      console.log(`[Delete] No other users. Purging question ${id}`)

      if (question.image_url) {
        try {
          const { deleteQuestionImage } = await import('@/lib/storage/upload')
          await deleteQuestionImage(question.image_url)
        } catch (err) {
          console.error('[Delete] Storage cleanup failed:', err)
        }
      }

      const { error: qErr } = await supabase
        .from('questions')
        .delete({ count: 'exact' })
        .eq('id', id)

      if (qErr) {
        console.error('[Delete] Question purge error:', qErr)
        return NextResponse.json({ 
          success: true, 
          message: 'Removed from your library, but full purge failed.' 
        })
      }

      if (isOwner) {
        const { data: profile } = await supabase
          .from('user_profiles')
          .select('total_uploaded')
          .eq('user_id', user.id)
          .single()
          
        if (profile && (profile.total_uploaded || 0) > 0) {
          await supabase
            .from('user_profiles')
            .update({ total_uploaded: profile.total_uploaded - 1 })
            .eq('user_id', user.id)
        }
      }

      const cacheKey = CACHE_KEYS.ENTITY.QUESTION(id)
      await deleteCache(cacheKey)
      console.log(`[Cache] INVALIDATED ${cacheKey} after question deletion`)

      return NextResponse.json({
        success: true,
        message: 'Question permanently deleted'
      })
    }

    console.log(`[Delete] Question ${id} is shared. Link removed for user ${user.id}`)
    return NextResponse.json({
      success: true,
      softDelete: true,
      message: 'Removed from your library. It remains available for other students.'
    })
  } catch (error) {
    console.error('Delete operation failed:', error)
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Internal Server Error' },
      { status: 500 }
    )
  }
}

export async function PATCH(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const { id } = await params
    const body = await request.json()

    // Verify ownership
    const { data: question, error: fetchError } = await supabase
      .from('questions')
      .select('owner_id')
      .eq('id', id)
      .single()

    if (fetchError || !question) {
      return NextResponse.json({ error: 'Question not found' }, { status: 404 })
    }

    if (question.owner_id !== user.id) {
      return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
    }

    // Update fields
    const updateData: Record<string, string | string[] | number | null> = {
      updated_at: new Date().toISOString()
    }

    if (body.question_text !== undefined) updateData.question_text = body.question_text
    if (body.options !== undefined) updateData.options = body.options
    if (body.hint !== undefined) updateData.hint = body.hint
    if (body.topics !== undefined) updateData.topics = body.topics

    const { error: updateError } = await supabase
      .from('questions')
      .update(updateData)
      .eq('id', id)

    if (updateError) {
      return NextResponse.json({ error: updateError.message }, { status: 500 })
    }

    const cacheKey = CACHE_KEYS.ENTITY.QUESTION(id)
    await deleteCache(cacheKey)
    console.log(`[Cache] INVALIDATED ${cacheKey} after question update`)

    return NextResponse.json({ success: true })
  } catch (error) {
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Internal Server Error' },
      { status: 500 }
    )
  }
}
