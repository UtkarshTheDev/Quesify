'use client'

import { useCallback, useEffect, useRef, useState } from 'react'

interface UseInfiniteScrollOptions {
  threshold?: number
  rootMargin?: string
  enabled?: boolean
  onLoadMore?: () => void
}

interface UseInfiniteScrollReturn {
  sentinelRef: React.RefObject<HTMLDivElement | null>
  isLoading: boolean
  hasMore: boolean
  setHasMore: (value: boolean) => void
  setIsLoading: (value: boolean) => void
  reset: () => void
}

export function useInfiniteScroll({
  threshold = 0.1,
  rootMargin = '100px',
  enabled = true,
  onLoadMore,
}: UseInfiniteScrollOptions): UseInfiniteScrollReturn {
  const sentinelRef = useRef<HTMLDivElement>(null)
  const [isLoading, setIsLoading] = useState(false)
  const [hasMore, setHasMore] = useState(true)
  const observerRef = useRef<IntersectionObserver | null>(null)
  const isLoadingRef = useRef(isLoading)

  isLoadingRef.current = isLoading

  const handleIntersection = useCallback(
    (entries: IntersectionObserverEntry[]) => {
      const [entry] = entries

      if (entry.isIntersecting && !isLoadingRef.current && hasMore && enabled && onLoadMore) {
        setIsLoading(true)
        onLoadMore()
      }
    },
    [hasMore, enabled, onLoadMore]
  )

  useEffect(() => {
    const sentinel = sentinelRef.current

    if (!sentinel || !enabled) {
      if (observerRef.current) {
        observerRef.current.disconnect()
        observerRef.current = null
      }
      return
    }

    observerRef.current = new IntersectionObserver(handleIntersection, {
      threshold,
      rootMargin,
    })

    observerRef.current.observe(sentinel)

    return () => {
      if (observerRef.current) {
        observerRef.current.disconnect()
      }
    }
  }, [threshold, rootMargin, enabled, handleIntersection])

  const reset = useCallback(() => {
    setHasMore(true)
    setIsLoading(false)
  }, [])

  return {
    sentinelRef,
    isLoading,
    hasMore,
    setHasMore,
    setIsLoading,
    reset,
  }
}
