'use client'

import type { Question, Solution, UserQuestionStats } from '@/lib/types'
import { GuestCTA } from './guest-cta'
import { QuestionAuthor } from './question-author'
import { QuestionContent } from './question-content'
import { QuestionDeleteDialog } from './question-delete-dialog'
import { QuestionHeader } from './question-header'
import { QuestionSidebar } from './question-sidebar'
import { QuestionTabs } from './question-tabs'
import { useQuestionDetail } from './use-question-detail'

interface QuestionDetailProps {
  question: Question & {
    solutions: Solution[]
    user_question_stats: UserQuestionStats[]
    user_questions?: { id: string }[]
    author?: {
      display_name: string | null
      avatar_url: string | null
    }
  }
  userId: string | null
  isPublic?: boolean
}

export function QuestionDetail({ question, userId, isPublic = false }: QuestionDetailProps) {
  const {
    isGenerating,
    isMarkingSolved,
    isAddingToBank,
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
    stats,
  } = useQuestionDetail({ question, userId })

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      <QuestionHeader
        isPublic={isPublic}
        userId={userId}
        questionId={question.id}
        ownerId={question.owner_id}
        userQuestions={question.user_questions}
        isAddingToBank={isAddingToBank}
        handleAddToBank={handleAddToBank}
      />

      {isPublic && <QuestionAuthor author={question.author} />}

      <QuestionDeleteDialog
        show={showDeleteDialog}
        onOpenChange={setShowDeleteDialog}
        onDelete={handleDelete}
        isDeleting={isDeleting}
      />

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="md:col-span-2 space-y-6">
          <QuestionContent
            question={question}
            userId={userId}
            setShowDeleteDialog={setShowDeleteDialog}
          />
          <QuestionTabs
            question={question}
            userId={userId}
            isGenerating={isGenerating}
            isSaving={isSaving}
            editForm={editForm}
            setEditForm={setEditForm}
            handleGenerateSolution={handleGenerateSolution}
            handleSolutionDelete={handleSolutionDelete}
            handleSave={handleSave}
          />
        </div>
        <div className="space-y-6">
          <QuestionSidebar
            question={question}
            stats={stats}
            userId={userId}
            tagInput={tagInput}
            setTagInput={setTagInput}
            isSaving={isSaving}
            isMarkingSolved={isMarkingSolved}
            handleSave={(section) => handleSave(section as 'tags')}
            handleMarkSolved={handleMarkSolved}
          />
        </div>
      </div>

      {!userId && isPublic && <GuestCTA />}
    </div>
  )
}