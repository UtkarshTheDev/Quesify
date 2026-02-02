'use client'

import { format } from 'date-fns'
import { Calendar, Clock, Edit2, Hash, Loader2, CheckCircle2, XCircle } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Separator } from '@/components/ui/separator'
import { Input } from "@/components/ui/input"
import type { Question, UserQuestionStats } from '@/lib/types'
import { useRouter } from 'next/navigation'

interface QuestionSidebarProps {
  question: Question
  stats: UserQuestionStats | null
  userId: string | null
  tagInput: string
  setTagInput: (value: string) => void
  isSaving: boolean
  isMarkingSolved: boolean
  handleSave: (section: 'tags') => void
  handleMarkSolved: () => void
  isEditingTags: boolean
  setIsEditingTags: (editing: boolean) => void
}

export function QuestionSidebar({
  question,
  stats,
  userId,
  tagInput,
  setTagInput,
  isSaving,
  isMarkingSolved,
  handleSave,
  handleMarkSolved,
  isEditingTags,
  setIsEditingTags,
}: QuestionSidebarProps) {
  const router = useRouter()

  return (
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
              className="w-full mt-4 font-bold"
              onClick={userId ? handleMarkSolved : () => router.push('/login')}
              disabled={isMarkingSolved}
              variant={userId ? 'default' : 'secondary'}
            >
              {isMarkingSolved ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Updating...
                </>
              ) : (
                <>
                  <CheckCircle2 className="mr-2 h-4 w-4" />
                  {userId ? 'Mark as Solved' : 'Login to solve'}
                </>
              )}
            </Button>
          )}
        </CardContent>
      </Card>

      <Card>
        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
          <CardTitle className="text-sm font-medium">Metadata</CardTitle>
          {!isEditingTags && userId === question.owner_id && (
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
            <span className="text-xs text-muted-foreground uppercase font-black tracking-widest opacity-40">Type</span>
            <div className="flex items-center gap-2">
              <Hash className="h-4 w-4 text-muted-foreground" />
              <Badge variant="secondary" className="bg-primary/5 text-primary border-primary/10 font-bold px-2 py-0 h-6">
                {question.type}
              </Badge>
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
  )
}
