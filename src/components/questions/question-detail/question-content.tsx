/* eslint-disable @next/next/no-img-element */
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Latex } from '@/components/ui/latex'
import { Trash2 } from 'lucide-react'
import type { Question } from '@/lib/types'

import { cn } from '@/lib/utils'

interface QuestionContentProps {
  question: Question
  userId: string | null
  setShowDeleteDialog: (show: boolean) => void
  revealed?: boolean
  correctOption?: number | null
  fetchSharingStats?: () => Promise<{ count: number }>
  sharingStats?: { count: number } | null
}

const difficultyColors = {
  easy: 'bg-green-500/10 text-green-500 hover:bg-green-500/20',
  medium: 'bg-yellow-500/10 text-yellow-500 hover:bg-yellow-500/20',
  hard: 'bg-orange-500/10 text-orange-500 hover:bg-orange-500/20',
  very_hard: 'bg-red-500/10 text-red-500 hover:bg-red-500/20',
}

export function QuestionContent({ question, userId, setShowDeleteDialog, revealed, correctOption, fetchSharingStats, sharingStats }: QuestionContentProps) {
  return (
    <Card>
      <CardHeader>
        <div className="flex items-start justify-between">
          <div className="space-y-1">
            <div className="flex items-center gap-2">
              <Badge variant="outline">{question.subject}</Badge>
              <Badge variant="secondary" className={difficultyColors[question.difficulty]}>
                {question.difficulty}
              </Badge>
            </div>
            <CardTitle className="text-xl pt-2">
              {question.chapter}
            </CardTitle>
          </div>

          {userId && (
            <Button
              variant="ghost"
              size="icon"
              className="text-muted-foreground hover:text-destructive transition-colors shrink-0"
              onClick={async () => {
                if (fetchSharingStats) {
                  await fetchSharingStats();
                }
                setShowDeleteDialog(true);
              }}

            >
              <Trash2 className="h-4 w-4" />
            </Button>
          )}
        </div>
      </CardHeader>
      <CardContent className="space-y-6">
        <div className="prose dark:prose-invert max-w-none font-charter">
          <Latex>{question.question_text}</Latex>
        </div>

        {question.options && question.options.length > 0 && (
          <div className="space-y-2 pt-2">
            <p className="font-medium text-sm text-muted-foreground">Options:</p>
            <div className="grid gap-2">
              {question.options.map((option, idx) => {
                const isCorrect = revealed && idx === correctOption
                return (
                  <div 
                    key={idx} 
                    className={cn(
                      "p-3 rounded-md transition-all duration-500 flex gap-3 border",
                      isCorrect 
                        ? "bg-green-500/10 border-green-500/50 shadow-[0_0_15px_rgba(34,197,94,0.1)] scale-[1.02]" 
                        : "bg-muted/50 border-transparent"
                    )}
                  >
                    <span className={cn(
                      "font-mono text-sm",
                      isCorrect ? "text-green-500 font-bold" : "text-muted-foreground"
                    )}>
                      {String.fromCharCode(65 + idx)}.
                    </span>
                    <div className={cn(
                      "flex-1 font-charter",
                      isCorrect ? "text-green-600 dark:text-green-400 font-medium" : ""
                    )}>
                      <Latex>{option}</Latex>
                    </div>
                  </div>
                )
              })}
            </div>
          </div>
        )}

        {question.image_url && (
          <div className="mt-4 rounded-lg overflow-hidden border">
            <img
              src={question.image_url}
              alt="Question diagram"
              className="w-full h-auto max-h-[400px] object-contain bg-black/5 dark:bg-white/5"
            />
          </div>
        )}
      </CardContent>
    </Card>
  )
}
