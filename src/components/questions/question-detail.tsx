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
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
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
  const [activeTab, setActiveTab] = useState('question')
  const [isGenerating, setIsGenerating] = useState(false)
  const [isMarkingSolved, setIsMarkingSolved] = useState(false)

  // Delete & Edit states
  const [showDeleteDialog, setShowDeleteDialog] = useState(false)
  const [isDeleting, setIsDeleting] = useState(false)
  const [showEditDialog, setShowEditDialog] = useState(false)
  const [isEditing, setIsEditing] = useState(false)
  const [editForm, setEditForm] = useState({
    question_text: question.question_text,
    options: question.options || [],
    hint: question.hint || ''
  })

  const handleDelete = async () => {
    setIsDeleting(true)
    try {
      const response = await fetch(`/api/questions/${question.id}`, {
        method: 'DELETE',
      })

      if (!response.ok) {
        const result = await response.json()
        throw new Error(result.error || 'Failed to delete question')
      }

      toast.success('Question deleted successfully')
      router.push('/dashboard/questions')
      router.refresh()
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to delete question')
      setIsDeleting(false)
    }
  }

  const handleEdit = async () => {
    setIsEditing(true)
    try {
      const response = await fetch(`/api/questions/${question.id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(editForm),
      })

      if (!response.ok) {
        const result = await response.json()
        throw new Error(result.error || 'Failed to update question')
      }

      toast.success('Question updated successfully')
      setShowEditDialog(false)
      router.refresh()
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to update question')
    } finally {
      setIsEditing(false)
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

      if (!response.ok) {
        throw new Error('Failed to update status')
      }

      toast.success('Question marked as solved! Streak updated.')
      router.refresh()
    } catch (error) {
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

      if (!response.ok) {
        throw new Error('Failed to delete solution')
      }

      toast.success('Solution deleted successfully')
      router.refresh()
    } catch (error) {
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

          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="icon">
                <MoreVertical className="h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuItem onClick={() => setShowEditDialog(true)}>
                <Edit className="h-4 w-4 mr-2" />
                Edit Question
              </DropdownMenuItem>
              <DropdownMenuItem
                className="text-destructive focus:text-destructive"
                onClick={() => setShowDeleteDialog(true)}
              >
                <Trash2 className="h-4 w-4 mr-2" />
                Delete
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>

      {/* Delete Confirmation Dialog */}
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
              {isDeleting ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Deleting...
                </>
              ) : (
                'Delete'
              )}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      {/* Edit Dialog */}
      <Dialog open={showEditDialog} onOpenChange={setShowEditDialog}>
        <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Edit Question</DialogTitle>
            <DialogDescription>
              Make changes to the question text or options here.
            </DialogDescription>
          </DialogHeader>

          <div className="grid gap-4 py-4">
            <div className="space-y-2">
              <div className="flex items-center justify-between">
                <Label htmlFor="question_text">Question Text (LaTeX supported)</Label>
                <AIContentAssistant
                  content={editForm.question_text}
                  contentType="question"
                  onContentChange={(val) => setEditForm(prev => ({ ...prev, question_text: val }))}
                />
              </div>
              <Textarea
                id="question_text"
                className="min-h-[150px] font-mono"
                value={editForm.question_text}
                onChange={(e) => setEditForm(prev => ({ ...prev, question_text: e.target.value }))}
              />
            </div>

            {question.type === 'MCQ' && (
              <div className="space-y-4">
                <Label>Options</Label>
                {editForm.options?.map((option, idx) => (
                  <div key={idx} className="flex gap-2 items-start">
                    <span className="mt-3 font-mono text-sm text-muted-foreground w-6">
                      {String.fromCharCode(65 + idx)}.
                    </span>
                    <Textarea
                      value={option}
                      onChange={(e) => {
                        const newOptions = [...(editForm.options || [])]
                        newOptions[idx] = e.target.value
                        setEditForm(prev => ({ ...prev, options: newOptions }))
                      }}
                      className="flex-1 font-mono h-20"
                    />
                  </div>
                ))}
              </div>
            )}

            <div className="space-y-2">
              <div className="flex items-center justify-between">
                <Label htmlFor="hint">Hint (Optional)</Label>
                <AIContentAssistant
                  content={editForm.hint}
                  contentType="hint"
                  onContentChange={(val) => setEditForm(prev => ({ ...prev, hint: val }))}
                />
              </div>
              <Textarea
                id="hint"
                className="min-h-[100px] font-mono"
                value={editForm.hint}
                onChange={(e) => setEditForm(prev => ({ ...prev, hint: e.target.value }))}
                placeholder="Add a hint to help solve this problem..."
              />
            </div>
          </div>

          <DialogFooter>
            <Button variant="outline" onClick={() => setShowEditDialog(false)} disabled={isEditing}>
              Cancel
            </Button>
            <Button onClick={handleEdit} disabled={isEditing}>
              {isEditing ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Saving...
                </>
              ) : (
                'Save Changes'
              )}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

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