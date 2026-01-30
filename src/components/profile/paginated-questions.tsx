'use client'

import { useState, useEffect } from 'react'
import { QuestionCard } from '@/components/questions/question-card'
import { useInView } from '@/hooks/use-in-view'
import { getMoreQuestions } from '@/app/actions/profile'
import { Loader2, BookOpen } from 'lucide-react'
import { ProfileEmptyState } from './empty-state'

interface PaginatedQuestionListProps {
  initialQuestions: any[]
  userId: string
}

export function PaginatedQuestionList({ initialQuestions, userId }: PaginatedQuestionListProps) {
  const [questions, setQuestions] = useState(initialQuestions)
  const [page, setPage] = useState(0)
  const [hasMore, setHasMore] = useState(true)
  const [isLoading, setIsLoading] = useState(false)
  const { ref, inView } = useInView()

  useEffect(() => {
    if (inView && hasMore && !isLoading) {
      loadMore()
    }
  }, [inView, hasMore, isLoading])

  const loadMore = async () => {
    setIsLoading(true)
    const nextPage = page + 1
    try {
      const { questions: newQuestions, hasMore: more } = await getMoreQuestions(userId, nextPage)
      setQuestions(prev => [...prev, ...newQuestions])
      setPage(nextPage)
      setHasMore(more)
    } catch (error) {
      console.error('Failed to load more questions', error)
    } finally {
      setIsLoading(false)
    }
  }

  if (questions.length === 0) {
    return (
      <ProfileEmptyState 
        icon={<BookOpen className="w-10 h-10" />}
        title="No questions found"
        description="This user hasn't uploaded or added any questions to their bank yet."
      />
    )
  }

  return (
    <div className="space-y-4">
      <div className="grid grid-cols-1 gap-4">
        {questions.map((q: any) => (
          <QuestionCard key={q.id} question={q} />
        ))}
      </div>
      
      {hasMore && (
        <div ref={ref} className="flex justify-center py-4">
          <Loader2 className="w-6 h-6 animate-spin text-muted-foreground" />
        </div>
      )}
    </div>
  )
}
