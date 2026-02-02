'use client'

import { useState, useCallback, useEffect } from 'react'
import type { FeedItem, FeedResponse } from '@/lib/types'

interface UseFeedOptions {
    initialLimit?: number
}

interface UseFeedReturn {
    items: FeedItem[]
    isLoading: boolean
    isLoadingMore: boolean
    hasMore: boolean
    error: string | null
    fetchNextPage: () => Promise<void>
    refetch: () => Promise<void>
    refresh: () => Promise<void>
}

export function useFeed({ initialLimit = 20 }: UseFeedOptions = {}): UseFeedReturn {
    const [items, setItems] = useState<FeedItem[]>([])
    const [isLoading, setIsLoading] = useState(true)
    const [isLoadingMore, setIsLoadingMore] = useState(false)
    const [hasMore, setHasMore] = useState(true)
    const [error, setError] = useState<string | null>(null)
    const [offset, setOffset] = useState(0)

    // Initial fetch
    const fetchFeed = useCallback(async (reset = false) => {
        const currentOffset = reset ? 0 : offset
        const loadingState = reset ? setIsLoading : setIsLoadingMore

        loadingState(true)
        setError(null)

        try {
            const response = await fetch(
                `/api/feed?limit=${initialLimit}&offset=${currentOffset}`
            )

            if (!response.ok) {
                throw new Error('Failed to fetch feed')
            }

            const data: FeedResponse = await response.json()

            if (reset) {
                setItems(data.items)
            } else {
                setItems((prev) => [...prev, ...data.items])
            }

            setHasMore(data.hasMore)
            setOffset(data.offset)
        } catch (err) {
            setError(err instanceof Error ? err.message : 'Something went wrong')
        } finally {
            loadingState(false)
        }
    }, [offset, initialLimit])

    // Fetch next page
    const fetchNextPage = useCallback(async () => {
        if (isLoadingMore || !hasMore) return
        await fetchFeed(false)
    }, [fetchFeed, isLoadingMore, hasMore])

    // Refetch from beginning
    const refetch = useCallback(async () => {
        setOffset(0)
        setHasMore(true)
        await fetchFeed(true)
    }, [fetchFeed])

    // Force refresh (invalidate cache and refetch)
    const refresh = useCallback(async () => {
        try {
            await fetch('/api/feed/refresh', { method: 'POST' })
            await refetch()
        } catch (err) {
            console.error('Failed to refresh feed:', err)
            await refetch() // Still try to refetch even if cache clear fails
        }
    }, [refetch])

    // Initial load
    useEffect(() => {
        fetchFeed(true)
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [])

    return {
        items,
        isLoading,
        isLoadingMore,
        hasMore,
        error,
        fetchNextPage,
        refetch,
        refresh,
    }
}
