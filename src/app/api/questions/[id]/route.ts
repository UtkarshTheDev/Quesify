import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'

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
    console.log(`Starting deletion for question ${id}. User is owner: ${isOwner}`)

    // 2. Perform deletions based on ownership
    if (isOwner) {
      console.log(`[Delete] Authorized purge for question ${id} by owner ${user.id}`)

      // a. Storage Cleanup (Buckets don't cascade)
      if (question.image_url) {
        try {
          const { deleteQuestionImage } = await import('@/lib/storage/upload')
          await deleteQuestionImage(question.image_url)
        } catch (err) {
          console.error('[Delete] Storage cleanup failed:', err)
        }
      }

      // b. Atomic Delete (Cascade handled by DB)
      const { error: qErr, count } = await supabase
        .from('questions')
        .delete({ count: 'exact' })
        .eq('id', id)

      if (qErr) {
        console.error('[Delete] Question delete error:', qErr)
        return NextResponse.json({ error: `Deletion failed: ${qErr.message}` }, { status: 500 })
      }

      if (count === 0) {
        // This handles cases where RLS might still block despite code check
        console.warn('[Delete] DB reported 0 rows deleted despite owner check passing.')
        return NextResponse.json({ error: 'Database policy blocked the deletion. Please contact support.' }, { status: 500 })
      }

      // c. Stats Update
      const { data: profile } = await supabase.from('user_profiles').select('total_uploaded').eq('user_id', user.id).single()
      if (profile && (profile.total_uploaded || 0) > 0) {
        await supabase.from('user_profiles').update({ total_uploaded: profile.total_uploaded - 1 }).eq('user_id', user.id)
      }

      console.log(`[Delete] Successfully purged question ${id}`)
      return NextResponse.json({
        success: true,
        message: 'Question permanently deleted'
      })
    } else {
      // SOFT REMOVE: Just remove this user's link
      console.log(`[Delete] User ${user.id} removing link to shared question ${id}`)

      const { error: luqErr } = await supabase
        .from('user_questions')
        .delete()
        .eq('user_id', user.id)
        .eq('question_id', id)

      if (luqErr) return NextResponse.json({ error: luqErr.message }, { status: 500 })

      return NextResponse.json({
        success: true,
        message: 'Removed from your library'
      })
    }
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

    return NextResponse.json({ success: true })
  } catch (error) {
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Internal Server Error' },
      { status: 500 }
    )
  }
}
