'use client'

import { motion } from 'framer-motion'
import { SearchedUser, SearchedQuestion } from '@/lib/types'
import { UserSuggestionCard, QuestionFeedCard } from '@/components/feed'
import { Separator } from '@/components/ui/separator'
import { Sparkles, Users, SearchX } from 'lucide-react'

interface SearchResultsProps {
    users: SearchedUser[]
    questions: SearchedQuestion[]
    isLoading?: boolean
}

export function SearchResults({ users, questions, isLoading }: SearchResultsProps) {
    if (!isLoading && users.length === 0 && questions.length === 0) {
        return (
            <div className="flex flex-col items-center justify-center py-20 text-center space-y-4">
                <div className="w-16 h-16 rounded-full bg-muted/30 flex items-center justify-center">
                    <SearchX className="w-8 h-8 text-muted-foreground" />
                </div>
                <div className="space-y-1">
                    <h3 className="text-lg font-medium text-foreground">No matches found</h3>
                    <p className="text-sm text-muted-foreground">Try adjusting your search terms</p>
                </div>
            </div>
        )
    }

    return (
        <div className="space-y-8 pb-20">
            {/* Users Section */}
            {users.length > 0 && (
                <motion.div
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    className="space-y-4"
                >
                    <div className="flex items-center gap-2 px-1">
                        <Users className="w-4 h-4 text-primary" />
                        <h3 className="text-sm font-medium text-foreground/80">People</h3>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                        {users.map((user, index) => {
                            const isLastAndOdd = users.length % 2 !== 0 && index === users.length - 1;
                            return (
                                <div
                                    key={user.user_id}
                                    className={`w-full ${isLastAndOdd ? 'md:col-span-2' : ''}`}
                                >
                                    <UserSuggestionCard user={user} />
                                </div>
                            )
                        })}
                    </div>
                </motion.div>
            )}

            {/* Aesthetic Separator */}
            {users.length > 0 && questions.length > 0 && (
                <div className="relative py-4">
                    <div className="absolute inset-0 flex items-center">
                        <span className="w-full border-t border-border/40" />
                    </div>
                    <div className="relative flex justify-center text-xs uppercase">
                        <span className="bg-background px-4 text-muted-foreground font-medium tracking-widest flex items-center gap-2">
                            <Sparkles className="w-3 h-3 text-orange-500" />
                            Results from Community
                        </span>
                    </div>
                </div>
            )}

            {/* Questions Section */}
            {questions.length > 0 && (
                <motion.div
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: 0.1 }}
                    className="space-y-4"
                >
                    <div className="flex items-center justify-between px-1">
                        <h3 className="text-sm font-medium text-foreground/80">Questions</h3>
                        <span className="text-xs text-muted-foreground">{questions.length} results</span>
                    </div>

                    <div className="space-y-6">
                        {questions.map((question) => (
                            <QuestionFeedCard
                                key={question.id}
                                question={question}
                            />
                        ))}
                    </div>
                </motion.div>
            )}
        </div>
    )
}
