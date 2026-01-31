'use client'

import { useState, useEffect } from 'react'
import { format } from 'date-fns'
import { Clock, ThumbsUp, ChevronRight, Sparkles, Timer, User } from 'lucide-react'
import { Card, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Latex } from '@/components/ui/latex'
import type { Solution } from '@/lib/types'
import { cn, formatDuration } from '@/lib/utils'
import { toast } from 'sonner'

import Link from 'next/link'

interface SolutionCardListProps {
  solutions: (Solution & { author?: { display_name: string | null; avatar_url: string | null; username?: string | null } })[]
  onSelect: (solutionId: string) => void
  activeSolutionId?: string | null
  currentUserId: string | null
}

export function SolutionCardList({ solutions, onSelect, activeSolutionId, currentUserId }: SolutionCardListProps) {
  return (
    <div className="grid grid-cols-1 gap-4 animate-in fade-in slide-in-from-bottom-2 duration-500">
      {solutions.map((solution) => (
        <SolutionListItem
          key={solution.id}
          solution={solution}
          isActive={activeSolutionId === solution.id}
          onSelect={() => onSelect(solution.id)}
          currentUserId={currentUserId}
        />
      ))}
    </div>
  )
}

interface SolutionListItemProps {
  solution: Solution & { author?: { display_name: string | null; avatar_url: string | null; username?: string | null } }
  isActive: boolean
  onSelect: () => void
  currentUserId: string | null
}

