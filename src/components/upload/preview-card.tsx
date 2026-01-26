'use client'

import { useState } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Badge } from '@/components/ui/badge'
import { SolutionSteps } from '@/components/questions/solution-steps'
import { Latex } from '@/components/ui/latex'
import { Alert, AlertDescription, AlertTitle } from '@/components/ui/alert'
import { Check, Edit2, Loader2, AlertTriangle, Copy } from 'lucide-react'
import type { GeminiExtractionResult, DuplicateCheckResult } from '@/lib/types'

interface PreviewCardProps {
  data: GeminiExtractionResult & {
    image_url: string;
    embedding: number[];
    duplicate_check?: DuplicateCheckResult | null;
  }
  onSave: (data: GeminiExtractionResult & {
    image_url: string;
    embedding: number[];
    existing_question_id?: string;
  }) => Promise<void>
  isSaving: boolean
}

export function PreviewCard({ data, onSave, isSaving }: PreviewCardProps) {
  const [editMode, setEditMode] = useState(false)
  const [editedData, setEditedData] = useState({
    ...data,
    hint: data.hint || '',
    solution: data.solution || '',
    numerical_answer: data.numerical_answer || ''
  })

  const handleSave = async () => {
    await onSave(editedData)
  }

  const handleLinkToExisting = async () => {
    if (!data.duplicate_check?.matched_question_id) return

    // We pass the current edited data (in case they fixed the solution)
    // but include the existing ID to trigger the link logic in the API
    await onSave({
      ...editedData,
      existing_question_id: data.duplicate_check.matched_question_id
    })
  }


  const difficultyColors: Record<string, string> = {
    easy: 'bg-green-500/20 text-green-400',
    medium: 'bg-yellow-500/20 text-yellow-400',
    hard: 'bg-orange-500/20 text-orange-400',
    very_hard: 'bg-red-500/20 text-red-400',
  }

  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between">
        <CardTitle>Extracted Question</CardTitle>
        <Button
          variant="ghost"
          size="sm"
          onClick={() => setEditMode(!editMode)}
        >
          <Edit2 className="h-4 w-4 mr-1" />
          {editMode ? 'Preview' : 'Edit'}
        </Button>
      </CardHeader>
      <CardContent className="space-y-6">
        {/* Duplicate Warning */}
        {data.duplicate_check?.is_duplicate && (
          <Alert variant="destructive" className="bg-yellow-500/10 text-yellow-600 border-yellow-500/50">
            <AlertTriangle className="h-4 w-4 stroke-yellow-600" />
            <AlertTitle>Potential Duplicate Found</AlertTitle>
            <AlertDescription>
              <p className="mt-1">
                This question seems very similar to an existing one in your bank.
                {data.duplicate_check.differences && (
                  <span className="block mt-1 font-medium">Difference: {data.duplicate_check.differences}</span>
                )}
              </p>
              <div className="mt-3 flex gap-2">
                <Button
                  variant="default"
                  size="sm"
                  className="bg-yellow-600 hover:bg-yellow-700 text-white"
                  onClick={handleLinkToExisting}
                  disabled={isSaving}
                >
                  {isSaving ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : <Copy className="mr-2 h-4 w-4" />}
                  Link as Solution
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  className="border-yellow-500/50 hover:bg-yellow-500/10"
                  onClick={() => window.open(`/dashboard/questions/${data.duplicate_check?.matched_question_id}`, '_blank')}
                >
                  View Existing
                </Button>
                <Button
                  variant="ghost"
                  size="sm"
                  className="hover:bg-yellow-500/10"
                  onClick={handleSave}
                  disabled={isSaving}
                >
                  Save as New
                </Button>
              </div>
            </AlertDescription>
          </Alert>
        )}

        {/* Question */}
        <div className="space-y-2">
          <Label>Question</Label>
          {editMode ? (
            <textarea
              className="w-full min-h-32 p-3 rounded-md bg-muted border font-mono text-sm leading-relaxed"
              value={editedData.question_text}
              onChange={(e) => setEditedData({ ...editedData, question_text: e.target.value })}
            />
          ) : (
            <div className="p-4 rounded-md bg-muted/30 border border-border/50 text-base leading-loose">
              <Latex>{editedData.question_text}</Latex>
            </div>
          )}
        </div>

        {/* Options (if MCQ) */}
        {editedData.options && editedData.options.length > 0 && (
          <div className="space-y-2">
            <Label>Options</Label>
            <div className="space-y-2">
              {editedData.options.map((option, index) => (
                <div key={index} className="p-3 rounded-md bg-muted/30 border border-border/50 text-base leading-relaxed">
                  <Latex>{option}</Latex>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Solution */}
        {editedData.solution && (
          <div className="space-y-2">
            <Label>Solution</Label>
            {editMode ? (
              <textarea
                className="w-full min-h-32 p-3 rounded-md bg-muted border font-mono text-sm leading-relaxed"
                value={editedData.solution}
                onChange={(e) => setEditedData({ ...editedData, solution: e.target.value })}
              />
            ) : (
              <div className="p-4 rounded-md bg-muted/30 border border-border/50">
                <SolutionSteps content={editedData.solution} />
              </div>
            )}
          </div>
        )}

        {/* Hint */}
        <div className="space-y-2">
          <Label>Hint</Label>
          {editMode ? (
            <textarea
              className="w-full min-h-20 p-3 rounded-md bg-muted border font-mono text-sm leading-relaxed"
              value={editedData.hint}
              onChange={(e) => setEditedData({ ...editedData, hint: e.target.value })}
            />
          ) : (
            <div className="p-4 rounded-md bg-muted/20 border border-yellow-500/20 text-base leading-loose italic text-muted-foreground">
              <Latex>{editedData.hint}</Latex>
            </div>
          )}
        </div>

        {/* Metadata */}
        <div className="flex flex-wrap gap-2">
          <Badge variant="secondary">{editedData.subject}</Badge>
          <Badge variant="secondary">{editedData.chapter}</Badge>
          <Badge variant="secondary">{editedData.type}</Badge>
          <Badge className={difficultyColors[editedData.difficulty]}>
            {editedData.difficulty}
          </Badge>
          {editedData.topics.map((topic) => (
            <Badge key={topic} variant="outline">{topic}</Badge>
          ))}
        </div>

        {/* Numerical answer */}
        {editedData.numerical_answer && (
          <div className="space-y-2">
            <Label>Numerical Answer</Label>
            {editMode ? (
              <Input
                value={editedData.numerical_answer}
                onChange={(e) => setEditedData({ ...editedData, numerical_answer: e.target.value })}
              />
            ) : (
              <div className="p-2 rounded-md bg-muted font-mono">
                {editedData.numerical_answer}
              </div>
            )}
          </div>
        )}

        {/* Save button */}
        <Button
          className="w-full"
          onClick={handleSave}
          disabled={isSaving}
        >
          {isSaving ? (
            <>
              <Loader2 className="h-4 w-4 mr-2 animate-spin" />
              Saving...
            </>
          ) : (
            <>
              <Check className="h-4 w-4 mr-2" />
              Save Question
            </>
          )}
        </Button>
      </CardContent>
    </Card>
  )
}
