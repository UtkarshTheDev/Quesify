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
  
  // Callbacks for parent components to handle streaming states if needed
  const onStreamStart = () => {} 
  const onStreamEnd = () => {}

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
    
    // 10x faster: 5ms delay and 8 chars per frame
    const speed = 5
    const charsPerFrame = 8

    return new Promise<void>((resolve) => {
      const interval = setInterval(() => {
        // Append multiple characters at once for high-speed feel
        currentText += fullText.slice(index, index + charsPerFrame)
        onContentChange(currentText)
        
        index += charsPerFrame

        if (index >= fullText.length) {
          clearInterval(interval)
          setIsStreaming(false)
          
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
          <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-orange-400 opacity-75"></span>
          <span className="relative inline-flex rounded-full h-3 w-3 bg-orange-500"></span>
        </div>
        <span className="text-xs font-semibold text-muted-foreground tracking-wide animate-pulse">
          {isStreaming ? "AI is writing..." : "AI is working on it..."}
        </span>
      </div>
    )
  }

  return (
    <div className={cn("space-y-4 pt-5 sm:pt-4 border-t border-border/40", className)}>
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <div className="flex items-center justify-center w-6 h-6 rounded-md bg-orange-100 dark:bg-orange-900/30 text-orange-600 dark:text-orange-400 ring-1 ring-orange-500/20">
            <Sparkles className="h-3.5 w-3.5" />
          </div>
          <span className="text-[10px] sm:text-xs font-black text-foreground/80 tracking-widest uppercase">AI Copilot</span>
        </div>
      </div>

      {/* Preset Action Chips */}
      <div className="flex flex-wrap gap-2 sm:gap-3">
        {presets.map((preset) => (
          <button
            key={preset.label}
            onClick={() => handleTweak(preset.prompt)}
            className="group flex items-center gap-2 px-3.5 py-2 h-9 sm:h-9 sm:px-3 sm:py-1.5 text-xs sm:text-[11px] font-bold bg-background border border-border/60 hover:border-orange-500/30 hover:bg-orange-50/50 dark:hover:bg-orange-900/20 rounded-xl sm:rounded-lg transition-all active:scale-95 shadow-sm hover:shadow-orange-500/5 text-muted-foreground hover:text-orange-600 dark:hover:text-orange-400"
          >
            <preset.icon className="h-3.5 w-3.5 opacity-60 group-hover:opacity-100 transition-opacity" />
            {preset.label}
          </button>
        ))}
      </div>

      {/* Command Input */}
      <div className="relative group">
        <div className="absolute -inset-0.5 bg-gradient-to-r from-orange-500/10 to-amber-500/10 rounded-xl blur opacity-20 group-focus-within:opacity-100 transition duration-500" />
        <div className="relative flex flex-col items-stretch bg-orange-500/[0.03] hover:bg-orange-500/[0.05] focus-within:bg-background rounded-xl border border-orange-500/10 focus-within:border-orange-500/30 transition-all duration-200 p-1.5">
          <Textarea
            ref={textareaRef}
            value={customPrompt}
            onChange={(e) => setCustomPrompt(e.target.value)}
            placeholder="Ask AI to rewrite, explain, or format..."
            className="min-h-[60px] sm:min-h-[44px] max-h-[120px] py-3 sm:py-2.5 border-none bg-transparent shadow-none focus-visible:ring-0 text-[13px] sm:text-sm px-3 placeholder:text-muted-foreground/60 resize-none overflow-y-auto"
            onKeyDown={(e) => {
              if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault()
                handleTweak(customPrompt)
              }
            }}
          />
          <div className="flex mt-1.5">
            <Button
              className={cn(
                "h-11 w-full font-black text-[10px] uppercase tracking-widest rounded-xl transition-all duration-300 gap-2.5", 
                customPrompt 
                  ? "bg-orange-600 text-white hover:bg-orange-500 shadow-lg shadow-orange-500/30" 
                  : "bg-orange-500/5 text-orange-500/40 border border-orange-500/10"
              )}
              onClick={() => handleTweak(customPrompt)}
              disabled={!customPrompt}
            >
              <span>Send Request</span>
              <SendHorizontal className="h-3.5 w-3.5" />
            </Button>
          </div>
        </div>
      </div>
    </div>
  )
}
