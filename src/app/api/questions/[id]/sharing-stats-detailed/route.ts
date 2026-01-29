import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'

export async function GET(
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

    const { data: question, error: qError } = await supabase
      .from('questions')
      .select('id, owner_id')
      .eq('id', id)
      .single()

    if (qError || !question) {
      return NextResponse.json({ error: 'Question not found' }, { status: 404 })
    }

    // This RPC is SECURITY DEFINER to count linkers bypassing RLS constraints
    const { data: otherUsersCount, error: rpcError } = await supabase.rpc('get_other_users_count', { 
      q_id: id 
    })

    if (rpcError) {
      console.error('Sharing stats RPC Error:', rpcError)
      return NextResponse.json({ count: 0, error: 'Failed to fetch sharing stats' })
    }

    return NextResponse.json({ 
      count: otherUsersCount || 0,
      isOwner: question.owner_id === user.id
    })
  } catch (error) {
    console.error('Error fetching sharing stats:', error)
    return NextResponse.json({ count: 0 })
  }
}