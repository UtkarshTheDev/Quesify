'use client'

import { memo } from 'react'
import Link from 'next/link'
import { UserPlus, UserCheck, Loader2, Users, BookOpen, Lightbulb } from 'lucide-react'
import { Card, CardContent } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Button } from '@/components/ui/button'
import type { RecommendedUser } from '@/lib/types'
import { useState } from 'react'
import { toast } from 'sonner'

interface UserSuggestionCardProps {
    user: RecommendedUser
    onFollow?: (userId: string) => Promise<void>
}

export const UserSuggestionCard = memo(function UserSuggestionCard({
    user,
    onFollow,
}: UserSuggestionCardProps) {
    const [isFollowing, setIsFollowing] = useState(user.is_following)
    const [isPending, setIsPending] = useState(false)

    const handleFollow = async (e: React.MouseEvent) => {
        e.preventDefault()
        e.stopPropagation()

        if (isPending) return

        const previousState = isFollowing
        setIsFollowing(!previousState)
        setIsPending(true)

        try {
            const method = previousState ? 'DELETE' : 'POST'
            const response = await fetch('/api/social/follow', {
                method,
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ target_id: user.user_id }),
            })

            if (!response.ok) throw new Error('Failed to update follow status')

            toast.success(previousState ? 'Unfollowed' : 'Following!')
            onFollow?.(user.user_id)
        } catch (error) {
            setIsFollowing(previousState)
            toast.error('Failed to update follow status')
            console.error(error)
        } finally {
            setIsPending(false)
        }
    }

    return (
        <Card className="w-full bg-gradient-to-br from-blue-950/40 to-stone-950/90 border border-blue-500/20 hover:border-blue-500/40 transition-all duration-500 backdrop-blur-md shadow-[0_8px_32px_rgba(0,0,0,0.4)] hover:shadow-[0_8px_48px_rgba(59,130,246,0.15)] group relative overflow-hidden">
            <div className="absolute inset-0 bg-gradient-to-br from-blue-500/5 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500" />

            {/* Suggestion Label */}
            <div className="absolute top-0 left-0 px-3 py-1.5 bg-blue-500/20 border-b border-r border-blue-500/20 rounded-br-lg">
                <span className="text-[10px] font-medium text-blue-400 uppercase tracking-wider">
                    Suggested for you
                </span>
            </div>

            <CardContent className="p-5 pt-12 relative z-10">
                <div className="flex flex-col gap-5">
                    {/* Top Row: Avatar, Info, and Follow Button */}
                    <div className="flex items-center justify-between gap-4">
                        <div className="flex items-center gap-4 min-w-0">
                            {/* Avatar */}
                            <Link
                                href={`/u/${user.username || user.user_id}`}
                                className="shrink-0 group/avatar"
                            >
                                <Avatar className="h-14 w-14 ring-2 ring-blue-500/30 group-hover/avatar:ring-blue-500/60 transition-all shadow-lg">
                                    <AvatarImage src={user.avatar_url || undefined} />
                                    <AvatarFallback className="bg-blue-950 text-blue-300 text-lg font-medium">
                                        {user.display_name?.[0]?.toUpperCase() || user.username?.[0]?.toUpperCase() || 'U'}
                                    </AvatarFallback>
                                </Avatar>
                            </Link>

                            {/* User Info */}
                            <div className="min-w-0">
                                <Link
                                    href={`/u/${user.username || user.user_id}`}
                                    className="flex flex-col"
                                >
                                    <span className="text-base font-semibold text-stone-100 group-hover:text-blue-400 transition-colors truncate">
                                        {user.display_name || user.username || 'Anonymous'}
                                    </span>
                                    <span className="text-sm text-stone-500 truncate">
                                        @{user.username || 'user'}
                                    </span>
                                </Link>
                            </div>
                        </div>

                        {/* Follow Button */}
                        <Button
                            onClick={handleFollow}
                            disabled={isPending}
                            variant={isFollowing ? 'default' : 'outline'}
                            size="sm"
                            className={`shrink-0 h-9 px-4 font-medium transition-all duration-300 ${isFollowing
                                ? 'bg-blue-500 hover:bg-blue-600 text-white border-blue-500'
                                : 'border-blue-500/50 text-blue-400 hover:bg-blue-500/10 hover:border-blue-500'
                                }`}
                        >
                            {isPending ? (
                                <Loader2 className="h-4 w-4 animate-spin" />
                            ) : isFollowing ? (
                                <>
                                    <UserCheck className="h-4 w-4 mr-1.5" />
                                    <span className="hidden xs:inline">Following</span>
                                    <span className="xs:hidden">Yes</span>
                                </>
                            ) : (
                                <>
                                    <UserPlus className="h-4 w-4 mr-1.5" />
                                    <span className="hidden xs:inline">Follow</span>
                                    <span className="xs:hidden">Add</span>
                                </>
                            )}
                        </Button>
                    </div>

                    {/* Stats Row: Below Name/Handle and Button */}
                    <div className="flex items-center gap-6 pt-1 border-t border-blue-500/10">
                        <div className="flex items-center gap-2 text-xs text-stone-400">
                            <BookOpen className="h-3.5 w-3.5 text-blue-400/70" />
                            <span className="whitespace-nowrap"><span className="text-stone-200 font-medium">{user.total_questions}</span> questions</span>
                        </div>
                        <div className="flex items-center gap-2 text-xs text-stone-400">
                            <Lightbulb className="h-3.5 w-3.5 text-orange-400/70" />
                            <span className="whitespace-nowrap"><span className="text-stone-200 font-medium">{user.total_solutions}</span> solutions</span>
                        </div>
                    </div>
                </div>

                {/* Connection Info */}
                <div className="mt-4 flex flex-wrap gap-2">
                    {user.mutual_follows_count > 0 && (
                        <Badge
                            variant="outline"
                            className="bg-stone-900/60 text-stone-300 border-stone-700/50 text-[10px] px-2 py-0.5"
                        >
                            <Users className="h-3 w-3 mr-1" />
                            {user.mutual_follows_count} mutual
                        </Badge>
                    )}
                    {user.common_subjects && user.common_subjects.length > 0 && (
                        <>
                            {user.common_subjects.slice(0, 3).map((subject) => (
                                <Badge
                                    key={subject}
                                    variant="outline"
                                    className="bg-blue-500/10 text-blue-400 border-blue-500/20 text-[10px] px-2 py-0.5"
                                >
                                    {subject}
                                </Badge>
                            ))}
                        </>
                    )}
                </div>
            </CardContent>
        </Card>
    )
})
