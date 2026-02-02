'use client'

import { memo } from 'react'
import Link from 'next/link'
import { formatDistanceToNow } from 'date-fns'
import { MessageSquare, ArrowRight, Plus, Check, RefreshCw } from 'lucide-react'
import { Card, CardContent } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Latex } from '@/components/ui/latex'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Button } from '@/components/ui/button'
import type { RecommendedQuestion } from '@/lib/types'
import { useState } from 'react'
import { toast } from 'sonner'

interface QuestionFeedCardProps {
    question: RecommendedQuestion
    onAddToBank?: (questionId: string) => Promise<void>
}

export const QuestionFeedCard = memo(function QuestionFeedCard({
    question,
    onAddToBank,
}: QuestionFeedCardProps) {
    const [isAdding, setIsAdding] = useState(false)
    const [isInBank, setIsInBank] = useState(question.is_in_bank)

    const getDifficultyStyles = (level: string) => {
        switch (level) {
            case 'easy':
                return 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20'
            case 'medium':
                return 'bg-amber-500/10 text-amber-400 border-amber-500/20'
            case 'hard':
                return 'bg-orange-500/10 text-orange-400 border-orange-500/20'
            case 'very_hard':
                return 'bg-red-500/10 text-red-400 border-red-500/20'
            default:
                return 'bg-orange-500/10 text-orange-400 border-orange-500/20'
        }
    }

    const handleAddToBank = async (e: React.MouseEvent) => {
        e.preventDefault()
        e.stopPropagation()

        if (isAdding || isInBank) return

        setIsAdding(true)
        try {
            // Call API to link question
            const response = await fetch('/api/questions', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ existing_question_id: question.id }),
            })

            if (!response.ok) throw new Error('Failed to add question')

            setIsInBank(true)
            toast.success('Added to your bank!')
            onAddToBank?.(question.id)
        } catch (error) {
            toast.error('Failed to add question')
            console.error(error)
        } finally {
            setIsAdding(false)
        }
    }

    return (
        <Card className="w-full bg-gradient-to-br from-stone-900/90 to-neutral-950/90 border border-stone-800/80 hover:border-orange-500/50 transition-all duration-500 backdrop-blur-md shadow-[0_8px_32px_rgba(0,0,0,0.4)] hover:shadow-[0_8px_48px_rgba(249,115,22,0.15)] group relative overflow-hidden">
            <div className="absolute inset-0 bg-gradient-to-br from-orange-500/5 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500" />

            <CardContent className="p-5 relative z-10">
                <div className="space-y-4">
                    {/* Header: Uploader + Badges */}
                    <div className="flex items-center justify-between gap-3">
                        <Link
                            href={`/u/${question.uploader.username || question.uploader.user_id}`}
                            className="flex items-center gap-2.5 group/uploader"
                            onClick={(e) => e.stopPropagation()}
                        >
                            <Avatar className="h-8 w-8 ring-2 ring-stone-800 group-hover/uploader:ring-orange-500/50 transition-all">
                                <AvatarImage src={question.uploader.avatar_url || undefined} />
                                <AvatarFallback className="bg-stone-800 text-stone-300 text-xs">
                                    {question.uploader.display_name?.[0]?.toUpperCase() || question.uploader.username?.[0]?.toUpperCase() || 'U'}
                                </AvatarFallback>
                            </Avatar>
                            <div className="flex flex-col">
                                <span className="text-sm font-medium text-stone-200 group-hover/uploader:text-orange-400 transition-colors">
                                    {question.uploader.display_name || question.uploader.username || 'Anonymous'}
                                </span>
                                <span className="text-[10px] text-stone-500">
                                    @{question.uploader.username || 'user'}
                                </span>
                            </div>
                        </Link>

                        <div className="flex items-center gap-2">
                            {question.due_for_review && (
                                <Badge
                                    variant="outline"
                                    className="bg-purple-500/10 text-purple-400 border-purple-500/20 font-medium text-[10px] px-2 py-0.5 rounded-full flex items-center gap-1"
                                >
                                    <RefreshCw className="h-3 w-3" />
                                    Review
                                </Badge>
                            )}
                            <Badge
                                variant="outline"
                                className="bg-stone-900/90 text-stone-100 border-stone-700/70 font-medium text-[10px] px-2 py-0.5 rounded-full shadow-lg shadow-black/20"
                            >
                                {question.subject}
                            </Badge>
                            <Badge
                                variant="outline"
                                className={`font-medium text-[10px] px-2 py-0.5 rounded-full border shadow-lg ${getDifficultyStyles(question.difficulty)}`}
                            >
                                {question.difficulty}
                            </Badge>
                        </div>
                    </div>

                    {/* Question Preview */}
                    <Link href={`/dashboard/questions/${question.id}`} className="block">
                        <div className="text-stone-50 text-[15px] leading-[1.7] font-normal tracking-wide line-clamp-3 prose dark:prose-invert font-charter">
                            <Latex>{question.question_text}</Latex>
                        </div>
                    </Link>

                    {/* Footer: Chapter + Add to Bank */}
                    <div className="pt-3 border-t border-stone-800/80">
                        <div className="flex items-center justify-between gap-3">
                            <div className="flex items-center gap-2 flex-1 min-w-0">
                                <div className="w-1.5 h-1.5 rounded-full bg-orange-500 shadow-lg shadow-orange-500/50 shrink-0" />
                                <div className="flex flex-col min-w-0">
                                    <span className="text-xs font-medium text-stone-300 truncate">
                                        {question.chapter}
                                    </span>
                                    {question.topics && question.topics.length > 0 && (
                                        <span className="text-[10px] text-stone-500 truncate">
                                            {question.topics.slice(0, 2).join(', ')}
                                        </span>
                                    )}
                                </div>
                            </div>

                            <div className="flex items-center gap-2 shrink-0">
                                {/* Time/Solutions */}
                                <div className="flex items-center gap-1 text-[10px] text-stone-500">
                                    <MessageSquare className="w-3 h-3" />
                                    <span>{question.solutions_count} solutions</span>
                                </div>

                                {/* Add to Bank Button */}
                                {!isInBank && (
                                    <Button
                                        size="sm"
                                        variant="outline"
                                        onClick={handleAddToBank}
                                        disabled={isAdding}
                                        className="h-8 px-3 text-xs font-medium transition-all duration-300 border-stone-700 hover:border-orange-500/50 hover:text-orange-400"
                                    >
                                        {isAdding ? (
                                            <RefreshCw className="h-3.5 w-3.5 animate-spin" />
                                        ) : (
                                            <>
                                                <Plus className="h-3.5 w-3.5 mr-1" />
                                                Add to Bank
                                            </>
                                        )}
                                    </Button>
                                )}

                                {/* View Arrow */}
                                <Link href={`/dashboard/questions/${question.id}`}>
                                    <button className="p-2 text-orange-500 bg-orange-500/10 hover:bg-orange-500/20 hover:text-orange-400 rounded-lg transition-all duration-300 group/arrow border border-orange-500/20 hover:border-orange-500/30">
                                        <ArrowRight className="w-4 h-4 group-hover/arrow:translate-x-0.5 transition-transform" />
                                    </button>
                                </Link>
                            </div>
                        </div>
                    </div>
                </div>
            </CardContent>
        </Card>
    )
})
