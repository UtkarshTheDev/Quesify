'use client'

import { useState } from 'react'
import { Sparkles, Loader2, SendHorizontal, Zap } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
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
  const [customPrompt, setCustomPrompt] = useState('')

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
      
      if (onComplexUpdate) {
        onComplexUpdate(data)
      } else {
        onContentChange(data.tweakedContent)
      }
      
      toast.success('Refined with AI')
      setCustomPrompt('')
    } catch {
      toast.error('Failed to update content')
    } finally {
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
          { label: 'Simplify', prompt: 'Simplify the explanation' },
          { label: 'Fix Grammar', prompt: 'Fix grammar and formatting' },
          { label: 'Professional', prompt: 'Make the tone professional and academic' },
          { label: 'Format LaTeX', prompt: 'Ensure all math is properly formatted with LaTeX' },
        ]
    }
  }

  const presets = getPresets()

  if (isLoading) {
    return (
      <div className={cn("rounded-xl border border-indigo-500/20 bg-indigo-500/5 p-4 animate-pulse flex items-center justify-center gap-3", className)}>
        <div className="relative">
          <div className="absolute inset-0 bg-indigo-500 blur-lg opacity-20 animate-pulse" />
          <Loader2 className="h-5 w-5 animate-spin text-indigo-500 relative z-10" />
        </div>
        <span className="text-xs font-bold text-indigo-500 uppercase tracking-widest">AI is Thinking...</span>
      </div>
    )
  }

  return (
    <div className={cn("rounded-xl border border-indigo-500/10 bg-gradient-to-br from-indigo-500/[0.02] via-purple-500/[0.02] to-pink-500/[0.02] p-4 space-y-4 relative overflow-hidden group transition-all hover:border-indigo-500/20 hover:shadow-lg hover:shadow-indigo-500/5", className)}>
      {/* Decorative gradient blur */}
      <div className="absolute -top-10 -right-10 w-20 h-20 bg-indigo-500/10 blur-2xl rounded-full opacity-0 group-hover:opacity-100 transition-opacity duration-700" />
      
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <div className="p-1.5 rounded-lg bg-gradient-to-br from-indigo-500 to-purple-600 shadow-md shadow-indigo-500/20">
            <Sparkles className="h-3 w-3 text-white" />
          </div>
          <span className="text-xs font-black text-foreground/80 uppercase tracking-widest">AI Copilot</span>
        </div>
        <div className="h-1.5 w-1.5 rounded-full bg-green-500 shadow-[0_0_8px_rgba(34,197,94,0.6)] animate-pulse" />
      </div>

      <div className="flex flex-wrap gap-2">
        {presets.map((preset) => (
          <button
            key={preset.label}
            onClick={() => handleTweak(preset.prompt)}
            className="h-7 px-3 text-[10px] font-bold uppercase tracking-wide rounded-full border border-indigo-500/10 bg-white/50 dark:bg-black/20 hover:bg-indigo-500/10 hover:border-indigo-500/30 hover:text-indigo-600 dark:hover:text-indigo-400 transition-all active:scale-95 flex items-center gap-1.5 backdrop-blur-sm"
          >
            <Zap className="h-3 w-3 opacity-60" />
            {preset.label}
          </button>
        ))}
      </div>

      <div className="relative group/input">
        <div className="absolute -inset-0.5 bg-gradient-to-r from-indigo-500/20 to-purple-500/20 rounded-xl blur opacity-0 group-focus-within/input:opacity-100 transition duration-500" />
        <div className="relative flex items-center bg-background rounded-lg border border-border/50 shadow-sm focus-within:ring-1 focus-within:ring-indigo-500/50">
          <Input
            value={customPrompt}
            onChange={(e) => setCustomPrompt(e.target.value)}
            placeholder="Ask AI to refine, explain, or format..."
            className="h-10 border-none bg-transparent shadow-none focus-visible:ring-0 text-xs px-3 placeholder:text-muted-foreground/60"
            onKeyDown={(e) => {
              if (e.key === 'Enter') handleTweak(customPrompt)
            }}
          />
          <Button
            size="icon"
            variant="ghost"
            className={`h-8 w-8 mr-1 rounded-md transition-all ${customPrompt ? 'text-indigo-500 bg-indigo-500/10 hover:bg-indigo-500/20' : 'text-muted-foreground/40'}`}
            onClick={() => handleTweak(customPrompt)}
            disabled={!customPrompt}
          >
            <SendHorizontal className="h-4 w-4" />
          </Button>
        </div>
      </div>
    </div>
  )
}
