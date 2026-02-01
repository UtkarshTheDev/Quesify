'use client'

import { useState, useEffect, useCallback } from 'react'
import { Loader2 } from 'lucide-react'
import { useInView } from '@/hooks/use-in-view'
import { getMoreActivities } from '@/app/actions/profile'
import { ActivityFeed, type ActivityItem } from './activity-feed'

interface PaginatedActivityFeedProps {
  initialItems: ActivityItem[]
  userId: string
}

export function PaginatedActivityFeed({ initialItems, userId }: PaginatedActivityFeedProps) {
  const [items, setItems] = useState<ActivityItem[]>(initialItems)
  const [page, setPage] = useState(0)
  const [hasMore, setHasMore] = useState(initialItems.length >= 20)
  const [isLoading, setIsLoading] = useState(false)
  const { ref, inView } = useInView()

  const loadMore = useCallback(async () => {
    setIsLoading(true)
    const nextPage = page + 1
    try {
      const { items: newItems, hasMore: more } = await getMoreActivities(userId, nextPage)
      setItems(prev => {
        const existingIds = new Set(prev.map(i => i.id))
        const uniqueNewItems = newItems.filter(i => !existingIds.has(i.id))
        return [...prev, ...uniqueNewItems]
      })
      setPage(nextPage)
      setHasMore(more)
    } catch (error) {
      console.error('Failed to load more activities', error)
    } finally {
      setIsLoading(false)
    }
  }, [page, userId])

  useEffect(() => {
    if (inView && hasMore && !isLoading) {
      loadMore()
    }
  }, [inView, hasMore, isLoading, loadMore])

  return (
    <div className="space-y-4">
      <ActivityFeed items={items} />
      
      {hasMore && (
        <div ref={ref} className="flex justify-center py-8">
          <Loader2 className="w-8 h-8 animate-spin text-primary/50" />
        </div>
      )}
    </div>
  )
}
