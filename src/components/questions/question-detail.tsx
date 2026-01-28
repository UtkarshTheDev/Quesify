'use client'

import type { Question, Solution, UserQuestionStats } from '@/lib/types'
import {
  GuestCTA,
  QuestionAuthor,
  QuestionContent,
  QuestionDeleteDialog,
  QuestionHeader,
  QuestionSidebar,
  QuestionTabs,
  useQuestionDetail,
} from './question-detail/index'

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
  totalSolutionsCount?: number
}

export function QuestionDetail({ question, userId, isPublic = false, totalSolutionsCount = 0 }: QuestionDetailProps) {
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
    fetchSharingStats,
    sharingStats,
    stats,
    isRevealed,
    setIsRevealed,
    selectedSolutionId,
    setSelectedSolutionId,
    moreSolutions,
    isLoadingMore,
    loadMoreSolutions,
    isEditingHint,
    setIsEditingHint,
    isEditingTags,
    setIsEditingTags,
    isShared,
  } = useQuestionDetail({ question, userId })

  const bestSolution = question.solutions[0] || null
  const currentSolution = selectedSolutionId 
    ? moreSolutions.find(s => s.id === selectedSolutionId)
    : bestSolution

  return (
    <div className="max-w-6xl mx-auto space-y-6">
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
        isShared={isShared}
        usageCount={sharingStats?.count ?? null}
      />

      <div className="grid grid-cols-1 md:grid-cols-10 gap-6">
        <div className="md:col-span-7 space-y-6">
      <QuestionContent
        question={question}
        userId={userId}
        setShowDeleteDialog={setShowDeleteDialog}
        revealed={isRevealed}
        correctOption={currentSolution?.correct_option}
        fetchSharingStats={fetchSharingStats}
        sharingStats={sharingStats}
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
            totalSolutionsCount={totalSolutionsCount}
            isRevealed={isRevealed}
            setIsRevealed={setIsRevealed}
            selectedSolutionId={selectedSolutionId}
            setSelectedSolutionId={setSelectedSolutionId}
            moreSolutions={moreSolutions}
            isLoadingMore={isLoadingMore}
            loadMoreSolutions={loadMoreSolutions}
            isEditingHint={isEditingHint}
            setIsEditingHint={setIsEditingHint}
          />
        </div>
        <div className="md:col-span-3 space-y-6">
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
            isEditingTags={isEditingTags}
            setIsEditingTags={setIsEditingTags}
          />
        </div>
      </div>

      {!userId && isPublic && <GuestCTA />}
    </div>
  )
}