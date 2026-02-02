'use client'

import { memo } from 'react'
import type { FeedItem, RecommendedQuestion, RecommendedUser } from '@/lib/types'
import { QuestionFeedCard } from './question-feed-card'
import { UserSuggestionCard } from './user-suggestion-card'

interface FeedCardProps {
    item: FeedItem
    onAddToBank?: (questionId: string) => Promise<void>
    onFollow?: (userId: string) => Promise<void>
}

export const FeedCard = memo(function FeedCard({
    item,
    onAddToBank,
    onFollow,
}: FeedCardProps) {
    if (item.type === 'question') {
        return (
            <QuestionFeedCard
                question={item.data as RecommendedQuestion}
                onAddToBank={onAddToBank}
            />
        )
    }

    if (item.type === 'user_suggestion') {
        return (
            <UserSuggestionCard
                user={item.data as RecommendedUser}
                onFollow={onFollow}
            />
        )
    }

    return null
})
