'use client'

import { useRef, useEffect, useCallback } from 'react'
import { Sparkles, RefreshCw, AlertCircle, Compass, UserPlus, BookOpen } from 'lucide-react'
import { useFeed } from '@/hooks/use-feed'
import { FeedCard, FeedSkeleton, FeedLoadingMore } from '@/components/feed'
import { Button } from '@/components/ui/button'
import { Card, CardContent } from '@/components/ui/card'
import { useInfiniteScroll } from '@/hooks/use-infinite-scroll'
import { toast } from 'sonner'

export default function DailyFeedPage() {
  const {
    items,
    isLoading,
    isLoadingMore,
    hasMore,
    error,
    fetchNextPage,
    refresh,
  } = useFeed()

  const { sentinelRef, setHasMore, setIsLoading } = useInfiniteScroll({
    enabled: !isLoading && hasMore,
    onLoadMore: fetchNextPage,
  })

  // Sync hasMore state with scroll hook
  useEffect(() => {
    setHasMore(hasMore)
  }, [hasMore, setHasMore])

  useEffect(() => {
    setIsLoading(isLoadingMore)
  }, [isLoadingMore, setIsLoading])

  const handleRefresh = useCallback(async () => {
    toast.promise(refresh(), {
      loading: 'Refreshing your feed...',
      success: 'Feed refreshed!',
      error: 'Failed to refresh feed',
    })
  }, [refresh])

  const handleAddToBank = useCallback(async (questionId: string) => {
    // Refresh feed to invalidate cache after adding to bank
    await fetch('/api/feed/refresh', { method: 'POST' })
  }, [])

  const handleFollow = useCallback(async (userId: string) => {
    // Refresh feed to invalidate cache after following
    await fetch('/api/feed/refresh', { method: 'POST' })
  }, [])

  // Loading state
  if (isLoading) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-stone-950 via-neutral-950 to-stone-950">
        <div className="container mx-auto px-4 py-8 max-w-2xl">
          {/* Header Skeleton */}
          <div className="mb-8 space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="h-10 w-10 rounded-xl bg-stone-800 animate-pulse" />
                <div className="space-y-2">
                  <div className="h-6 w-32 bg-stone-800 rounded animate-pulse" />
                  <div className="h-3 w-48 bg-stone-800/50 rounded animate-pulse" />
                </div>
              </div>
              <div className="h-9 w-24 bg-stone-800 rounded-lg animate-pulse" />
            </div>
          </div>

          <FeedSkeleton count={4} />
        </div>
      </div>
    )
  }

  // Error state
  if (error) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-stone-950 via-neutral-950 to-stone-950 flex items-center justify-center">
        <Card className="max-w-md w-full mx-4 bg-stone-900/80 border-red-500/30">
          <CardContent className="p-8 text-center space-y-4">
            <div className="h-16 w-16 rounded-full bg-red-500/10 flex items-center justify-center mx-auto">
              <AlertCircle className="h-8 w-8 text-red-400" />
            </div>
            <h3 className="text-xl font-semibold text-stone-100">Failed to load feed</h3>
            <p className="text-stone-400 text-sm">{error}</p>
            <Button onClick={handleRefresh} variant="outline" className="border-red-500/30 hover:bg-red-500/10">
              <RefreshCw className="h-4 w-4 mr-2" />
              Try Again
            </Button>
          </CardContent>
        </Card>
      </div>
    )
  }

  // Empty state (new user or no recommendations)
  if (items.length === 0) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-stone-950 via-neutral-950 to-stone-950">
        <div className="container mx-auto px-4 py-8 max-w-2xl">
          {/* Header */}
          <header className="mb-8">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-xl bg-gradient-to-br from-orange-500 to-amber-600 flex items-center justify-center shadow-lg shadow-orange-500/20">
                <Sparkles className="h-5 w-5 text-white" />
              </div>
              <div>
                <h1 className="text-2xl font-bold text-stone-100">Your Daily Feed</h1>
                <p className="text-sm text-stone-400">Personalized questions and people for you</p>
              </div>
            </div>
          </header>

          {/* Empty State Cards */}
          <div className="grid gap-6">
            <Card className="bg-gradient-to-br from-stone-900/80 to-stone-950 border-stone-800/60">
              <CardContent className="p-8 text-center space-y-6">
                <div className="h-20 w-20 rounded-full bg-orange-500/10 flex items-center justify-center mx-auto">
                  <Compass className="h-10 w-10 text-orange-400" />
                </div>
                <div className="space-y-2">
                  <h3 className="text-xl font-semibold text-stone-100">Start Exploring!</h3>
                  <p className="text-stone-400 text-sm max-w-sm mx-auto">
                    Your personalized feed will appear here as you start using Quesify.
                    Upload questions, follow people, and build your study bank.
                  </p>
                </div>

                <div className="grid grid-cols-2 gap-4 pt-4">
                  <a
                    href="/dashboard/upload"
                    className="flex flex-col items-center gap-2 p-4 rounded-xl bg-orange-500/10 border border-orange-500/20 hover:bg-orange-500/20 transition-colors"
                  >
                    <BookOpen className="h-6 w-6 text-orange-400" />
                    <span className="text-sm font-medium text-orange-300">Upload Questions</span>
                  </a>
                  <a
                    href="/dashboard/explore"
                    className="flex flex-col items-center gap-2 p-4 rounded-xl bg-blue-500/10 border border-blue-500/20 hover:bg-blue-500/20 transition-colors"
                  >
                    <UserPlus className="h-6 w-6 text-blue-400" />
                    <span className="text-sm font-medium text-blue-300">Find People</span>
                  </a>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    )
  }

  // Main feed
  return (
    <div className="min-h-screen bg-gradient-to-b from-stone-950 via-neutral-950 to-stone-950">
      <div className="container mx-auto px-4 py-8 max-w-2xl">
        {/* Header */}
        <header className="mb-8 sticky top-0 z-20 -mx-4 px-4 py-4 bg-stone-950/80 backdrop-blur-lg border-b border-stone-800/50">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-xl bg-gradient-to-br from-orange-500 to-amber-600 flex items-center justify-center shadow-lg shadow-orange-500/20">
                <Sparkles className="h-5 w-5 text-white" />
              </div>
              <div>
                <h1 className="text-xl font-bold text-stone-100">Daily Feed</h1>
                <p className="text-xs text-stone-400">Questions & people for you</p>
              </div>
            </div>

            <Button
              onClick={handleRefresh}
              variant="outline"
              size="sm"
              className="border-stone-700 hover:border-orange-500/50 hover:bg-orange-500/10 hover:text-orange-400"
            >
              <RefreshCw className="h-4 w-4 mr-2" />
              Refresh
            </Button>
          </div>
        </header>

        {/* Feed Items */}
        <div className="space-y-4">
          {items.map((item) => (
            <FeedCard
              key={item.id}
              item={item}
              onAddToBank={handleAddToBank}
              onFollow={handleFollow}
            />
          ))}

          {/* Loading More Indicator */}
          {isLoadingMore && <FeedLoadingMore />}

          {/* Infinite Scroll Sentinel */}
          {hasMore && (
            <div ref={sentinelRef} className="h-4" aria-hidden="true" />
          )}

          {/* End of Feed */}
          {!hasMore && items.length > 0 && (
            <div className="py-8 text-center">
              <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-stone-900/60 border border-stone-800 text-stone-400 text-sm">
                <Sparkles className="h-4 w-4 text-orange-500" />
                You&apos;re all caught up!
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
