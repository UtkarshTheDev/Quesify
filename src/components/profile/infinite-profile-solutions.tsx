'use client'

import { useState, useCallback } from 'react'
import { SolutionCard } from '@/components/questions/solution-card'
import { useInfiniteScroll } from '@/hooks/use-infinite-scroll'
import { Loader2 } from 'lucide-react'
import { Solution } from '@/lib/types'

interface InfiniteProfileSolutionsProps {
  userId: string
  currentUserId: string | null
}

export function InfiniteProfileSolutions({ userId, currentUserId }: InfiniteProfileSolutionsProps) {
  const [solutions, setSolutions] = useState<Solution[]>([])
  const [cursor, setCursor] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [initialLoaded, setInitialLoaded] = useState(false)

  const loadMore = useCallback(async () => {
    try {
      const params = new URLSearchParams({
        user_id: userId,
        limit: '20',
        exclude_own: 'true',
        ...(cursor && { cursor }),
      })

      const response = await fetch(`/api/pagination/solutions?${params}`)

      if (!response.ok) {
        throw new Error('Failed to load solutions')
      }

      const data = await response.json()

      setSolutions((prev) => (cursor ? [...prev, ...data.data] : data.data))
      setCursor(data.next_cursor)

      if (!data.has_more) {
        setHasMore(false)
      }

      if (!initialLoaded) {
        setInitialLoaded(true)
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load solutions')
    } finally {
      setIsLoading(false)
    }
  }, [cursor, userId, initialLoaded])

  const { sentinelRef, isLoading, hasMore, setHasMore, setIsLoading } = useInfiniteScroll({
    onLoadMore: loadMore,
    enabled: !initialLoaded || !!cursor,
  })

  if (error && solutions.length === 0) {
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
          <div className="space-y-4">
            {solutions.map((solution) => (
              <SolutionCard
                key={solution.id}
                solution={solution}
                currentUserId={currentUserId}
              />
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

          {!hasMore && solutions.length > 0 && (
            <div className="text-center py-4 text-muted-foreground text-sm">
              No more solutions
            </div>
          )}
        </>
      )}
    </div>
  )
}
