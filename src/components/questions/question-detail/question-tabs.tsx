'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { toast } from 'sonner'
import { Edit2, HelpCircle, Loader2 } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { Textarea } from "@/components/ui/textarea"
import { Input } from "@/components/ui/input"
import { Latex } from '@/components/ui/latex'
import type { Question, Solution } from '@/lib/types'
import { SolutionCard } from '@/components/questions/solution-card'
import { AIContentAssistant } from '@/components/ai/content-assistant'

interface QuestionTabsProps {
  question: Question & { solutions: Solution[] }
  userId: string | null
  isGenerating: boolean
  isSaving: boolean
  editForm: { hint: string }
  setEditForm: (form: { hint: string }) => void
  handleGenerateSolution: () => void
  handleSolutionDelete: (solutionId: string) => void
  handleSave: (section: 'hint' | 'tags') => void
}

export function QuestionTabs({
  question,
  userId,
  isGenerating,
  isSaving,
  editForm,
  setEditForm,
  handleGenerateSolution,
  handleSolutionDelete,
  handleSave,
}: QuestionTabsProps) {
  const router = useRouter()
  const [isEditingHint, setIsEditingHint] = useState(false)

  return (
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
              <Button
                onClick={userId ? handleGenerateSolution : () => router.push('/login')}
                disabled={isGenerating}
              >
                {isGenerating ? (
                  <>
                    <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                    Generating...
                  </>
                ) : (
                  userId ? 'Generate AI Solution' : 'Login to Generate Solution'
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
                  onChange={(e) => setEditForm({ ...editForm, hint: e.target.value })}
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
                  onContentChange={(val) => setEditForm({ ...editForm, hint: val })}
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
  )
}
