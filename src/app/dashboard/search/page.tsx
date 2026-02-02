'use client'

import { useState, useEffect } from 'react'
import { Search, Loader2, ArrowLeft, Sparkles, Users } from 'lucide-react'
import { UserSuggestionCard } from '@/components/feed/user-suggestion-card'
import { useRouter } from 'next/navigation'
import useSWR from 'swr'
import { motion, AnimatePresence } from 'framer-motion'

import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { RecentSearches, saveRecentSearch } from '@/components/search/recent-searches'
import { SearchResults } from '@/components/search/search-results'
import { QuestionFeedCard } from '@/components/feed/question-feed-card'
import { useDebounce } from '@/hooks/use-debounce'
import { SearchResponse } from '@/lib/types'

const fetcher = (url: string) => fetch(url).then((res) => res.json())

export default function SearchPage() {
    const router = useRouter()
    const [searchTerm, setSearchTerm] = useState('')
    const debouncedTerm = useDebounce(searchTerm, 500)

    // Determine if we are in "User Search Mode" (@ prefix)
    const isUserMode = searchTerm.trim().startsWith('@')

    // Fetch data (always fetch, API handles empty query by returning suggestions)
    const { data, isLoading } = useSWR<SearchResponse>(
        `/api/search?q=${encodeURIComponent(debouncedTerm)}`,
        fetcher,
        {
            keepPreviousData: true,
            revalidateOnFocus: false
        }
    )

    // Save to recent searches on valid result
    useEffect(() => {
        if (data && debouncedTerm.trim().length > 2 && !isLoading) {
            // Only save if we have results or it was a deliberate long query
            if ((data.users?.length > 0 || data.questions?.length > 0)) {
                saveRecentSearch(debouncedTerm)
            }
        }
    }, [data, debouncedTerm, isLoading])


    return (
        <div className="container max-w-2xl mx-auto px-4 py-6 min-h-screen">
            {/* Header / Input Area */}
            <div className="sticky top-0 bg-background/80 backdrop-blur-md z-20 pb-4 mb-2 -mx-4 px-4 pt-2">
                <div className="relative group">
                    <div className="absolute inset-y-0 left-3 flex items-center pointer-events-none">
                        {isLoading ? (
                            <Loader2 className="w-5 h-5 text-muted-foreground animate-spin" />
                        ) : (
                            <Search className={`w-5 h-5 transition-colors duration-300 ${isUserMode ? 'text-blue-400' : 'text-muted-foreground group-focus-within:text-foreground'}`} />
                        )}
                    </div>

                    <Input
                        autoFocus
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        placeholder="Search questions, topics, or @users..."
                        className="pl-10 h-12 text-lg bg-muted/40 border-transparent hover:bg-muted/60 focus:bg-background focus:border-border transition-all shadow-sm rounded-xl"
                    />

                    {/* Mode Indicator */}
                    <AnimatePresence>
                        {isUserMode && (
                            <motion.div
                                initial={{ opacity: 0, scale: 0.8 }}
                                animate={{ opacity: 1, scale: 1 }}
                                exit={{ opacity: 0, scale: 0.8 }}
                                className="absolute inset-y-0 right-3 flex items-center"
                            >
                                <span className="text-[10px] font-medium bg-blue-500/10 text-blue-400 px-2 py-0.5 rounded-full border border-blue-500/20">
                                    USER SEARCH
                                </span>
                            </motion.div>
                        )}
                    </AnimatePresence>
                </div>
            </div>

            {/* Content Area */}
            <div className="min-h-[50vh]">
                {!debouncedTerm ? (
                    <motion.div
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        className="mt-8 space-y-10"
                    >
                        <RecentSearches onSelect={(term) => setSearchTerm(term)} />

                        {/* Suggested People */}
                        {data?.users && data.users.length > 0 && (
                            <div className="space-y-4">
                                <div className="flex items-center gap-2 px-1">
                                    <Users className="w-4 h-4 text-blue-400" />
                                    <h3 className="text-sm font-medium text-foreground/80">People you may know</h3>
                                </div>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    {data.users.map((user, index) => {
                                        const isLastAndOdd = data.users.length % 2 !== 0 && index === data.users.length - 1;
                                        return (
                                            <div key={user.user_id} className={`${isLastAndOdd ? 'md:col-span-2' : ''}`}>
                                                <UserSuggestionCard user={user} />
                                            </div>
                                        )
                                    })}
                                </div>
                            </div>
                        )}

                        {/* Explore Suggestions */}
                        {data?.questions && data.questions.length > 0 && (
                            <div className="space-y-4">
                                <div className="flex items-center gap-2 px-1">
                                    <Sparkles className="w-4 h-4 text-orange-500" />
                                    <h3 className="text-sm font-medium text-foreground/80">Explore Community</h3>
                                </div>
                                <div className="space-y-6">
                                    {data.questions.map((question) => (
                                        <QuestionFeedCard
                                            key={question.id}
                                            question={question}
                                        />
                                    ))}
                                </div>
                            </div>
                        )}
                    </motion.div>
                ) : (
                    <SearchResults
                        users={data?.users || []}
                        questions={data?.questions || []}
                        isLoading={isLoading}
                    />
                )}
            </div>
        </div>
    )
}
