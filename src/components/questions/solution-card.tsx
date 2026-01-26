'use client'

import { useState } from 'react'
import { format } from 'date-fns'
import { Edit, Trash2, MoreVertical, Loader2 } from 'lucide-react'
import { Card, CardHeader, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Textarea } from '@/components/ui/textarea'
import { Latex } from '@/components/ui/latex'
import { SolutionSteps } from './solution-steps'
import { AIContentAssistant } from '@/components/ai/content-assistant'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger
} from '@/components/ui/dropdown-menu'
import type { Solution } from '@/lib/types'
import { toast } from 'sonner'

interface SolutionCardProps {
  solution: Solution
  currentUserId: string
  onDelete?: (id: string) => void
  onUpdate?: () => void
}

export function SolutionCard({ solution, currentUserId, onDelete, onUpdate }: SolutionCardProps) {
  const [isEditing, setIsEditing] = useState(false)
  const [isSaving, setIsSaving] = useState(false)
  const [editedText, setEditedText] = useState(solution.solution_text)

  const isOwner = currentUserId === solution.contributor_id

  const handleSave = async () => {
    setIsSaving(true)
    try {
      const response = await fetch(`/api/solutions/${solution.id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ solution_text: editedText }),
      })

      if (!response.ok) throw new Error('Failed to update solution')

      toast.success('Solution updated')
      setIsEditing(false)
      onUpdate?.()
    } catch (error) {
      toast.error('Failed to update solution')
    } finally {
      setIsSaving(false)
    }
  }

  if (isEditing) {
    return (
      <Card>
        <CardHeader className="pb-3">
           <div className="flex items-center justify-between">
             <span className="font-semibold">Edit Solution</span>
             <AIContentAssistant
               content={editedText}
               contentType="solution"
               onContentChange={setEditedText}
             />
           </div>
        </CardHeader>
        <CardContent className="space-y-4">
          <Textarea
            value={editedText}
            onChange={(e) => setEditedText(e.target.value)}
            className="min-h-[200px] font-mono"
          />
          <div className="flex justify-end gap-2">
            <Button variant="ghost" onClick={() => setIsEditing(false)}>Cancel</Button>
            <Button onClick={handleSave} disabled={isSaving}>
              {isSaving && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Save Changes
            </Button>
          </div>
        </CardContent>
      </Card>
    )
  }

  return (
    <Card>
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
          {isOwner && (
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="ghost" size="icon" className="h-8 w-8">
                  <MoreVertical className="h-4 w-4" />
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end">
                <DropdownMenuItem onClick={() => setIsEditing(true)}>
                  <Edit className="h-4 w-4 mr-2" />
                  Edit
                </DropdownMenuItem>
                <DropdownMenuItem
                  className="text-destructive"
                  onClick={() => onDelete?.(solution.id)}
                >
                  <Trash2 className="h-4 w-4 mr-2" />
                  Delete
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          )}
        </div>
      </CardHeader>
      <CardContent className="space-y-4 overflow-x-auto">
        {solution.approach_description && (
          <div className="text-sm text-muted-foreground italic">
            Strategy: {solution.approach_description}
          </div>
        )}

        <SolutionSteps content={solution.solution_text} />

        {solution.numerical_answer && (
          <div className="pt-2 border-t mt-4">
            <span className="font-medium mr-2">Final Answer:</span>
            <span className="font-mono bg-muted px-2 py-1 rounded inline-block">
              <Latex>{solution.numerical_answer}</Latex>
            </span>
          </div>
        )}
      </CardContent>
    </Card>
  )
}
