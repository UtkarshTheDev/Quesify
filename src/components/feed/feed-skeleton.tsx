'use client'

import { Card, CardContent } from '@/components/ui/card'
import { Skeleton } from '@/components/ui/skeleton'

interface FeedSkeletonProps {
    type?: 'question' | 'user'
    count?: number
}

export function FeedSkeleton({ type = 'question', count = 3 }: FeedSkeletonProps) {
    return (
        <div className="space-y-4">
            {Array.from({ length: count }).map((_, i) => (
                <Card
                    key={i}
                    className={`w-full border backdrop-blur-md ${type === 'user'
                            ? 'bg-gradient-to-br from-blue-950/40 to-stone-950/90 border-blue-500/20'
                            : 'bg-gradient-to-br from-stone-900/90 to-neutral-950/90 border-stone-800/80'
                        }`}
                >
                    <CardContent className="p-5">
                        {type === 'question' ? (
                            // Question skeleton
                            <div className="space-y-4">
                                {/* Header */}
                                <div className="flex items-center justify-between">
                                    <div className="flex items-center gap-2.5">
                                        <Skeleton className="h-8 w-8 rounded-full bg-stone-800" />
                                        <div className="space-y-1.5">
                                            <Skeleton className="h-3.5 w-24 bg-stone-800" />
                                            <Skeleton className="h-2.5 w-16 bg-stone-800/50" />
                                        </div>
                                    </div>
                                    <div className="flex items-center gap-2">
                                        <Skeleton className="h-5 w-16 rounded-full bg-stone-800" />
                                        <Skeleton className="h-5 w-14 rounded-full bg-stone-800" />
                                    </div>
                                </div>

                                {/* Question text */}
                                <div className="space-y-2">
                                    <Skeleton className="h-4 w-full bg-stone-800" />
                                    <Skeleton className="h-4 w-3/4 bg-stone-800" />
                                    <Skeleton className="h-4 w-1/2 bg-stone-800" />
                                </div>

                                {/* Footer */}
                                <div className="pt-3 border-t border-stone-800/80">
                                    <div className="flex items-center justify-between">
                                        <div className="flex items-center gap-2">
                                            <Skeleton className="h-1.5 w-1.5 rounded-full bg-orange-500/50" />
                                            <Skeleton className="h-3.5 w-32 bg-stone-800" />
                                        </div>
                                        <div className="flex items-center gap-2">
                                            <Skeleton className="h-8 w-24 rounded-md bg-stone-800" />
                                            <Skeleton className="h-8 w-8 rounded-lg bg-stone-800" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        ) : (
                            // User skeleton
                            <div className="pt-5">
                                <div className="flex items-center gap-4">
                                    <Skeleton className="h-14 w-14 rounded-full bg-blue-950" />
                                    <div className="flex-1 space-y-2">
                                        <Skeleton className="h-4 w-32 bg-blue-950" />
                                        <Skeleton className="h-3 w-20 bg-blue-950/50" />
                                        <div className="flex gap-3 mt-2">
                                            <Skeleton className="h-3 w-20 bg-blue-950/50" />
                                            <Skeleton className="h-3 w-20 bg-blue-950/50" />
                                        </div>
                                    </div>
                                    <Skeleton className="h-9 w-24 rounded-md bg-blue-950" />
                                </div>
                                <div className="flex gap-2 mt-4">
                                    <Skeleton className="h-5 w-20 rounded-full bg-stone-800" />
                                    <Skeleton className="h-5 w-16 rounded-full bg-blue-950/50" />
                                </div>
                            </div>
                        )}
                    </CardContent>
                </Card>
            ))}
        </div>
    )
}

export function FeedLoadingMore() {
    return (
        <div className="flex items-center justify-center py-8">
            <div className="flex items-center gap-3 text-stone-400">
                <div className="h-5 w-5 border-2 border-orange-500 border-t-transparent rounded-full animate-spin" />
                <span className="text-sm">Loading more...</span>
            </div>
        </div>
    )
}
