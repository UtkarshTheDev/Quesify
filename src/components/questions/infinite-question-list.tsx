'use client'

import { useState, useCallback } from 'react'
import { QuestionCard } from '@/components/questions/question-card'
import { Button } from '@/components/ui/button'
import { Loader2, Filter } from 'lucide-react'
import Link from 'next/link'
import { useInfiniteScroll } from '@/hooks/use-infinite-scroll'
import { Question } from '@/lib/types'

import { ListEndDivider } from '@/components/ui/list-end-divider'

interface InfiniteQuestionListProps {
  userId: string
  initialQuestions: Question[]
  initialCursor: string | null
  filters: {
    subject?: string
    chapter?: string
    difficulty?: string
    isMCQ?: string
    ids?: string
  }
}

export function InfiniteQuestionList({
  userId,
  initialQuestions,
  initialCursor,
  filters,
}: InfiniteQuestionListProps) {
  const [questions, setQuestions] = useState<Question[]>(initialQuestions)
  const [cursor, setCursor] = useState<string | null>(initialCursor)
  const [error, setError] = useState<string | null>(null)

  const loadMore = useCallback(async () => {
    if (!cursor) return

    try {
      const params = new URLSearchParams({
        user_id: userId,
        cursor,
        limit: '20',
        ...(filters.subject && { subject: filters.subject }),
        ...(filters.chapter && { chapter: filters.chapter }),
        ...(filters.difficulty && { difficulty: filters.difficulty }),
        ...(filters.isMCQ && { isMCQ: filters.isMCQ }),
        ...(filters.ids && { ids: filters.ids }),
      })

      const response = await fetch(`/api/pagination/questions?${params}`)
      
      if (!response.ok) {
        throw new Error('Failed to load more questions')
      }

      const data = await response.json()
      
      setQuestions((prev) => [...prev, ...data.data])
      setCursor(data.next_cursor)
      
      if (!data.has_more) {
        setHasMore(false)
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load more')
    } finally {
      setIsLoading(false)
    }
  }, [cursor, userId, filters])

  const { sentinelRef, isLoading, hasMore, setHasMore, setIsLoading } = useInfiniteScroll({
    onLoadMore: loadMore,
    enabled: !!cursor,
  })

  if (questions.length === 0) {
    return (
      <div className="text-center py-16 border rounded-lg bg-muted/10 border-dashed flex flex-col items-center justify-center gap-4">
        <div className="bg-primary/10 p-4 rounded-full">
          <Filter className="h-8 w-8 text-primary opacity-50" />
        </div>
        <div className="space-y-2 max-w-sm">
          <h3 className="text-lg font-semibold">No questions found</h3>
          <p className="text-muted-foreground text-sm">
            Your question bank is empty. Start by uploading your first question!
          </p>
        </div>
        <Button asChild>
          <Link href="/upload">Upload Question</Link>
        </Button>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {questions.map((question) => (
          <QuestionCard key={question.id} question={question} />
        ))}
      </div>

      {error && (
        <div className="text-center py-4">
          <p className="text-red-500 text-sm">{error}</p>
          <Button
            variant="outline"
            size="sm"
            onClick={() => {
              setError(null)
              loadMore()
            }}
            className="mt-2"
          >
            Retry
          </Button>
        </div>
      )}

      {hasMore && (
        <div
          ref={sentinelRef}
          className="flex justify-center py-8"
        >
          {isLoading && (
            <div className="flex items-center gap-2 text-muted-foreground">
              <Loader2 className="h-5 w-5 animate-spin" />
              <span className="text-sm">Loading more...</span>
            </div>
          )}
        </div>
      )}

      {!hasMore && questions.length > 0 && (
        <ListEndDivider />
      )}
    </div>
  )
}
