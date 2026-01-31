'use client'

import { useState, useCallback, useRef, useEffect } from 'react'

interface UsePullToRefreshOptions {
  onRefresh: () => void | Promise<void>
  threshold?: number
  maxPullDistance?: number
  enabled?: boolean
}

interface UsePullToRefreshReturn {
  containerRef: React.RefObject<HTMLDivElement | null>
  pullProgress: number
  isPulling: boolean
  isRefreshing: boolean
}

export function usePullToRefresh({
  onRefresh,
  threshold = 80,
  maxPullDistance = 120,
  enabled = true,
}: UsePullToRefreshOptions): UsePullToRefreshReturn {
  const containerRef = useRef<HTMLDivElement>(null)
  const [pullProgress, setPullProgress] = useState(0)
  const [isPulling, setIsPulling] = useState(false)
  const [isRefreshing, setIsRefreshing] = useState(false)
  const startYRef = useRef<number>(0)
  const currentYRef = useRef<number>(0)
  const isDraggingRef = useRef(false)

  const handleTouchStart = useCallback(
    (e: TouchEvent) => {
      if (!enabled || isRefreshing) return

      const container = containerRef.current
      if (!container) return

      if (container.scrollTop > 0) return

      startYRef.current = e.touches[0].clientY
      isDraggingRef.current = true
    },
    [enabled, isRefreshing]
  )

  const handleTouchMove = useCallback(
    (e: TouchEvent) => {
      if (!isDraggingRef.current || !enabled) return

      currentYRef.current = e.touches[0].clientY
      const delta = currentYRef.current - startYRef.current

      if (delta > 0) {
        if (delta < maxPullDistance) {
          e.preventDefault()
        }

        setIsPulling(true)
        const progress = Math.min(delta / threshold, 1)
        setPullProgress(progress)
      }
    },
    [enabled, threshold, maxPullDistance]
  )

  const handleTouchEnd = useCallback(async () => {
    if (!isDraggingRef.current) return

    isDraggingRef.current = false
    const delta = currentYRef.current - startYRef.current

    if (delta >= threshold && enabled) {
      setIsRefreshing(true)
      setPullProgress(1)

      try {
        await onRefresh()
      } finally {
        setIsRefreshing(false)
        setIsPulling(false)
        setPullProgress(0)
      }
    } else {
      setIsPulling(false)
      setPullProgress(0)
    }

    startYRef.current = 0
    currentYRef.current = 0
  }, [onRefresh, threshold, enabled])

  useEffect(() => {
    const container = containerRef.current
    if (!container) return

    container.addEventListener('touchstart', handleTouchStart, { passive: true })
    container.addEventListener('touchmove', handleTouchMove, { passive: false })
    container.addEventListener('touchend', handleTouchEnd, { passive: true })

    return () => {
      container.removeEventListener('touchstart', handleTouchStart)
      container.removeEventListener('touchmove', handleTouchMove)
      container.removeEventListener('touchend', handleTouchEnd)
    }
  }, [handleTouchStart, handleTouchMove, handleTouchEnd])

  return {
    containerRef,
    pullProgress,
    isPulling,
    isRefreshing,
  }
}
