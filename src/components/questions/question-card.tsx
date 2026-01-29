'use client'

import Link from 'next/link'
import { formatDistanceToNow } from 'date-fns'
import { CheckCircle2, XCircle, Clock, ArrowRight } from 'lucide-react'
import { Card, CardContent } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Latex } from '@/components/ui/latex'
import type { Question, UserQuestionStats } from '@/lib/types'

interface QuestionCardProps {
  question: Question & {
    user_question_stats?: UserQuestionStats[]
  }
}

export function QuestionCard({ question }: QuestionCardProps) {
  const stats = question.user_question_stats?.[0] || null

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

  return (
    <Link href={`/dashboard/questions/${question.id}`}>
      <Card className="w-full bg-gradient-to-br from-stone-900/90 to-neutral-950/90 border border-stone-800/80 hover:border-orange-500/50 transition-all duration-500 backdrop-blur-md shadow-[0_8px_32px_rgba(0,0,0,0.4)] hover:shadow-[0_8px_48px_rgba(249,115,22,0.15)] group relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-br from-orange-500/5 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500" />
        <CardContent className="p-6 relative z-10">
          <div className="space-y-5">
            {/* Header */}
            <div className="flex items-center justify-between gap-3">
              <div className="flex items-center gap-2">
                <Badge
                  variant="outline"
                  className="bg-stone-900/90 text-stone-100 border-stone-700/70 font-medium text-[11px] px-3 py-1 rounded-full shadow-lg shadow-black/20"
                >
                  {question.subject}
                </Badge>
                <Badge
                  variant="outline"
                  className={`font-medium text-[11px] px-3 py-1 rounded-full border shadow-lg ${getDifficultyStyles(question.difficulty)}`}
                >
                  {question.difficulty}
                </Badge>
                {question.type === 'MCQ' && (
                  <Badge variant="outline" className="bg-blue-500/10 text-blue-400 border-blue-500/20 font-medium text-[11px] px-3 py-1 rounded-full border shadow-lg">
                    MCQ
                  </Badge>
                )}
              </div>
              <div className="flex items-center gap-2 text-[11px] text-stone-500">
                {stats?.solved && (
                  <CheckCircle2 className="h-3 w-3 text-emerald-500" />
                )}
                {stats?.failed && (
                  <XCircle className="h-3 w-3 text-red-500" />
                )}
                <div className="flex items-center gap-1.5">
                  <Clock className="w-3 h-3" />
                  <span>{formatDistanceToNow(new Date(question.created_at), { addSuffix: true })}</span>
                </div>
              </div>
            </div>

            {/* Question */}
            <div className="space-y-6">
              <div className="text-stone-50 text-base leading-[1.75] font-normal tracking-wide drop-shadow-sm line-clamp-2 prose dark:prose-invert font-charter">
                <Latex>{question.question_text}</Latex>
              </div>

              {/* Topic section */}
              <div className="pt-4 border-t border-stone-800/80">
                <div className="flex items-center justify-between gap-3">
                  <div className="flex items-start gap-2.5">
                    <div className="w-1.5 h-1.5 rounded-full bg-orange-500 shadow-lg shadow-orange-500/50 mt-2 shrink-0" />
                    <div className="flex flex-col gap-1">
                      <span className="text-sm font-medium text-stone-300">{question.chapter}</span>
                      <span className="text-xs text-stone-500 leading-relaxed line-clamp-1">
                        {question.topics.slice(0, 3).join(', ')}
                      </span>
                    </div>
                  </div>
                  <button className="shrink-0 p-2.5 -mr-2 text-orange-500 bg-orange-500/10 hover:bg-orange-500/20 hover:text-orange-400 rounded-lg transition-all duration-300 group/arrow border border-orange-500/20 hover:border-orange-500/30">
                    <ArrowRight className="w-4 h-4 group-hover/arrow:translate-x-0.5 transition-transform" />
                  </button>
                </div>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>
    </Link>
  )
}
