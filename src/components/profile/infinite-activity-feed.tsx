'use client'

import { useState, useCallback, useRef, useEffect } from 'react'
import { ActivityFeed, ActivityItem } from '@/components/profile/activity-feed'
import { useInfiniteScroll } from '@/hooks/use-infinite-scroll'
import { Loader2 } from 'lucide-react'

interface InfiniteActivityFeedProps {
  userId: string
}

export function InfiniteActivityFeed({ userId }: InfiniteActivityFeedProps) {
  const [activities, setActivities] = useState<ActivityItem[]>([])
  const [cursor, setCursor] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [initialLoaded, setInitialLoaded] = useState(false)
  const [hasMore, setHasMore] = useState(true)
  
  const setIsLoadingRef = useRef<((value: boolean) => void) | null>(null)

  const loadMore = useCallback(async () => {
    try {
      const params = new URLSearchParams({
        user_id: userId,
        limit: '20',
        ...(cursor && { cursor }),
      })

      const response = await fetch(`/api/pagination/activities?${params}`)

      if (!response.ok) {
        throw new Error('Failed to load activities')
      }

      const data = await response.json()

      setActivities((prev) => (cursor ? [...prev, ...data.data] : data.data))
      setCursor(data.next_cursor)

      if (!data.has_more) {
        setHasMore(false)
      }

      if (!initialLoaded) {
        setInitialLoaded(true)
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load activities')
    } finally {
      if (setIsLoadingRef.current) {
        setIsLoadingRef.current(false)
      }
    }
  }, [cursor, userId, initialLoaded])

  const { sentinelRef, isLoading, setIsLoading } = useInfiniteScroll({
    onLoadMore: loadMore,
    enabled: hasMore && (!initialLoaded || !!cursor),
  })

  useEffect(() => {
    setIsLoadingRef.current = setIsLoading
  }, [setIsLoading])


  if (error && activities.length === 0) {
    return (
      <div className="text-center py-8 text-red-500">
        <p>{error}</p>
      </div>
    )
  }

  return (
    <div className="space-y-4">
      {!initialLoaded && isLoading ? (
        <div className="flex justify-center py-8">
          <Loader2 className="h-6 w-6 animate-spin text-muted-foreground" />
        </div>
      ) : (
        <>
          <ActivityFeed items={activities} />

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

          {!hasMore && activities.length > 0 && (
            <div className="text-center py-4 text-muted-foreground text-sm">
              No more activities
            </div>
          )}
        </>
      )}
    </div>
  )
}
