'use client'

import { useState, useRef, useEffect } from 'react'
import { Sparkles, Loader2, SendHorizontal, Zap, Wand2, Type, GraduationCap, Calculator } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Textarea } from '@/components/ui/textarea'
import { toast } from 'sonner'
import { cn } from '@/lib/utils'

interface AIContentAssistantProps {
  content: string
  contentType: 'solution' | 'hint' | 'question'
  onContentChange: (newContent: string) => void
  onComplexUpdate?: (data: { tweakedContent: string, syncedApproach?: string | null }) => void
  className?: string
}

export function AIContentAssistant({ 
  content, 
  contentType, 
  onContentChange, 
  onComplexUpdate,
  className 
}: AIContentAssistantProps) {
  const [isLoading, setIsLoading] = useState(false)
  const [isStreaming, setIsStreaming] = useState(false)
  const [customPrompt, setCustomPrompt] = useState('')
  const textareaRef = useRef<HTMLTextAreaElement>(null)

  // Auto-resize textarea
  useEffect(() => {
    const textarea = textareaRef.current
    if (textarea) {
      textarea.style.height = 'auto'
      textarea.style.height = `${Math.min(textarea.scrollHeight, 120)}px`
    }
  }, [customPrompt])

  const streamText = async (fullText: string, syncedApproach?: string | null) => {
    setIsStreaming(true)
    let currentText = ""
    let index = 0
    
    // Dynamic speed based on length (faster for longer texts)
    // Base speed: ~30ms per char. Min 10ms, Max 50ms.
    const speed = Math.max(10, Math.min(30, 1500 / fullText.length))

    return new Promise<void>((resolve) => {
      const interval = setInterval(() => {
        currentText += fullText[index] || ""
        
        // We update the parent on every frame.
        // Since we are in the "Edit" tab (textarea), this is cheap.
        // The expensive Latex component is in the (hidden) Preview tab.
        onContentChange(currentText)
        
        index++

        if (index >= fullText.length) {
          clearInterval(interval)
          setIsStreaming(false)
          
          // Final sync with complex update if needed
          if (onComplexUpdate && syncedApproach) {
            onComplexUpdate({ tweakedContent: fullText, syncedApproach })
          } else {
            onContentChange(fullText)
          }
          resolve()
        }
      }, speed)
    })
  }

  const handleTweak = async (instruction: string) => {
    if (!instruction) return

    setIsLoading(true)
    try {
      const response = await fetch('/api/ai/tweak', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          originalContent: content,
          contentType,
          instruction: instruction
        }),
      })

      if (!response.ok) throw new Error('Failed to tweak content')

      const data = await response.json()
      
      // Start fake streaming
      setIsLoading(false) // Stop "Thinking" state
      await streamText(data.tweakedContent, data.syncedApproach)
      
      toast.success('Refined with AI')
      setCustomPrompt('')
    } catch {
      toast.error('Failed to update content')
      setIsLoading(false)
    }
  }

  const getPresets = () => {
    switch (contentType) {
      case 'question':
      case 'solution':
      case 'hint':
      default:
        return [
          { label: 'Simplify Logic', prompt: 'Simplify the explanation', icon: Wand2 },
          { label: 'Fix Grammar', prompt: 'Fix grammar and formatting', icon: Type },
          { label: 'Make Professional', prompt: 'Make the tone professional and academic', icon: GraduationCap },
          { label: 'Fix LaTeX', prompt: 'Ensure all math is properly formatted with LaTeX', icon: Calculator },
        ]
    }
  }

  const presets = getPresets()

  if (isLoading || isStreaming) {
    return (
      <div className={cn("w-full py-3 flex items-center justify-center gap-3 bg-muted/30 rounded-xl border border-border/50", className)}>
        <div className="relative flex h-3 w-3">
          <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-indigo-400 opacity-75"></span>
          <span className="relative inline-flex rounded-full h-3 w-3 bg-indigo-500"></span>
        </div>
        <span className="text-xs font-semibold text-muted-foreground tracking-wide animate-pulse">
          {isStreaming ? "AI is writing..." : "AI is working on it..."}
        </span>
      </div>
    )
  }

  return (
    <div className={cn("space-y-4 pt-4 border-t border-border/40", className)}>
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <div className="flex items-center justify-center w-6 h-6 rounded-md bg-indigo-100 dark:bg-indigo-900/30 text-indigo-600 dark:text-indigo-400 ring-1 ring-indigo-500/20">
            <Sparkles className="h-3.5 w-3.5" />
          </div>
          <span className="text-xs font-bold text-foreground/80 tracking-tight">AI Copilot</span>
        </div>
      </div>

      {/* Preset Action Chips */}
      <div className="flex flex-wrap gap-2">
        {presets.map((preset) => (
          <button
            key={preset.label}
            onClick={() => handleTweak(preset.prompt)}
            className="group flex items-center gap-2 px-3 py-1.5 h-8 text-[11px] font-semibold bg-background border border-border/60 hover:border-indigo-500/30 hover:bg-indigo-50/50 dark:hover:bg-indigo-900/20 rounded-lg transition-all active:scale-95 shadow-sm hover:shadow-indigo-500/5 text-muted-foreground hover:text-indigo-600 dark:hover:text-indigo-400"
          >
            <preset.icon className="h-3.5 w-3.5 opacity-60 group-hover:opacity-100 transition-opacity" />
            {preset.label}
          </button>
        ))}
      </div>

      {/* Command Input */}
      <div className="relative group">
        <div className="absolute -inset-0.5 bg-gradient-to-r from-indigo-500/10 to-purple-500/10 rounded-xl blur opacity-0 group-focus-within:opacity-100 transition duration-500" />
        <div className="relative flex items-center bg-muted/30 hover:bg-muted/50 focus-within:bg-background rounded-xl border border-transparent focus-within:border-indigo-500/30 transition-all duration-200 p-1">
          <Textarea
            ref={textareaRef}
            value={customPrompt}
            onChange={(e) => setCustomPrompt(e.target.value)}
            placeholder="Ask AI to rewrite, explain, or format..."
            className="min-h-[44px] max-h-[120px] py-2.5 border-none bg-transparent shadow-none focus-visible:ring-0 text-sm px-3 placeholder:text-muted-foreground/50 resize-none overflow-y-auto"
            onKeyDown={(e) => {
              if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault()
                handleTweak(customPrompt)
              }
            }}
          />
          <div className="flex items-end self-end pb-1 pr-1">
            <Button
              size="icon"
              variant="ghost"
              className={cn(
                "h-8 w-8 rounded-lg transition-all duration-200", 
                customPrompt 
                  ? "bg-indigo-600 text-white hover:bg-indigo-500 shadow-md shadow-indigo-500/20" 
                  : "text-muted-foreground/30 hover:bg-transparent"
              )}
              onClick={() => handleTweak(customPrompt)}
              disabled={!customPrompt}
            >
              <SendHorizontal className="h-4 w-4" />
            </Button>
          </div>
        </div>
      </div>
    </div>
  )
}