function SolutionListItem({ solution, isActive, onSelect, currentUserId }: SolutionListItemProps) {
  const [isLiking, setIsLiking] = useState(false)
  const [liked, setLiked] = useState(false)
  const [likesCount, setLikesCount] = useState(solution.likes || 0)

  useEffect(() => {
    setLikesCount(solution.likes || 0)
  }, [solution.likes])

  useEffect(() => {
    if (currentUserId) {
      fetch(`/api/solutions/${solution.id}/like`)
        .then(res => res.json())
        .then(data => setLiked(data.liked))
        .catch(() => {})
    }
  }, [solution.id, currentUserId])

  const handleLike = async (e: React.MouseEvent) => {
    e.stopPropagation() // Prevent card selection when clicking like
    
    if (!currentUserId) {
      toast.error('Please login to like solutions')
      return
    }
    
    if (isLiking) return

    // Optimistic update
    const prevLiked = liked
    const prevLikes = likesCount
    setLiked(!prevLiked)
    setLikesCount(prev => !prevLiked ? prev + 1 : prev - 1)
    setIsLiking(true)

    try {
      const response = await fetch(`/api/solutions/${solution.id}/like`, {
        method: 'POST',
      })
      const data = await response.json()
      if (data.success) {
        setLiked(data.liked)
        setLikesCount(data.likes)
      } else {
        throw new Error('Failed')
      }
    } catch {
      // Revert
      setLiked(prevLiked)
      setLikesCount(prevLikes)
      toast.error('Failed to update like')
    } finally {
      setIsLiking(false)
    }
  }

  // Helper to get display name and avatar fallback
  const displayName = solution.author?.display_name || solution.author?.username || 'Contributor'
  const username = solution.author?.username
  const avatarFallback = displayName.charAt(0).toUpperCase()
  const profileUrl = username ? `/u/${username}` : '#'

  return (
    <Card 
      className={cn(
        "group cursor-pointer transition-all duration-300 overflow-hidden relative",
        // Base styles for the card - darker, subtle border
        "bg-card/40 border border-border/60 hover:border-orange-500/30 hover:shadow-[0_0_20px_-5px_rgba(249,115,22,0.1)]",
        isActive 
          ? "border-orange-500/50 bg-orange-500/[0.03] shadow-md shadow-orange-500/5 ring-1 ring-orange-500/20" 
          : "hover:bg-card/60"
      )}
      onClick={onSelect}
    >
      {/* Active Indicator Strip */}
      {isActive && (
        <div className="absolute left-0 top-0 bottom-0 w-1 bg-orange-500" />
      )}

      <CardContent className="p-5">
        <div className="flex items-start gap-4">
          {/* Avatar Section */}
          <Link href={profileUrl} onClick={(e) => !username && e.preventDefault()} className={cn("shrink-0", !username && "cursor-default")}>
            <Avatar className="h-10 w-10 border border-border shadow-sm ring-2 ring-transparent group-hover:ring-orange-500/20 transition-all">
                <AvatarImage src={solution.author?.avatar_url || ''} />
                <AvatarFallback className="bg-orange-500/10 text-orange-600 text-xs font-bold">
                  {avatarFallback}
                </AvatarFallback>
            </Avatar>
          </Link>
          
          <div className="flex-1 space-y-4 min-w-0">
            {/* Header: Author & Stats */}
            <div className="flex items-center justify-between gap-2">
              <div className="flex items-center gap-2 min-w-0">
                <div className="flex flex-col gap-0.5 min-w-0">
                  <div className="flex items-center gap-2">
                    <Link 
                      href={profileUrl} 
                      onClick={(e) => {
                        e.stopPropagation()
                        if (!username) e.preventDefault()
                      }} 
                      className={cn(
                        "font-bold text-sm truncate transition-colors",
                        username ? "hover:text-orange-500 hover:underline decoration-orange-500/30" : "cursor-default"
                      )}
                    >
                      {displayName}
                    </Link>
                    {solution.is_ai_best && (
                      <Badge variant="default" className="text-[9px] uppercase tracking-tighter h-4 px-1.5 font-black bg-orange-500 hover:bg-orange-600 border-orange-600/20">
                        AI Best
                      </Badge>
                    )}
                  </div>
                  {username && (
                    <span className="text-[10px] text-muted-foreground font-medium truncate">@{username}</span>
                  )}
                </div>
              </div>

              <div className="flex items-center gap-2 shrink-0">
                <Button
                  variant="ghost"
                  size="sm"
                  className={cn(
                    "h-7 px-2 gap-1.5 text-[10px] font-bold rounded-full transition-colors border",
                    liked 
                      ? "bg-orange-500/10 text-orange-600 border-orange-500/20 hover:bg-orange-500/20" 
                      : "bg-background/50 border-border/50 text-muted-foreground hover:bg-muted hover:text-foreground"
                  )}
                  onClick={handleLike}
                >
                  <ThumbsUp className={cn("h-3.5 w-3.5", liked && "fill-current")} />
                  <span>{likesCount}</span>
                </Button>
                
                <div className="hidden sm:flex items-center gap-2 text-[10px] text-muted-foreground/60 font-medium">
                  <div className="flex items-center gap-1">
                    <Clock className="h-3 w-3" />
                    <span>{format(new Date(solution.created_at), 'MMM d')}</span>
                  </div>
                  {solution.avg_solve_time > 0 && (
                    <div className="flex items-center gap-1 text-orange-600/70">
                      <Timer className="h-3 w-3" />
                      <span>~{formatDuration(solution.avg_solve_time)}</span>
                    </div>
                  )}
                </div>
              </div>
            </div>
            
            {/* Strategic Approach Section - Highlighted */}
            {solution.approach_description && (
              <div className="relative group/approach mt-2 overflow-hidden rounded-xl border border-orange-500/20 bg-gradient-to-r from-orange-500/5 to-transparent">
                <div className="absolute left-0 top-0 bottom-0 w-1 bg-orange-500/50" />
                <div className="p-3.5 pl-4 space-y-1.5">
                  <div className="flex items-center gap-1.5 text-[9px] font-black uppercase tracking-[0.15em] text-orange-600">
                    <Sparkles className="h-3 w-3" />
                    Strategic Approach
                  </div>
                  <div className="text-[13px] text-foreground/90 leading-relaxed line-clamp-2 font-medium">
                    <Latex>{solution.approach_description}</Latex>
                  </div>
                </div>
              </div>
            )}
            
            {/* Solution Preview */}
            <div className="flex items-end justify-between gap-4 pt-1">
              <div className="text-[13px] text-muted-foreground line-clamp-2 flex-1 relative h-10 overflow-hidden leading-relaxed font-medium">
                <Latex>{solution.solution_text}</Latex>
                {!isActive && <div className="absolute inset-x-0 bottom-0 h-6 bg-gradient-to-t from-background via-background/80 to-transparent" />}
              </div>
              <Button 
                variant="outline" 
                size="sm" 
                className={cn(
                  "h-8 px-4 text-[10px] font-bold uppercase tracking-widest gap-2 rounded-lg shrink-0 transition-all shadow-sm border",
                  isActive 
                    ? "bg-orange-500 text-white border-orange-600 hover:bg-orange-600" 
                    : "bg-background hover:border-orange-500/50 hover:text-orange-600 hover:shadow-md hover:shadow-orange-500/5"
                )}
              >
                {isActive ? 'Current' : 'View'}
                <ChevronRight className={cn("h-3.5 w-3.5 transition-transform", !isActive && "group-hover:translate-x-0.5")} />
              </Button>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  )
}
