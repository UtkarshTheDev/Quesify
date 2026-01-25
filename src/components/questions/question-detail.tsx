'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { format } from 'date-fns'
import { toast } from 'sonner'
import {
  ArrowLeft,
  Calendar,
  Clock,
  BookOpen,
  Hash,
  Share2,
  MoreVertical,
  Edit,
  Trash2,
  CheckCircle2,
  XCircle,
  HelpCircle,
  Loader2
} from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { Separator } from '@/components/ui/separator'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger
} from '@/components/ui/dropdown-menu'
import { Latex } from '@/components/ui/latex'
import type { Question, Solution, UserQuestionStats } from '@/lib/types'

interface QuestionDetailProps {
  question: Question & {
    solutions: Solution[]
    user_question_stats: UserQuestionStats[]
  }
  userId: string
}

export function QuestionDetail({ question, userId }: QuestionDetailProps) {
  const router = useRouter()
  const [activeTab, setActiveTab] = useState('question')
  const [isGenerating, setIsGenerating] = useState(false)

  const handleGenerateSolution = async () => {
    setIsGenerating(true)
    try {
      const response = await fetch('/api/questions/generate-solution', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ questionId: question.id }),
      })

      const result = await response.json()

      if (!response.ok) {
        throw new Error(result.error || 'Failed to generate solution')
      }

      toast.success('Solution generated successfully!')
      router.refresh()
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Something went wrong')
    } finally {
      setIsGenerating(false)
    }
  }

  const stats = question.user_question_stats?.[0] || null

  const difficultyColors = {
    easy: 'bg-green-500/10 text-green-500 hover:bg-green-500/20',
    medium: 'bg-yellow-500/10 text-yellow-500 hover:bg-yellow-500/20',
    hard: 'bg-orange-500/10 text-orange-500 hover:bg-orange-500/20',
    very_hard: 'bg-red-500/10 text-red-500 hover:bg-red-500/20',
  }

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <Button
          variant="ghost"
          size="sm"
          className="gap-2"
          onClick={() => router.back()}
        >
          <ArrowLeft className="h-4 w-4" />
          Back
        </Button>

        <div className="flex items-center gap-2">
          <Button variant="outline" size="sm" className="gap-2">
            <Share2 className="h-4 w-4" />
            Share
          </Button>

          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="icon">
                <MoreVertical className="h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuItem>
                <Edit className="h-4 w-4 mr-2" />
                Edit Question
              </DropdownMenuItem>
              <DropdownMenuItem className="text-destructive focus:text-destructive">
                <Trash2 className="h-4 w-4 mr-2" />
                Delete
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>

      {/* Main Content */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {/* Left Column - Question & Solutions */}
        <div className="md:col-span-2 space-y-6">
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
              </div>
            </CardHeader>
            <CardContent className="space-y-6">
              {/* Question Text */}
              <div className="prose dark:prose-invert max-w-none">
                <Latex>{question.question_text}</Latex>
              </div>

              {/* Options if MCQ */}
              {question.options && question.options.length > 0 && (
                <div className="space-y-2 pt-2">
                  <p className="font-medium text-sm text-muted-foreground">Options:</p>
                  <div className="grid gap-2">
                    {question.options.map((option, idx) => (
                      <div key={idx} className="p-3 rounded-md bg-muted/50 border flex gap-3">
                        <span className="font-mono text-muted-foreground">{String.fromCharCode(65 + idx)}.</span>
                        <Latex>{option}</Latex>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* Image if available */}
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

          <Tabs defaultValue="solutions" className="w-full">
            <TabsList className="w-full justify-start">
              <TabsTrigger value="solutions">Solutions ({question.solutions.length})</TabsTrigger>
              <TabsTrigger value="hint">Hint</TabsTrigger>
              <TabsTrigger value="notes">My Notes</TabsTrigger>
            </TabsList>

            <TabsContent value="solutions" className="space-y-4 mt-4">
              {question.solutions.length > 0 ? (
                question.solutions.map((solution) => (
                  <Card key={solution.id}>
                    <CardHeader className="pb-3">
                      <div className="flex items-center justify-between">
                        <div className="flex items-center gap-2">
                          <Badge variant="secondary">
                            {solution.is_ai_best ? 'AI Solution' : 'Contributor'}
                          </Badge>
                          <span className="text-xs text-muted-foreground">
                            {format(new Date(solution.created_at), 'MMM d, yyyy')}
                          </span>
                        </div>
                      </div>
                    </CardHeader>
                    <CardContent className="space-y-4">
                      {solution.approach_description && (
                        <div className="text-sm text-muted-foreground italic">
                          Strategy: {solution.approach_description}
                        </div>
                      )}

                      <div className="prose dark:prose-invert max-w-none">
                        <Latex>{solution.solution_text}</Latex>
                      </div>

                      {solution.numerical_answer && (
                        <div className="pt-2 border-t mt-4">
                          <span className="font-medium mr-2">Final Answer:</span>
                          <span className="font-mono bg-muted px-2 py-1 rounded">
                            {solution.numerical_answer}
                          </span>
                        </div>
                      )}
                    </CardContent>
                  </Card>
                ))
              ) : (
                <Card className="border-dashed">
                  <CardContent className="flex flex-col items-center justify-center py-8 text-center">
                    <div className="h-12 w-12 rounded-full bg-muted flex items-center justify-center mb-4">
                      <HelpCircle className="h-6 w-6 text-muted-foreground" />
                    </div>
                    <p className="font-medium">No solutions yet</p>
                    <p className="text-sm text-muted-foreground mb-4">
                      Generate an AI solution or write your own.
                    </p>
                    <Button onClick={handleGenerateSolution} disabled={isGenerating}>
                      {isGenerating ? (
                        <>
                          <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                          Generating...
                        </>
                      ) : (
                        'Generate AI Solution'
                      )}
                    </Button>
                  </CardContent>
                </Card>
              )}
            </TabsContent>

            <TabsContent value="hint" className="mt-4">
              <Card>
                <CardContent className="pt-6">
                  {question.hint ? (
                    <div className="flex gap-3">
                      <div className="h-8 w-8 rounded-full bg-yellow-500/10 flex-shrink-0 flex items-center justify-center">
                        <HelpCircle className="h-4 w-4 text-yellow-500" />
                      </div>
                      <div className="prose dark:prose-invert">
                        <p className="mt-1">{question.hint}</p>
                      </div>
                    </div>
                  ) : (
                    <p className="text-muted-foreground text-center py-4">No hints available for this question.</p>
                  )}
                </CardContent>
              </Card>
            </TabsContent>

            <TabsContent value="notes" className="mt-4">
              <Card>
                <CardContent className="pt-6 text-center text-muted-foreground">
                  Personal notes feature coming soon.
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>
        </div>

        {/* Right Column - Stats & Metadata */}
        <div className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="text-sm font-medium">Your Progress</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1">
                  <span className="text-xs text-muted-foreground">Status</span>
                  <div className="flex items-center gap-2 font-medium">
                    {stats?.solved ? (
                      <>
                        <CheckCircle2 className="h-4 w-4 text-green-500" />
                        <span>Solved</span>
                      </>
                    ) : stats?.failed ? (
                      <>
                        <XCircle className="h-4 w-4 text-red-500" />
                        <span>Failed</span>
                      </>
                    ) : (
                      <span className="text-muted-foreground">Not attempted</span>
                    )}
                  </div>
                </div>
                <div className="space-y-1">
                  <span className="text-xs text-muted-foreground">Attempts</span>
                  <p className="font-medium">{stats?.attempts || 0}</p>
                </div>
              </div>

              <Separator />

              <div className="space-y-1">
                <span className="text-xs text-muted-foreground">Last Practiced</span>
                <div className="flex items-center gap-2">
                  <Calendar className="h-4 w-4 text-muted-foreground" />
                  <span className="text-sm">
                    {stats?.last_practiced_at
                      ? format(new Date(stats.last_practiced_at), 'MMM d, yyyy')
                      : 'Never'}
                  </span>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="text-sm font-medium">Metadata</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <span className="text-xs text-muted-foreground">Topics</span>
                <div className="flex flex-wrap gap-2">
                  {question.topics.map(topic => (
                    <Badge key={topic} variant="secondary" className="text-xs">
                      {topic}
                    </Badge>
                  ))}
                </div>
              </div>

              <div className="space-y-2">
                <span className="text-xs text-muted-foreground">Type</span>
                <div className="flex items-center gap-2">
                  <Hash className="h-4 w-4 text-muted-foreground" />
                  <span className="text-sm">{question.type}</span>
                </div>
              </div>

              <div className="space-y-2">
                <span className="text-xs text-muted-foreground">Added On</span>
                <div className="flex items-center gap-2">
                  <Clock className="h-4 w-4 text-muted-foreground" />
                  <span className="text-sm">
                    {format(new Date(question.created_at), 'MMM d, yyyy')}
                  </span>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}