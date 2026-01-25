'use client'

import { useState } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Badge } from '@/components/ui/badge'
import { Latex } from '@/components/ui/latex'
import { Check, Edit2, Loader2 } from 'lucide-react'
import type { GeminiExtractionResult } from '@/lib/types'

interface PreviewCardProps {
  data: GeminiExtractionResult & { image_url: string; embedding: number[] }
  onSave: (data: GeminiExtractionResult & { image_url: string; embedding: number[] }) => Promise<void>
  isSaving: boolean
}

export function PreviewCard({ data, onSave, isSaving }: PreviewCardProps) {
  const [editMode, setEditMode] = useState(false)
  const [editedData, setEditedData] = useState(data)

  const handleSave = async () => {
    await onSave(editedData)
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
        {/* Question */}
        <div className="space-y-2">
          <Label>Question</Label>
          {editMode ? (
            <textarea
              className="w-full min-h-32 p-3 rounded-md bg-muted border"
              value={editedData.question_text}
              onChange={(e) => setEditedData({ ...editedData, question_text: e.target.value })}
            />
          ) : (
            <div className="p-3 rounded-md bg-muted">
              <Latex>{editedData.question_text}</Latex>
            </div>
          )}
        </div>

        {/* Options (if MCQ) */}
        {editedData.options.length > 0 && (
          <div className="space-y-2">
            <Label>Options</Label>
            <div className="space-y-2">
              {editedData.options.map((option, index) => (
                <div key={index} className="p-2 rounded-md bg-muted">
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
                className="w-full min-h-32 p-3 rounded-md bg-muted border"
                value={editedData.solution}
                onChange={(e) => setEditedData({ ...editedData, solution: e.target.value })}
              />
            ) : (
              <div className="p-3 rounded-md bg-muted">
                <Latex>{editedData.solution}</Latex>
              </div>
            )}
          </div>
        )}

        {/* Hint */}
        <div className="space-y-2">
          <Label>Hint</Label>
          {editMode ? (
            <textarea
              className="w-full min-h-20 p-3 rounded-md bg-muted border"
              value={editedData.hint}
              onChange={(e) => setEditedData({ ...editedData, hint: e.target.value })}
            />
          ) : (
            <div className="p-3 rounded-md bg-muted text-sm">
              {editedData.hint}
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
