'use client'

import { useState, useEffect } from 'react'
import { format } from 'date-fns'
import { Clock, ThumbsUp, ChevronRight, Sparkles } from 'lucide-react'
import { Card, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Latex } from '@/components/ui/latex'
import type { Solution } from '@/lib/types'
import { cn } from '@/lib/utils'
import { toast } from 'sonner'

interface SolutionCardListProps {
  solutions: (Solution & { author?: { display_name: string | null; avatar_url: string | null } })[]
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
  solution: Solution & { author?: { display_name: string | null; avatar_url: string | null } }
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

  return (
    <Card 
      className={cn(
        "group cursor-pointer transition-all duration-300 border-2 overflow-hidden",
        isActive 
          ? "border-primary bg-primary/[0.04] shadow-lg shadow-primary/10 ring-1 ring-primary/20" 
          : "border-border/40 bg-card hover:border-primary/30 hover:bg-accent/20 hover:shadow-md"
      )}
      onClick={onSelect}
    >
      <CardContent className="p-5">
        <div className="flex items-start gap-4">
          <Avatar className="h-10 w-10 border-2 border-background shadow-sm shrink-0">
            <AvatarImage src={solution.author?.avatar_url || ''} />
            <AvatarFallback className="bg-muted text-muted-foreground text-xs font-bold">
              {solution.author?.display_name?.charAt(0) || 'U'}
            </AvatarFallback>
          </Avatar>
          
          <div className="flex-1 space-y-4 min-w-0">
            <div className="flex items-center justify-between gap-2">
              <div className="flex items-center gap-2">
                <span className="font-bold text-sm truncate">
                  {solution.author?.display_name || 'Contributor'}
                </span>
                <Badge variant={solution.is_ai_best ? "default" : "secondary"} className="text-[9px] uppercase tracking-tighter h-4 px-1.5 font-black">
                  {solution.is_ai_best ? 'AI Best' : 'Contributor'}
                </Badge>
              </div>
              <div className="flex items-center gap-2">
                <Button
                  variant="ghost"
                  size="sm"
                  className={cn(
                    "h-7 px-2 gap-1.5 text-[10px] font-bold rounded-full transition-colors",
                    liked ? "bg-primary/10 text-primary hover:bg-primary/20" : "text-muted-foreground hover:bg-muted"
                  )}
                  onClick={handleLike}
                >
                  <ThumbsUp className={cn("h-3.5 w-3.5", liked && "fill-current")} />
                  <span>{likesCount}</span>
                </Button>
                <div className="hidden sm:flex items-center gap-1 text-[10px] text-muted-foreground/60 font-medium">
                  <Clock className="h-3 w-3" />
                  <span>{format(new Date(solution.created_at), 'MMM d')}</span>
                </div>
              </div>
            </div>
            
            {solution.approach_description && (
              <div className="relative group/approach">
                <div className="absolute -left-3 top-0 bottom-0 w-1 bg-primary/40 rounded-full group-hover/approach:bg-primary transition-colors" />
                <div className="bg-primary/[0.03] border border-primary/10 p-3 rounded-r-xl space-y-1">
                  <div className="flex items-center gap-1.5 text-[9px] font-black uppercase tracking-[0.15em] text-primary/70">
                    <Sparkles className="h-3 w-3" />
                    Strategic Approach
                  </div>
                  <div className="text-[13px] text-foreground/80 leading-relaxed line-clamp-2 font-medium italic">
                    <Latex>{solution.approach_description}</Latex>
                  </div>
                </div>
              </div>
            )}
            
            <div className="flex items-end justify-between gap-4">
              <div className="text-[13px] text-muted-foreground/70 line-clamp-2 flex-1 relative h-10 overflow-hidden leading-relaxed">
                <Latex>{solution.solution_text}</Latex>
                {!isActive && <div className="absolute inset-x-0 bottom-0 h-6 bg-gradient-to-t from-card to-transparent" />}
              </div>
              <Button 
                variant="outline" 
                size="sm" 
                className={cn(
                  "h-8 px-3 text-[11px] font-bold uppercase tracking-widest gap-2 rounded-lg shrink-0 transition-all",
                  isActive ? "bg-primary text-primary-foreground border-primary" : "group-hover:border-primary group-hover:text-primary"
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
