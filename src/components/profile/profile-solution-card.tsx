'use client'

import { useState } from 'react'
import { Card, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Latex } from '@/components/ui/latex'
import { Sparkles, ArrowRight, ThumbsUp, Clock } from 'lucide-react'
import { format } from 'date-fns'
import Link from 'next/link'
import { cn } from '@/lib/utils'

interface ProfileSolutionCardProps {
  solution: any
  currentUserId: string | null
}

export function ProfileSolutionCard({ solution, currentUserId }: ProfileSolutionCardProps) {
  if (!solution.question) return null

  return (
    <Link href={`/question/${solution.question.id}`} className="block group">
      <Card className="border-border/60 bg-muted/20 hover:bg-muted/40 hover:border-primary/40 hover:shadow-md transition-all duration-300 overflow-hidden">
        <CardContent className="p-5">
          <div className="flex items-start gap-4">
            <div className="flex-1 space-y-4 min-w-0">
              <div className="flex items-center justify-between gap-2">
                <div className="flex items-center gap-2 min-w-0">
                  <Badge variant="outline" className="text-[10px] font-bold shrink-0">
                    {solution.question.subject}
                  </Badge>
                  <span className="font-bold text-sm truncate text-foreground/80 group-hover:text-primary transition-colors">
                     {solution.question.chapter}
                  </span>
                </div>
                
                <div className="flex items-center gap-2 shrink-0">
                  <div className="flex items-center gap-1 text-[10px] font-bold text-muted-foreground bg-muted/50 px-2 py-1 rounded-full">
                    <ThumbsUp className="h-3 w-3" />
                    <span>{solution.likes || 0}</span>
                  </div>
                  <div className="hidden sm:flex items-center gap-1 text-[10px] text-muted-foreground/60 font-medium">
                    <Clock className="h-3 w-3" />
                    <span>{format(new Date(solution.created_at), 'MMM d')}</span>
                  </div>
                </div>
              </div>

              {solution.approach_description && (
                <div className="relative group/approach">
                  <div className="absolute -left-3 top-0 bottom-0 w-1 bg-primary/50 rounded-full" />
                  <div className="pl-3 space-y-1">
                    <div className="flex items-center gap-1.5 text-[9px] font-black uppercase tracking-[0.15em] text-primary/80">
                      <Sparkles className="h-3 w-3" />
                      Approach
                    </div>
                    <div className="text-xs text-muted-foreground line-clamp-1 font-medium">
                      <Latex>{solution.approach_description}</Latex>
                    </div>
                  </div>
                </div>
              )}

              <div className="flex items-end justify-between gap-4">
                <div className="text-[13px] text-muted-foreground line-clamp-2 flex-1 relative h-10 overflow-hidden leading-relaxed font-medium">
                   <Latex>{solution.solution_text}</Latex>
                   <div className="absolute inset-x-0 bottom-0 h-6 bg-gradient-to-t from-muted/20 to-transparent" />
                </div>
                
                <Button 
                  variant="ghost" 
                  size="sm" 
                  className="h-8 px-3 text-[11px] font-bold uppercase tracking-widest gap-2 shrink-0 text-primary hover:text-primary hover:bg-primary/10"
                >
                  View
                  <ArrowRight className="h-3.5 w-3.5 group-hover:translate-x-0.5 transition-transform" />
                </Button>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>
    </Link>
  )
}
