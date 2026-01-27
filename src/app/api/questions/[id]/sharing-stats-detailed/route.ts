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

    // Verify the user owns this question
    const { data: question } = await supabase
      .from('questions')
      .select('owner_id')
      .eq('id', id)
      .single()

    if (!question || question.owner_id !== user.id) {
      return NextResponse.json({ count: 0 })
    }

    // Call the RPC to get count of other users (using the same parameter as in delete route)
    const { data, error } = await supabase.rpc('get_other_users_count', { 
      q_id: id 
    })

    if (error) {
      console.error('RPC Error:', error)
      // Fallback to direct database query if RPC fails
      const { count: directCount, error: directError } = await supabase
        .from('user_questions')
        .select('*', { count: 'exact', head: true })
        .eq('question_id', id)
        .neq('user_id', user.id)
        
      if (directError) {
        console.error('Direct query error:', directError)
        return NextResponse.json({ count: 0 })
      }
      
      return NextResponse.json({ count: directCount || 0 })
    }

    return NextResponse.json({ count: data || 0 })
  } catch (error) {
    console.error('Error fetching sharing stats:', error)
    return NextResponse.json({ count: 0 })
  }
}