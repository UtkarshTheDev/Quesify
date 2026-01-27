'use client'

import { useState, useEffect, useRef, useCallback } from 'react'
import { useRouter, useSearchParams } from 'next/navigation'
import { toast } from 'sonner'
import type { Question, UserQuestionStats, Solution } from '@/lib/types'

interface UseQuestionDetailParams {
  question: Question & {
    solutions: Solution[]
    user_question_stats: unknown[]
    user_questions?: { id: string }[]
    author?: {
      display_name: string | null
      avatar_url: string | null
    }
  }
  userId: string | null
}

export function useQuestionDetail({ question, userId }: UseQuestionDetailParams) {
  const router = useRouter()
  const searchParams = useSearchParams()
  const hasAttemptedAutoAdd = useRef(false)

  const [isGenerating, setIsGenerating] = useState(false)
  const [isMarkingSolved, setIsMarkingSolved] = useState(false)
  const [isAddingToBank, setIsAddingToBank] = useState(false)
  const [isEditingHint, setIsEditingHint] = useState(false)
  const [isEditingTags, setIsEditingTags] = useState(false)
  const [isSaving, setIsSaving] = useState(false)
  const [editForm, setEditForm] = useState({ hint: question.hint || '' })
  const [tagInput, setTagInput] = useState(question.topics.join(', '))
  const [showDeleteDialog, setShowDeleteDialog] = useState(false)
  const [isDeleting, setIsDeleting] = useState(false)
  const [isRevealed, setIsRevealed] = useState(false)
  const [selectedSolutionId, setSelectedSolutionId] = useState<string | null>(null)
  const [moreSolutions, setMoreSolutions] = useState<Solution[]>([])
  const [isLoadingMore, setIsLoadingMore] = useState(false)
  const [isShared, setIsShared] = useState(false)
  const [sharingStats, setSharingStats] = useState<{ count: number } | null>(null)

  useEffect(() => {
    const checkSharing = async () => {
      if (!userId || question.owner_id !== userId) return
      
      const { count } = await fetch(`/api/questions/${question.id}/sharing-stats`).then(res => res.json()).catch(() => ({ count: 0 }))
      setIsShared(count > 0)
    }
    
    checkSharing()
  }, [question.id, question.owner_id, userId])

  const loadMoreSolutions = useCallback(async () => {
    setIsLoadingMore(true)
    try {
      const response = await fetch(`/api/solutions?questionId=${question.id}&offset=1&limit=20`)
      if (!response.ok) throw new Error('Failed to fetch')
      const data = await response.json()
      if (data.solutions) {
        setMoreSolutions(data.solutions)
      }
    } catch (error) {
      console.error('Failed to load more solutions:', error)
    } finally {
      setIsLoadingMore(false)
    }
  }, [question.id])

  const handleSave = async (section: 'hint' | 'tags') => {
    setIsSaving(true)
    try {
      const payload: Partial<Question> = {}
      if (section === 'hint') {
        payload.hint = editForm.hint
      } else if (section === 'tags') {
        const newTopics = tagInput.split(',').map(t => t.trim()).filter(Boolean)
        payload.topics = newTopics
      }

      const response = await fetch(`/api/questions/${question.id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      })

      if (!response.ok) {
        throw new Error('Failed to update question')
      }

      toast.success('Saved successfully')
      if (section === 'hint') setIsEditingHint(false)
      if (section === 'tags') setIsEditingTags(false)
      router.refresh()
    } catch {
      toast.error('Failed to save changes')
    } finally {
      setIsSaving(false)
    }
  }

  const handleDelete = async () => {
    setIsDeleting(true)
    try {
      const response = await fetch(`/api/questions/${question.id}`, {
        method: 'DELETE',
      })

      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.error || 'Failed to delete question')
      }

      if (data.softDelete) {
        toast.info(data.message)
      } else {
        toast.success('Question permanently deleted')
      }

      router.push('/dashboard/questions')
      router.refresh()
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to delete question')
      setIsDeleting(false)
    }
  }

  const handleAddToBank = async () => {
    if (!userId) {
      const currentPath = window.location.pathname
      const nextUrl = `${currentPath}?action=add-to-bank`
      router.push(`/login?next=${encodeURIComponent(nextUrl)}`)
      return
    }

    setIsAddingToBank(true)
    try {
      const response = await fetch('/api/questions', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ existing_question_id: question.id }),
      })

      if (!response.ok) throw new Error('Failed to add to bank')

      toast.success('Added to your bank!')
      router.push(`/dashboard/questions/${question.id}`)
      router.refresh()
    } catch {
      toast.error('Failed to add to bank')
    } finally {
      setIsAddingToBank(false)
    }
  }

  useEffect(() => {
    if (userId && searchParams.get('action') === 'add-to-bank' && !hasAttemptedAutoAdd.current) {
      hasAttemptedAutoAdd.current = true
      handleAddToBank()
    }
  }, [userId, searchParams, handleAddToBank])

  const handleGenerateSolution = async () => {
    setIsGenerating(true)
    try {
      const response = await fetch('/api/questions/generate-solution', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ questionId: question.id }),
      })

      if (!response.ok) throw new Error('Failed to generate solution')

      toast.success('Solution generated successfully!')
      router.refresh()
    } catch {
      toast.error('Something went wrong')
    } finally {
      setIsGenerating(false)
    }
  }

  const handleMarkSolved = async () => {
    setIsMarkingSolved(true)
    try {
      const response = await fetch('/api/questions/solve', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          questionId: question.id,
          solved: true,
          timeSpent: 0,
        }),
      })

      if (!response.ok) throw new Error('Failed to update status')

      toast.success('Question marked as solved!')
      router.refresh()
    } catch {
      toast.error('Failed to mark as solved')
    } finally {
      setIsMarkingSolved(false)
    }
  }

  const handleSolutionDelete = async (solutionId: string) => {
    if (!confirm('Are you sure you want to delete this solution?')) return

    try {
      const response = await fetch(`/api/solutions/${solutionId}`, {
        method: 'DELETE',
      })

      if (!response.ok) throw new Error('Failed to delete solution')

      toast.success('Solution deleted successfully')
      router.refresh()
    } catch {
      toast.error('Failed to delete solution')
    }
  }

  const fetchSharingStats = useCallback(async () => {
    if (!userId || question.owner_id !== userId) return { count: 0 }

    try {
      const response = await fetch(`/api/questions/${question.id}/sharing-stats-detailed`)
      if (!response.ok) return { count: 0 }
      
      const data = await response.json()
      setSharingStats(data)
      return data
    } catch (error) {
      console.error('Failed to fetch sharing stats:', error)
      return { count: 0 }
    }
  }, [question.id, question.owner_id, userId])

  return {
    router,
    isGenerating,
    isMarkingSolved,
    isAddingToBank,
    isEditingHint,
    setIsEditingHint,
    isEditingTags,
    setIsEditingTags,
    isSaving,
    editForm,
    setEditForm,
    tagInput,
    setTagInput,
    showDeleteDialog,
    setShowDeleteDialog,
    isDeleting,
    handleSave,
    handleDelete,
    handleAddToBank,
    handleGenerateSolution,
    handleMarkSolved,
    handleSolutionDelete,
    fetchSharingStats,
    sharingStats,
    isRevealed,
    setIsRevealed,
    selectedSolutionId,
    setSelectedSolutionId,
    moreSolutions,
    isLoadingMore,
    loadMoreSolutions,
    isShared,
    stats: (question.user_question_stats?.[0] || null) as UserQuestionStats | null,
  }
}
