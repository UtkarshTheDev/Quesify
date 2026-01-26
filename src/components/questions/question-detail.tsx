'use client'

/* eslint-disable @next/next/no-img-element */
import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { format } from 'date-fns'
import { toast } from 'sonner'
import {
  ArrowLeft,
  Calendar,
  Clock,
  Hash,
  Share2,
  Edit2,
  Trash2,
  CheckCircle2,
  XCircle,
  HelpCircle,
  Loader2,
} from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { Separator } from '@/components/ui/separator'
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog"
import { Textarea } from "@/components/ui/textarea"
import { Input } from "@/components/ui/input"
import { Latex } from '@/components/ui/latex'
import type { Question, Solution, UserQuestionStats } from '@/lib/types'

import { SolutionCard } from '@/components/questions/solution-card'
import { AIContentAssistant } from '@/components/ai/content-assistant'

interface QuestionDetailProps {
  question: Question & {
    solutions: Solution[]
    user_question_stats: UserQuestionStats[]
  }
  userId: string
}

export function QuestionDetail({ question, userId }: QuestionDetailProps) {
  const router = useRouter()
  const [isGenerating, setIsGenerating] = useState(false)
  const [isMarkingSolved, setIsMarkingSolved] = useState(false)

  // Edit States
  const [isEditingHint, setIsEditingHint] = useState(false)
  const [isEditingTags, setIsEditingTags] = useState(false)
  const [isSaving, setIsSaving] = useState(false)

  // Form Data
  const [editForm, setEditForm] = useState({
    hint: question.hint || '',
  })
  const [tagInput, setTagInput] = useState(question.topics.join(', '))

  // Delete State
  const [showDeleteDialog, setShowDeleteDialog] = useState(false)
  const [isDeleting, setIsDeleting] = useState(false)

  const handleSave = async (section: 'hint' | 'tags') => {
    setIsSaving(true)
    try {
      const payload: Partial<Question> = {}

      if (section === 'hint') {
        payload.hint = editForm.hint
      } else if (section === 'tags') {
        const newTopics = tagInput.split(',').map(t => t.trim()).filter(Boolean)
        payload.topics = newTopics
      }

      const response = await fetch(`/api/questions/${question.id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      })

      if (!response.ok) {
        throw new Error('Failed to update question')
      }

      toast.success('Saved successfully')

      if (section === 'hint') setIsEditingHint(false)
      if (section === 'tags') setIsEditingTags(false)

      router.refresh()
    } catch {
      toast.error('Failed to save changes')
    } finally {
      setIsSaving(false)
    }
  }

  const handleDelete = async () => {
    setIsDeleting(true)
    try {
      const response = await fetch(`/api/questions/${question.id}`, {
        method: 'DELETE',
      })

      if (!response.ok) {
        throw new Error('Failed to delete question')
      }

      toast.success('Question deleted successfully')
      router.push('/dashboard/questions')
      router.refresh()
    } catch {
      toast.error('Failed to delete question')
      setIsDeleting(false)
    }
  }

  const handleGenerateSolution = async () => {
    setIsGenerating(true)
    try {
      const response = await fetch('/api/questions/generate-solution', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ questionId: question.id }),
      })

      if (!response.ok) throw new Error('Failed to generate solution')

      toast.success('Solution generated successfully!')
      router.refresh()
    } catch {
      toast.error('Something went wrong')
    } finally {
      setIsGenerating(false)
    }
  }

  const handleMarkSolved = async () => {
    setIsMarkingSolved(true)
    try {
      const response = await fetch('/api/questions/solve', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          questionId: question.id,
          solved: true,
          timeSpent: 0
        }),
      })

      if (!response.ok) throw new Error('Failed to update status')

      toast.success('Question marked as solved!')
      router.refresh()
    } catch {
      toast.error('Failed to mark as solved')
    } finally {
      setIsMarkingSolved(false)
    }
  }

  const handleSolutionDelete = async (solutionId: string) => {
    if (!confirm('Are you sure you want to delete this solution?')) return

    try {
      const response = await fetch(`/api/solutions/${solutionId}`, {
        method: 'DELETE',
      })

      if (!response.ok) throw new Error('Failed to delete solution')

      toast.success('Solution deleted successfully')
      router.refresh()
    } catch {
      toast.error('Failed to delete solution')
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
        </div>
      </div>

      {/* Delete Dialog */}
      <AlertDialog open={showDeleteDialog} onOpenChange={setShowDeleteDialog}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Are you absolutely sure?</AlertDialogTitle>
            <AlertDialogDescription>
              This action cannot be undone. This will permanently delete the question
              and all associated solutions from our servers.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={isDeleting}>Cancel</AlertDialogCancel>
            <AlertDialogAction
              onClick={(e) => {
                e.preventDefault()
                handleDelete()
              }}
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              disabled={isDeleting}
            >
              {isDeleting ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : 'Delete'}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {/* Left Column */}
        <div className="md:col-span-2 space-y-6">

          {/* Question Card */}
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

                <Button
                  variant="ghost"
                  size="icon"
                  className="text-muted-foreground hover:text-destructive transition-colors"
                  onClick={() => setShowDeleteDialog(true)}
                >
                  <Trash2 className="h-4 w-4" />
                </Button>
              </div>
            </CardHeader>
            <CardContent className="space-y-6">
              {/* Read Only View */}
              <div className="prose dark:prose-invert max-w-none">
                <Latex>{question.question_text}</Latex>
              </div>

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

          {/* Solutions & Hints Tabs */}
          <Tabs defaultValue="solutions" className="w-full">
            <TabsList className="w-full justify-start">
              <TabsTrigger value="solutions">Solutions ({question.solutions.length})</TabsTrigger>
              <TabsTrigger value="hint">Hint</TabsTrigger>
              <TabsTrigger value="notes">My Notes</TabsTrigger>
            </TabsList>

            <TabsContent value="solutions" className="space-y-4 mt-4">
              {question.solutions.length > 0 ? (
                question.solutions.map((solution) => (
                  <SolutionCard
                    key={solution.id}
                    solution={solution}
                    currentUserId={userId}
                    onDelete={handleSolutionDelete}
                    onUpdate={() => router.refresh()}
                  />
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
              <Card className={isEditingHint ? "ring-1 ring-ring transition-all duration-200" : ""}>
                <CardHeader className="pb-3">
                  <div className="flex items-center justify-between">
                    <CardTitle className="text-base">Hint</CardTitle>
                    {!isEditingHint && (
                      <Button variant="ghost" size="sm" onClick={() => setIsEditingHint(true)}>
                        <Edit2 className="h-4 w-4" />
                      </Button>
                    )}
                  </div>
                </CardHeader>
                <CardContent>
                  {isEditingHint ? (
                    <div className="space-y-4 animate-in fade-in zoom-in-95 duration-200">
                      <Textarea
                        value={editForm.hint}
                        onChange={(e) => setEditForm(prev => ({...prev, hint: e.target.value}))}
                        className="min-h-[100px] font-mono resize-y"
                        placeholder="Add a hint..."
                      />

                      <div className="rounded-md border bg-muted/50 p-4">
                        <p className="text-xs font-medium text-muted-foreground mb-2">Preview:</p>
                        <div className="prose dark:prose-invert max-w-none text-sm">
                          <Latex>{editForm.hint || 'Nothing to preview'}</Latex>
                        </div>
                      </div>

                      <AIContentAssistant
                        content={editForm.hint}
                        contentType="hint"
                        onContentChange={(val) => setEditForm(prev => ({...prev, hint: val}))}
                      />

                      <div className="flex items-center justify-end gap-2 pt-2">
                        <Button variant="ghost" size="sm" onClick={() => setIsEditingHint(false)}>
                          Cancel
                        </Button>
                        <Button size="sm" onClick={() => handleSave('hint')} disabled={isSaving}>
                          {isSaving && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                          Save Hint
                        </Button>
                      </div>
                    </div>
                  ) : (
                    <div className="flex gap-3">
                      <div className="h-8 w-8 rounded-full bg-yellow-500/10 flex-shrink-0 flex items-center justify-center">
                        <HelpCircle className="h-4 w-4 text-yellow-500" />
                      </div>
                      <div className="prose dark:prose-invert flex-1">
                        {question.hint ? (
                          <Latex>{question.hint}</Latex>
                        ) : (
                          <p className="text-muted-foreground italic">No hint provided.</p>
                        )}
                      </div>
                    </div>
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

              {!stats?.solved && (
                <Button
                  className="w-full mt-4"
                  onClick={handleMarkSolved}
                  disabled={isMarkingSolved}
                >
                  {isMarkingSolved ? (
                    <>
                      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                      Updating...
                    </>
                  ) : (
                    <>
                      <CheckCircle2 className="mr-2 h-4 w-4" />
                      Mark as Solved
                    </>
                  )}
                </Button>
              )}
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Metadata</CardTitle>
              {!isEditingTags && (
                <Button variant="ghost" size="icon" className="h-6 w-6" onClick={() => setIsEditingTags(true)}>
                  <Edit2 className="h-3 w-3" />
                </Button>
              )}
            </CardHeader>
            <CardContent className="space-y-4 mt-2">
              <div className="space-y-2">
                <div className="flex justify-between items-center">
                   <span className="text-xs text-muted-foreground">Topics</span>
                </div>
                {isEditingTags ? (
                  <div className="space-y-2 animate-in fade-in zoom-in-95 duration-200">
                    <Input
                      value={tagInput}
                      onChange={(e) => setTagInput(e.target.value)}
                      placeholder="Calculus, Derivatives, etc."
                      className="h-8 text-xs"
                    />
                    <div className="flex gap-2">
                      <Button size="sm" variant="outline" className="h-7 text-xs flex-1" onClick={() => setIsEditingTags(false)}>
                        Cancel
                      </Button>
                      <Button size="sm" className="h-7 text-xs flex-1" onClick={() => handleSave('tags')} disabled={isSaving}>
                        {isSaving ? <Loader2 className="h-3 w-3 animate-spin" /> : 'Save'}
                      </Button>
                    </div>
                  </div>
                ) : (
                  <div className="flex flex-wrap gap-2">
                    {question.topics.length > 0 ? (
                      question.topics.map(topic => (
                        <Badge key={topic} variant="secondary" className="text-xs">
                          {topic}
                        </Badge>
                      ))
                    ) : (
                      <span className="text-xs text-muted-foreground italic">No topics</span>
                    )}
                  </div>
                )}
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
