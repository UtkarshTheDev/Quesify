'use client'

import { useState, useEffect } from 'react'
import { format } from 'date-fns'
import { Clock, ThumbsUp, ChevronRight } from 'lucide-react'
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
    <div className="space-y-3 animate-in fade-in slide-in-from-bottom-2 duration-500">
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
        "group cursor-pointer transition-all duration-300 border shadow-sm hover:shadow-md hover:border-primary/40",
        isActive 
          ? "border-primary ring-1 ring-primary/20 bg-primary/[0.03] shadow-md" 
          : "bg-card/50 hover:bg-card"
      )}
      onClick={onSelect}
    >
      <CardContent className="p-4">
        <div className="flex items-start gap-4">
          <Avatar className="h-10 w-10 border shadow-sm">
            <AvatarImage src={solution.author?.avatar_url || ''} />
            <AvatarFallback>{solution.author?.display_name?.charAt(0) || 'U'}</AvatarFallback>
          </Avatar>
          
          <div className="flex-1 space-y-3 min-w-0">
            <div className="flex items-center justify-between gap-2">
              <div className="flex items-center gap-2">
                <span className="font-semibold text-sm truncate max-w-[120px]">
                  {solution.author?.display_name || 'Contributor'}
                </span>
                <Badge variant={solution.is_ai_best ? "default" : "secondary"} className="text-[10px] h-4 px-1">
                  {solution.is_ai_best ? 'AI Best' : 'Contributor'}
                </Badge>
              </div>
              <div className="flex items-center gap-3 text-muted-foreground">
                <Button
                  variant="ghost"
                  size="sm"
                  className={cn(
                    "h-6 px-1.5 gap-1 text-[10px] hover:bg-primary/10",
                    liked ? "text-primary" : "text-muted-foreground"
                  )}
                  onClick={handleLike}
                >
                  <ThumbsUp className={cn("h-3 w-3", liked && "fill-current")} />
                  <span>{likesCount}</span>
                </Button>
                <div className="flex items-center gap-1 text-[10px]">
                  <Clock className="h-3 w-3" />
                  <span>{format(new Date(solution.created_at), 'MMM d, yyyy')}</span>
                </div>
              </div>
            </div>
            
            {solution.approach_description && (
              <div className="text-xs text-muted-foreground border-l-2 border-primary/30 pl-3 bg-primary/5 py-3 rounded-r-md leading-7 shadow-sm">
                <span className="font-bold text-primary/90 not-italic mr-1.5 uppercase tracking-wide text-[10px]">Approach:</span>
                <Latex>{solution.approach_description}</Latex>
              </div>
            )}
            
            <div className="flex items-center justify-between pt-2">
              <div className="text-xs text-muted-foreground line-clamp-2 flex-1 mr-4 h-10 overflow-hidden relative">
                <Latex>{solution.solution_text}</Latex>
                <div className="absolute inset-0 bg-gradient-to-t from-card via-transparent to-transparent" />
              </div>
              <Button variant="ghost" size="sm" className="h-7 px-2 text-xs gap-1 group-hover:text-primary whitespace-nowrap shrink-0">
                View <ChevronRight className="h-3 w-3 transition-transform group-hover:translate-x-0.5" />
              </Button>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  )
}
