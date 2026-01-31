'use client'

import { useState, useCallback } from 'react'
import { QuestionCard } from '@/components/questions/question-card'
import { useInfiniteScroll } from '@/hooks/use-infinite-scroll'
import { Loader2 } from 'lucide-react'
import { Question } from '@/lib/types'

import { ListEndDivider } from '@/components/ui/list-end-divider'

interface InfiniteProfileQuestionsProps {
  userId: string
}

export function InfiniteProfileQuestions({ userId }: InfiniteProfileQuestionsProps) {
  const [questions, setQuestions] = useState<Question[]>([])
  const [cursor, setCursor] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [initialLoaded, setInitialLoaded] = useState(false)

  const loadMore = useCallback(async () => {
    try {
      const params = new URLSearchParams({
        user_id: userId,
        limit: '20',
        ...(cursor && { cursor }),
      })

      const response = await fetch(`/api/pagination/questions?${params}`)

      if (!response.ok) {
        throw new Error('Failed to load questions')
      }

      const data = await response.json()

      setQuestions((prev) => (cursor ? [...prev, ...data.data] : data.data))
      setCursor(data.next_cursor)

      if (!data.has_more) {
        setHasMore(false)
      }

      if (!initialLoaded) {
        setInitialLoaded(true)
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load questions')
    } finally {
      setIsLoading(false)
    }
  }, [cursor, userId, initialLoaded])

  const { sentinelRef, isLoading, hasMore, setHasMore, setIsLoading } = useInfiniteScroll({
    onLoadMore: loadMore,
    enabled: !initialLoaded || !!cursor,
  })

  if (error && questions.length === 0) {
    return (
      <div className="text-center py-8 text-red-500">
        <p>{error}</p>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {!initialLoaded && isLoading ? (
        <div className="flex justify-center py-8">
          <Loader2 className="h-6 w-6 animate-spin text-muted-foreground" />
        </div>
      ) : (
        <>
          <div className="grid grid-cols-1 gap-4">
            {questions.map((question) => (
              <QuestionCard key={question.id} question={question} />
            ))}
          </div>

          {hasMore && (
            <div ref={sentinelRef} className="flex justify-center py-4">
              {isLoading && (
                <div className="flex items-center gap-2 text-muted-foreground">
                  <Loader2 className="h-5 w-5 animate-spin" />
                  <span className="text-sm">Loading more...</span>
                </div>
              )}
            </div>
          )}

          {!hasMore && (
            <ListEndDivider />
          )}
        </>
      )}
    </div>
  )
}
