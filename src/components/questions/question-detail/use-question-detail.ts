'use client'

import { useState, useEffect, useRef } from 'react'
import { useRouter, useSearchParams } from 'next/navigation'
import { toast } from 'sonner'
import type { Question } from '@/lib/types'

interface UseQuestionDetailParams {
  question: Question & {
    solutions: unknown[]
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

      if (!response.ok) {
        throw new Error('Failed to delete question')
      }

      toast.success('Question deleted successfully')
      router.push('/dashboard/questions')
      router.refresh()
    } catch {
      toast.error('Failed to delete question')
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
    stats: question.user_question_stats?.[0] || null,
  }
}
