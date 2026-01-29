'use client'

import Link from 'next/link'
import { formatDistanceToNow } from 'date-fns'
import { CheckCircle2, XCircle, Clock, ChevronRight } from 'lucide-react'
import { Card, CardContent, CardHeader } from '@/components/ui/card'
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

  const difficultyColors = {
    easy: 'bg-green-500/10 text-green-500 hover:bg-green-500/20',
    medium: 'bg-yellow-500/10 text-yellow-500 hover:bg-yellow-500/20',
    hard: 'bg-orange-500/10 text-orange-500 hover:bg-orange-500/20',
    very_hard: 'bg-red-500/10 text-red-500 hover:bg-red-500/20',
  }

  return (
    <Link href={`/dashboard/questions/${question.id}`}>
      <Card className="hover:bg-muted/50 transition-colors cursor-pointer group">
        <CardHeader className="p-4 pb-2">
          <div className="flex items-start justify-between">
            <div className="flex items-center gap-2">
              <Badge variant="outline" className="text-xs font-normal">
                {question.subject}
              </Badge>
              <Badge
                variant="secondary"
                className={`text-xs font-normal ${difficultyColors[question.difficulty]}`}
              >
                {question.difficulty}
              </Badge>
              {question.type === 'MCQ' && (
                <Badge variant="secondary" className="text-xs font-normal text-muted-foreground">
                  MCQ
                </Badge>
              )}
            </div>

            <div className="flex items-center gap-2 text-xs text-muted-foreground">
              {stats?.solved && (
                <CheckCircle2 className="h-4 w-4 text-green-500" />
              )}
              {stats?.failed && (
                <XCircle className="h-4 w-4 text-red-500" />
              )}
              <span className="flex items-center gap-1">
                <Clock className="h-3 w-3" />
                {formatDistanceToNow(new Date(question.created_at), { addSuffix: true })}
              </span>
            </div>
          </div>
        </CardHeader>
        <CardContent className="p-4 pt-2 space-y-3">
          <div className="text-sm font-medium line-clamp-2 prose dark:prose-invert font-charter">
            <Latex>{question.question_text}</Latex>
          </div>

          <div className="flex items-center justify-between text-xs text-muted-foreground">
            <div className="flex items-center gap-2">
              <span className="font-medium text-foreground">{question.chapter}</span>
              <span>•</span>
              <span className="line-clamp-1">{question.topics.slice(0, 2).join(', ')}</span>
            </div>

            <ChevronRight className="h-4 w-4 opacity-0 group-hover:opacity-100 transition-opacity" />
          </div>
        </CardContent>
      </Card>
    </Link>
  )
}
