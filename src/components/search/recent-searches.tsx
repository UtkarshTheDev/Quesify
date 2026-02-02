'use client'

import { Clock, X } from 'lucide-react'
import { useEffect, useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { cn } from '@/lib/utils'

interface RecentSearchesProps {
    onSelect: (term: string) => void
    className?: string
}

const STORAGE_KEY = 'quesify-recent-searches'
const MAX_ITEMS = 5

export function RecentSearches({ onSelect, className }: RecentSearchesProps) {
    const [searches, setSearches] = useState<string[]>([])

    useEffect(() => {
        try {
            const stored = localStorage.getItem(STORAGE_KEY)
            if (stored) {
                setSearches(JSON.parse(stored))
            }
        } catch (e) {
            console.error('Failed to load recent searches', e)
        }
    }, [])

    const removeSearch = (term: string, e: React.MouseEvent) => {
        e.stopPropagation()
        const newSearches = searches.filter(s => s !== term)
        setSearches(newSearches)
        localStorage.setItem(STORAGE_KEY, JSON.stringify(newSearches))
    }

    // Helper to add search (exported for use in parent)
    // Note: We can't export functions from component directly, 
    // so the parent page will handle adding, but this component handles display/delete.

    if (searches.length === 0) return null

    return (
        <div className={cn("space-y-4", className)}>
            <h3 className="text-sm font-medium text-muted-foreground ml-1">Recent Searches</h3>
            <div className="flex flex-wrap gap-2">
                <AnimatePresence>
                    {searches.map((term) => (
                        <motion.div
                            key={term}
                            initial={{ opacity: 0, scale: 0.9 }}
                            animate={{ opacity: 1, scale: 1 }}
                            exit={{ opacity: 0, scale: 0.9 }}
                            transition={{ duration: 0.2 }}
                        >
                            <button
                                onClick={() => onSelect(term)}
                                className="group flex items-center gap-2 px-4 py-2 bg-muted/50 hover:bg-muted text-sm rounded-full transition-colors border border-transparent hover:border-border"
                            >
                                <Clock className="w-3.5 h-3.5 text-muted-foreground group-hover:text-primary transition-colors" />
                                <span className="text-foreground/80 group-hover:text-foreground">{term}</span>
                                <div
                                    role="button"
                                    tabIndex={0}
                                    onClick={(e) => removeSearch(term, e)}
                                    className="ml-1 p-0.5 rounded-full hover:bg-background/80 text-muted-foreground hover:text-destructive transition-colors"
                                >
                                    <X className="w-3 h-3" />
                                </div>
                            </button>
                        </motion.div>
                    ))}
                </AnimatePresence>
            </div>
        </div>
    )
}

// Utility to save a new search term
export function saveRecentSearch(term: string) {
    if (!term.trim()) return
    try {
        const stored = localStorage.getItem(STORAGE_KEY)
        let searches: string[] = stored ? JSON.parse(stored) : []

        // Remove duplicates and move to front
        searches = searches.filter(s => s.toLowerCase() !== term.toLowerCase())
        searches.unshift(term)

        // Limit size
        searches = searches.slice(0, MAX_ITEMS)

        localStorage.setItem(STORAGE_KEY, JSON.stringify(searches))
    } catch (e) {
        console.error('Failed to save search', e)
    }
}
