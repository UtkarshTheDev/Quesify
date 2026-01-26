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
  status: {
    extracting: boolean;
    extractError: string | null;
    solving: boolean;
    solveError: string | null;
    classifying: boolean;
    classifyError: string | null;
    finalizing: boolean;
    finalizeError: string | null;
  }
  onSave: (data: GeminiExtractionResult & {
    image_url: string;
    embedding: number[];
    existing_question_id?: string;
  }) => Promise<void>
  isSaving: boolean
  onRetryExtract?: () => void
  onRetrySolve?: () => void
  onRetryClassify?: () => void
}

export function PreviewCard({
  data,
  status,
  onSave,
  isSaving,
  onRetryExtract,
  onRetrySolve,
  onRetryClassify
}: PreviewCardProps) {
  const [editMode, setEditMode] = useState(false)
  const [localEdits, setLocalEdits] = useState<Partial<GeminiExtractionResult> | null>(null)

  const displayData = {
    ...data,
    ...(localEdits || {})
  }

  const handleSave = async () => {
    await onSave(displayData as any)
  }

  const handleLinkToExisting = async () => {
    if (!data.duplicate_check?.matched_question_id) return
    await onSave({
      ...displayData,
      existing_question_id: data.duplicate_check.matched_question_id
    } as any)
  }

  const difficultyColors: Record<string, string> = {
    easy: 'bg-green-500/10 text-green-500 border-green-500/20',
    medium: 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20',
    hard: 'bg-orange-500/10 text-orange-500 border-orange-500/20',
    very_hard: 'bg-red-500/10 text-red-500 border-red-500/20',
  }

  const Skeleton = ({ className }: { className?: string }) => (
    <div className={`animate-pulse bg-muted/50 rounded-md ${className}`} />
  )

  const SectionFade = ({ children, isLoaded }: { children: React.ReactNode, isLoaded: boolean }) => (
    <div className={`transition-all duration-700 ${isLoaded ? 'animate-in fade-in slide-in-from-bottom-2' : ''}`}>
      {children}
    </div>
  )

  interface ProgressLinkProps {
    label: string;
    isLoading: boolean;
    error: string | null;
    done: boolean;
    onRetry?: () => void;
  }

  const ProgressLink = ({ label, isLoading, error, done, onRetry }: ProgressLinkProps) => (
    <div className="flex items-center justify-between text-xs px-2 py-1.5 rounded-lg bg-white/5">
      <span className="text-muted-foreground">{label}</span>
      {error ? (
        <Button variant="ghost" size="icon" className="h-5 w-5 text-destructive" onClick={onRetry}>
          <AlertTriangle className="h-3 w-3" />
        </Button>
      ) : isLoading ? (
        <Loader2 className="h-3 w-3 animate-spin" />
      ) : done ? (
        <Check className="h-3 w-3 text-green-500" />
      ) : null}
    </div>
  );

  return (
    <div className="grid grid-cols-1 lg:grid-cols-[1fr_450px] gap-8 items-start animate-in fade-in duration-1000">
      {/* LEFT COLUMN: Question & Solution Stream */}
      <div className="space-y-8">
        {/* Question Card */}
        <Card className="overflow-hidden border-none shadow-xl bg-card/60 backdrop-blur-md ring-1 ring-white/10 pb-6 gap-0 py-0">
          <CardHeader className="flex flex-row items-center justify-between bg-muted/20 py-4">
            <div className="space-y-1">
              <CardTitle className="text-xl font-bold">Extraction Result</CardTitle>
              <p className="text-xs text-muted-foreground">Verification & Preview</p>
            </div>
            <Button
              variant="secondary"
              size="sm"
              className="h-8"
              onClick={() => {
                if (!editMode) setLocalEdits(data)
                setEditMode(!editMode)
              }}
            >
              <Edit2 className="h-3.5 w-3.5 mr-1.5" />
              {editMode ? 'Preview' : 'Edit'}
            </Button>
          </CardHeader>

          <CardContent className="p-6 space-y-8">
            {/* Question */}
            <div className="space-y-3">
              <Label className="uppercase tracking-widest text-[10px] font-bold text-muted-foreground opacity-70">The Question</Label>
              {status.extractError ? (
                <div className="p-8 rounded-2xl bg-destructive/5 border border-destructive/20 text-center space-y-3">
                  <p className="text-sm text-destructive font-medium">{status.extractError}</p>
                  <Button variant="outline" size="sm" onClick={onRetryExtract}>Try Again</Button>
                </div>
              ) : (
                editMode ? (
                  <textarea
                    className="w-full min-h-32 p-4 rounded-xl bg-muted/50 border-none ring-1 ring-border/50 focus:ring-primary/40 focus:bg-muted/80 transition-all font-mono text-sm leading-relaxed"
                    value={displayData.question_text}
                    onChange={(e) => setLocalEdits({ ...localEdits, question_text: e.target.value })}
                  />
                ) : (
                  <div className="p-5 rounded-2xl bg-primary/[0.03] ring-1 ring-white/5 shadow-inner text-xl leading-relaxed">
                    <Latex>{displayData.question_text}</Latex>
                  </div>
                )
              )}
            </div>

            {/* Options */}
            {displayData.options && displayData.options.length > 0 && (
              <div className="space-y-3 pb-2">
                <Label className="uppercase tracking-widest text-[10px] font-bold text-muted-foreground opacity-70">Choices</Label>
                <div className="grid gap-3">
                  {displayData.options.map((option, index) => (
                    <div key={index} className="group p-4 rounded-xl bg-muted/20 border border-transparent hover:border-primary/20 hover:bg-muted/30 transition-all flex gap-3 items-start">
                      <span className="mt-1 w-6 h-6 flex items-center justify-center rounded-full bg-primary/10 text-primary text-[10px] font-bold shrink-0">{String.fromCharCode(65 + index)}</span>
                      <div className="flex-1 pt-0.5"><Latex>{option}</Latex></div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </CardContent>
        </Card>

        {/* Detailed Solution Card (Directly below Question, matching width) */}
        <Card className="overflow-hidden border-none shadow-2xl bg-card/60 backdrop-blur-md ring-1 ring-white/10 py-0 gap-0">
          <CardHeader className="bg-muted/20 border-b border-border/40 pt-6 pb-0">
            <div className="flex items-center justify-between pb-4">
              <CardTitle className="text-xl font-bold flex items-center gap-3">
                {status.solving ? <Loader2 className="h-5 w-5 animate-spin text-primary" /> : <div className="w-2 h-2 rounded-full bg-primary" />}
                Step-by-Step Solution
              </CardTitle>
              {status.solveError && (
                <Button variant="ghost" size="sm" className="h-8 text-destructive hover:bg-destructive/10" onClick={onRetrySolve}>
                  <AlertTriangle className="h-3.5 w-3.5 mr-1.5" />
                  Retry Solve
                </Button>
              )}
            </div>
          </CardHeader>
          <CardContent className="p-8">
            {status.solveError ? (
              <div className="py-12 text-center space-y-4">
                <div className="p-3 rounded-full bg-destructive/10 w-12 h-12 mx-auto flex items-center justify-center text-destructive">
                  <AlertTriangle className="h-6 w-6" />
                </div>
                <div className="space-y-1">
                  <p className="text-sm font-bold text-destructive">Analysis Failed</p>
                  <p className="text-xs text-muted-foreground px-12 leading-relaxed">The AI was unable to generate a solution for this mathematical problem. This can happen with very low-quality images or ambiguous text.</p>
                </div>
                <Button variant="outline" size="sm" onClick={onRetrySolve} className="rounded-xl">Regenerate Solution</Button>
              </div>
            ) : status.solving ? (
              <div className="space-y-6">
                <Skeleton className="h-10 w-3/4" />
                <Skeleton className="h-40 w-full" />
              </div>
            ) : (
              <SectionFade isLoaded={true}>
                {editMode ? (
                  <textarea
                    className="w-full min-h-64 p-6 rounded-2xl bg-muted/50 border-none ring-1 ring-border/50 focus:ring-primary/40 focus:bg-muted/80 transition-all font-mono text-sm leading-relaxed"
                    value={displayData.solution}
                    onChange={(e) => setLocalEdits({ ...localEdits, solution: e.target.value })}
                  />
                ) : (
                  <div className="space-y-10">
                    <div className="solution-content">
                      <SolutionSteps content={displayData.solution} />
                    </div>

                    {displayData.numerical_answer && (
                      <div className="mt-8 pt-8 border-t border-border/40 flex flex-col sm:flex-row items-center justify-between gap-4">
                        <span className="text-sm font-bold text-primary uppercase tracking-tighter">Final Evaluation</span>
                        <div className="bg-primary/10 ring-1 ring-primary/30 shadow-inner px-8 py-3 rounded-2xl text-center">
                          <code className="text-xl font-black text-primary tracking-widest"><Latex>{displayData.numerical_answer}</Latex></code>
                        </div>
                      </div>
                    )}
                  </div>
                )}
              </SectionFade>
            )}
          </CardContent>
        </Card>
      </div>

      {/* RIGHT COLUMN: Professional Sidebar */}
      <div className="space-y-6 lg:sticky lg:top-8">
        {/* Progress & Action Card */}
        <Card className="border-none bg-primary/5 ring-1 ring-primary/20 shadow-lg">
          <CardContent className="p-6 space-y-4">
            <div className="flex items-center justify-between">
              <Label className="uppercase tracking-widest text-[10px] font-bold text-primary/70">AI Progress Tracker</Label>
              {status.finalizing || status.solving || status.classifying ? (
                <Badge variant="secondary" className="animate-pulse bg-primary/20 text-primary border-none text-[10px]">Processing</Badge>
              ) : (status.solveError || status.classifyError || status.extractError) ? (
                <Badge variant="destructive" className="bg-destructive/20 text-destructive border-none text-[10px]">Attention Required</Badge>
              ) : (
                <Badge variant="secondary" className="bg-green-500/20 text-green-500 border-none text-[10px]">Ready</Badge>
              )}
            </div>

            <div className="grid grid-cols-1 gap-2.5">
              <ProgressLink
                label="Reading Question Text"
                isLoading={status.extracting}
                error={status.extractError}
                done={!status.extracting && !status.extractError && !!data.question_text}
                onRetry={onRetryExtract}
              />
              <ProgressLink
                label="Thinking through Solution"
                isLoading={status.solving}
                error={status.solveError}
                done={!status.solving && !status.solveError && !!data.solution}
                onRetry={onRetrySolve}
              />
              <ProgressLink
                label="Organizing by Subject"
                isLoading={status.classifying}
                error={status.classifyError}
                done={!status.classifying && !status.classifyError && data.subject !== 'Pending...'}
                onRetry={onRetryClassify}
              />
            </div>

            <Button
              className="w-full h-12 rounded-xl text-sm font-bold shadow-lg mt-2 ring-1 ring-white/10 hover:scale-[1.02] active:scale-95 transition-all"
              onClick={handleSave}
              disabled={isSaving || status.solving || status.classifying || status.extracting || !!status.extractError}
            >
              {isSaving ? (
                <><Loader2 className="h-4 w-4 mr-2 animate-spin" /> Adding to Bank...</>
              ) : (
                <><Check className="h-4 w-4 mr-2" /> Add to Question Bank</>
              )}
            </Button>
          </CardContent>
        </Card>

        {/* Classification Summary */}
        <Card className="border-none shadow-lg bg-card/40 backdrop-blur-sm ring-1 ring-white/5">
          <CardHeader className="pb-3 border-b border-border/40 flex flex-row items-center justify-between">
            <Label className="uppercase tracking-widest text-[10px] font-bold text-muted-foreground opacity-70">Classification</Label>
            {status.classifyError && <Button variant="ghost" size="icon" className="h-5 w-5 text-destructive" onClick={onRetryClassify}><AlertTriangle className="h-3 w-3" /></Button>}
          </CardHeader>
          <CardContent className="p-6 space-y-6">
            {status.classifyError ? (
              <div className="text-center py-4 space-y-2">
                <p className="text-[10px] text-destructive leading-tight px-4 font-medium">{status.classifyError}</p>
                <Button variant="link" className="h-auto p-0 text-[10px] text-primary" onClick={onRetryClassify}>Retry Classification</Button>
              </div>
            ) : status.classifying ? (
              <div className="space-y-4">
                <Skeleton className="h-5 w-3/4" />
                <Skeleton className="h-4 w-1/2" />
                <div className="flex gap-2"><Skeleton className="h-6 w-12" /><Skeleton className="h-6 w-16" /></div>
              </div>
            ) : (
              <SectionFade isLoaded={true}>
                <div className="space-y-6">
                  <div className="space-y-1.5">
                    <h3 className="text-lg font-bold text-primary/90 leading-tight">{displayData.subject || "Detecting..."}</h3>
                    <p className="text-xs text-muted-foreground font-medium leading-relaxed">{displayData.chapter}</p>
                  </div>

                  <div className="flex flex-wrap gap-2">
                    <Badge variant="outline" className="text-[10px] px-3 py-1 border-primary/20 bg-primary/5 uppercase">{displayData.type}</Badge>
                    <Badge className={`text-[10px] px-3 py-1 border uppercase ${difficultyColors[displayData.difficulty || 'medium']}`}>{displayData.difficulty || 'medium'}</Badge>
                  </div>

                  <div className="space-y-3">
                    <Label className="text-[10px] font-bold text-muted-foreground uppercase opacity-50">Related Topics</Label>
                    <div className="flex flex-wrap gap-1.5">
                      {(displayData.topics || []).map((topic) => (
                        <Badge key={topic} variant="secondary" className="text-[10px] bg-white/5 border-none font-normal px-2.5 py-1">{topic}</Badge>
                      ))}
                    </div>
                  </div>
                </div>
              </SectionFade>
            )}
          </CardContent>
        </Card>

        {/* Strategy Hint */}
        <Card className="border-none shadow-lg bg-yellow-500/[0.03] ring-1 ring-yellow-500/10">
          <CardHeader className="pb-2 border-b border-yellow-500/10">
            <Label className="uppercase tracking-widest text-[10px] font-bold text-yellow-600/70">Expert Hint / Strategy</Label>
          </CardHeader>
          <CardContent className="p-6">
            {status.solving ? (
              <Skeleton className="h-20 w-full" />
            ) : (
              <SectionFade isLoaded={true}>
                <div className="text-sm italic text-muted-foreground leading-relaxed border-l-4 border-yellow-500/20 pl-4 py-1">
                  <Latex>{displayData.hint || "Developing strategy..."}</Latex>
                </div>
              </SectionFade>
            )}
          </CardContent>
        </Card>

        {/* Duplicate Warning Overlay */}
        {data.duplicate_check?.is_duplicate && !status.finalizing && (
          <Alert variant="destructive" className="bg-yellow-500/10 text-yellow-600 border-yellow-500/50 rounded-xl shadow-inner animate-in slide-in-from-right-2">
            <AlertTriangle className="h-4 w-4" />
            <AlertTitle className="text-xs font-bold uppercase tracking-wide">Duplicate Match</AlertTitle>
            <AlertDescription className="text-xs mt-1.5 space-y-3">
              <p>This looks very similar to an existing entry. Use existing instead?</p>
              <div className="flex gap-4">
                <Button variant="link" size="sm" className="h-auto p-0 text-xs font-bold text-yellow-600 underline" onClick={handleLinkToExisting}>Merge Variant</Button>
                <Button variant="link" size="sm" className="h-auto p-0 text-xs text-muted-foreground underline" onClick={() => window.open(`/dashboard/questions/${data.duplicate_check?.matched_question_id}`, '_blank')}>Compare</Button>
              </div>
            </AlertDescription>
          </Alert>
        )}
      </div>
    </div>
  )
}
