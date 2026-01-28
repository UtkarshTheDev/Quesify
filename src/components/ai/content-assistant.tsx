'use client'

import { useState } from 'react'
import { Sparkles, Loader2, SendHorizontal } from 'lucide-react'
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
      <div className={cn("flex items-center gap-2 text-xs text-muted-foreground animate-pulse py-2", className)}>
        <Loader2 className="h-3 w-3 animate-spin" />
        <span>AI is refining...</span>
      </div>
    )
  }

  return (
    <div className={cn("space-y-3 pt-2", className)}>
      <div className="flex items-center gap-2">
        <Sparkles className="h-3.5 w-3.5 text-muted-foreground" />
        <span className="text-xs font-medium text-muted-foreground">AI Assistant</span>
      </div>

      <div className="flex flex-wrap gap-2">
        {presets.map((preset) => (
          <Button
            key={preset.label}
            variant="outline"
            size="sm"
            onClick={() => handleTweak(preset.prompt)}
            className="h-7 text-xs bg-background hover:bg-muted"
          >
            {preset.label}
          </Button>
        ))}
      </div>

      <div className="relative">
        <Input
          value={customPrompt}
          onChange={(e) => setCustomPrompt(e.target.value)}
          placeholder="Ask AI to..."
          className="h-9 pr-8 text-sm"
          onKeyDown={(e) => {
            if (e.key === 'Enter') handleTweak(customPrompt)
          }}
        />
        <Button
          size="icon"
          variant="ghost"
          className="absolute right-0 top-0 h-9 w-9 text-muted-foreground hover:text-foreground"
          onClick={() => handleTweak(customPrompt)}
          disabled={!customPrompt}
        >
          <SendHorizontal className="h-4 w-4" />
        </Button>
      </div>
    </div>
  )
}
