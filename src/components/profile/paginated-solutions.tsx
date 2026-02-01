'use client'

import { useState, useEffect, useCallback } from 'react'
import { ProfileSolutionCard } from '@/components/profile/profile-solution-card'
import { useInView } from '@/hooks/use-in-view'
import { getMoreSolutions } from '@/app/actions/profile'
import { Loader2, GitFork } from 'lucide-react'
import { ProfileEmptyState } from './empty-state'
import type { Solution, Question } from '@/lib/types'

interface PaginatedSolutionListProps {
  initialSolutions: (Solution & { question: Question })[]
  userId: string
}

export function PaginatedSolutionList({ initialSolutions, userId }: PaginatedSolutionListProps) {
  const [solutions, setSolutions] = useState(initialSolutions)
  const [page, setPage] = useState(0)
  const [hasMore, setHasMore] = useState(true)
  const [isLoading, setIsLoading] = useState(false)
  const { ref, inView } = useInView()

  const loadMore = useCallback(async () => {
    setIsLoading(true)
    const nextPage = page + 1
    try {
      const { solutions: newSolutions, hasMore: more } = await getMoreSolutions(userId, nextPage)
      setSolutions(prev => [...prev, ...newSolutions])
      setPage(nextPage)
      setHasMore(more)
    } catch (error) {
      console.error('Failed to load more solutions', error)
    } finally {
      setIsLoading(false)
    }
  }, [page, userId])

  useEffect(() => {
    if (inView && hasMore && !isLoading) {
      loadMore()
    }
  }, [inView, hasMore, isLoading, loadMore])

  if (solutions.length === 0) {
    return (
      <ProfileEmptyState 
        icon={<GitFork className="w-10 h-10" />}
        title="No contributed solutions"
        description="This user hasn't contributed any solutions to other users' questions yet."
      />
    )
  }

  return (
    <div className="space-y-4">
      <div className="grid grid-cols-1 gap-4">
        {solutions.map((s) => (
          <ProfileSolutionCard
            key={s.id}
            solution={s}
          />
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
