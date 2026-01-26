import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'

export async function PATCH(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const { id } = params
    const body = await request.json()

    // Verify ownership
    const { data: solution, error: fetchError } = await supabase
      .from('solutions')
      .select('contributor_id')
      .eq('id', id)
      .single()

    if (fetchError || !solution) {
      return NextResponse.json({ error: 'Solution not found' }, { status: 404 })
    }

    if (solution.contributor_id !== user.id) {
      return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
    }

    // Update
    const { error: updateError } = await supabase
      .from('solutions')
      .update({
        solution_text: body.solution_text,
        updated_at: new Date().toISOString()
      })
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

export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const { id } = params

    // Verify ownership
    const { data: solution, error: fetchError } = await supabase
      .from('solutions')
      .select('contributor_id')
      .eq('id', id)
      .single()

    if (fetchError || !solution) {
      return NextResponse.json({ error: 'Solution not found' }, { status: 404 })
    }

    if (solution.contributor_id !== user.id) {
      return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
    }

    // Delete
    const { error: deleteError } = await supabase
      .from('solutions')
      .delete()
      .eq('id', id)

    if (deleteError) {
      return NextResponse.json({ error: deleteError.message }, { status: 500 })
    }

    return NextResponse.json({ success: true })
  } catch (error) {
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Internal Server Error' },
      { status: 500 }
    )
  }
}
