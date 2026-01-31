'use server'

import { createClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'
import { ActivityItem } from '@/components/profile/activity-feed'
import { UserActivity } from '@/lib/types'

const ITEMS_PER_PAGE = 20

export async function getMoreActivities(userId: string, page: number) {
  const supabase = await createClient()
  const from = page * ITEMS_PER_PAGE
  const to = from + ITEMS_PER_PAGE - 1

  const { data: activities, error } = await supabase
    .from('user_activities')
    .select('*')
    .eq('user_id', userId)
    .order('created_at', { ascending: false })
    .range(from, to)

  if (error) {
    console.error('Error fetching activities:', error)
    return { items: [], hasMore: false }
  }

  const items: ActivityItem[] = activities.map((act: UserActivity) => {
    const getLocation = () => act.metadata.chapter || act.metadata.subject || 'General'
    let title = ''
    switch (act.activity_type) {
      case 'question_created':
        title = `Created question in ${getLocation()}`
        break
      case 'solution_contributed':
        title = `Contributed solution to ${getLocation()}`
        break
      case 'solution_updated':
        title = `Updated solution for ${getLocation()}`
        break
      case 'question_forked':
        title = `Added ${getLocation()} question to bank`
        break
      case 'question_deleted':
        title = `Deleted question in ${getLocation()}`
        break
      case 'solution_deleted':
        title = `Deleted solution`
        break
      case 'hint_updated':
        title = `Updated hint for ${getLocation()} question`
        break
      default:
        title = 'User activity'
    }

    return {
      id: act.id,
      type: act.activity_type as any,
      date: act.created_at,
      title: title,
      url: act.target_type === 'question' ? `/question/${act.target_id}` : act.target_type === 'solution' ? `/question/${act.metadata?.question_id || act.target_id}` : '#',
      meta: act.metadata.snippet || '',
      metadata: act.metadata
    }
  })

  const hasMore = activities.length === ITEMS_PER_PAGE
  return { items, hasMore }
}

export async function getMoreQuestions(userId: string, page: number) {
  const supabase = await createClient()
  const from = page * ITEMS_PER_PAGE
  const to = from + ITEMS_PER_PAGE - 1
  const limit = to + 50

  const [
    { data: createdQuestions },
    { data: forkedQuestions }
  ] = await Promise.all([
    supabase
      .from('questions')
      .select('*, user_question_stats(*)')
      .eq('owner_id', userId)
      .is('deleted_at', null)
      .order('created_at', { ascending: false })
      .limit(limit),

    supabase
      .from('user_questions')
      .select('*, question:questions!inner(*, user_question_stats(*))')
      .eq('user_id', userId)
      .eq('is_owner', false)
      .is('question.deleted_at', null)
      .order('added_at', { ascending: false })
      .limit(limit)
  ])

  const allQuestions = [
    ...(createdQuestions || []).map(q => ({ ...q, _source: 'Created', sortDate: q.created_at })),
    ...(forkedQuestions || []).map(f => f.question ? ({ ...f.question, _source: 'Forked', sortDate: f.added_at }) : null).filter(Boolean)
  ].filter(q => !q.deleted_at)

  allQuestions.sort((a, b) => new Date(b.sortDate).getTime() - new Date(a.sortDate).getTime())

  const paginatedQuestions = allQuestions.slice(from, to + 1)
  const hasMore = allQuestions.length > to + 1

  return { questions: paginatedQuestions, hasMore }
}

export async function getMoreSolutions(userId: string, page: number) {
  const supabase = await createClient()
  const from = page * ITEMS_PER_PAGE
  const to = from + ITEMS_PER_PAGE - 1

  const { data: contributedSolutions } = await supabase
      .from('solutions')
      .select(`
        *,
        question:questions (id, question_text, subject, chapter, owner_id),
        author:user_profiles!contributor_id (display_name, avatar_url, username)
      `)
      .eq('contributor_id', userId)
      .neq('question.owner_id', userId)
      .order('created_at', { ascending: false })
      .range(from, to) 

  const hasMore = (contributedSolutions?.length || 0) === ITEMS_PER_PAGE

  return { solutions: contributedSolutions || [], hasMore }
}

export async function updateProfile(userId: string, data: {
  display_name: string
  username: string
  subjects: string[]
}) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user || user.id !== userId) throw new Error('Unauthorized')

  const { data: profile } = await supabase
    .from('user_profiles')
    .select('username')
    .eq('user_id', userId)
    .single()

  if (profile?.username !== data.username) {
    const { data: existing } = await supabase
      .from('user_profiles')
      .select('id')
      .eq('username', data.username)
      .single()

    if (existing) throw new Error('Username already taken')
  }

  const { error } = await supabase
    .from('user_profiles')
    .update({
      display_name: data.display_name,
      username: data.username,
      subjects: data.subjects,
      updated_at: new Date().toISOString()
    })
    .eq('user_id', userId)

  if (error) throw error

  revalidatePath(`/u/${data.username}`)
  return { success: true }
}

export async function getAvailableSubjects() {
  const supabase = await createClient()
  const { data, error } = await supabase
    .from('syllabus')
    .select('subject')

  if (error) {
    console.error('Error fetching subjects:', error)
    return ['Mathematics', 'Physics', 'Chemistry']
  }

  const subjects = Array.from(new Set(data.map(item => item.subject))).sort()
  return subjects
}
