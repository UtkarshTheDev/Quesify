'use client'

import { useState } from 'react'
import { Sparkles, Loader2, Send } from 'lucide-react'
import { Button } from '@/components/ui/button'
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from '@/components/ui/popover'
import { Input } from '@/components/ui/input'
import { toast } from 'sonner'

interface AIContentAssistantProps {
  content: string
  contentType: 'solution' | 'hint' | 'question'
  onContentChange: (newContent: string) => void
}

export function AIContentAssistant({ content, contentType, onContentChange }: AIContentAssistantProps) {
  const [isOpen, setIsOpen] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const [instruction, setInstruction] = useState('')

  const handleTweak = async (customInstruction?: string) => {
    const prompt = customInstruction || instruction
    if (!prompt) return

    setIsLoading(true)
    try {
      const response = await fetch('/api/ai/tweak', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          originalContent: content,
          contentType,
          instruction: prompt
        }),
      })

      if (!response.ok) throw new Error('Failed to tweak content')

      const data = await response.json()
      onContentChange(data.tweakedContent)
      toast.success('Content updated by AI')
      setIsOpen(false)
      setInstruction('')
    } catch (error) {
      toast.error('Failed to update content')
    } finally {
      setIsLoading(false)
    }
  }

  const presets = [
    { label: 'Simplify', prompt: 'Simplify the explanation' },
    { label: 'Fix Grammar', prompt: 'Fix grammar and formatting' },
    { label: 'More Detailed', prompt: 'Add more details and steps' },
    { label: 'To Bullet Points', prompt: 'Convert to bullet points' },
  ]

  return (
    <Popover open={isOpen} onOpenChange={setIsOpen}>
      <PopoverTrigger asChild>
        <Button variant="outline" size="sm" className="gap-2 h-8">
          <Sparkles className="h-3.5 w-3.5 text-purple-500" />
          <span className="text-xs">AI Assist</span>
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-80" align="start">
        <div className="space-y-4">
          <div className="space-y-2">
            <h4 className="font-medium text-sm leading-none">Modify with AI</h4>
            <p className="text-xs text-muted-foreground">
              Choose a preset or type your own instruction.
            </p>
          </div>

          <div className="grid grid-cols-2 gap-2">
            {presets.map((preset) => (
              <Button
                key={preset.label}
                variant="secondary"
                size="sm"
                className="text-xs h-7"
                onClick={() => handleTweak(preset.prompt)}
                disabled={isLoading}
              >
                {preset.label}
              </Button>
            ))}
          </div>

          <div className="flex gap-2">
            <Input
              placeholder="e.g. 'Make it shorter'"
              value={instruction}
              onChange={(e) => setInstruction(e.target.value)}
              className="h-8 text-xs"
              onKeyDown={(e) => {
                if (e.key === 'Enter') handleTweak()
              }}
            />
            <Button
              size="sm"
              className="h-8 w-8 p-0"
              onClick={() => handleTweak()}
              disabled={isLoading || !instruction}
            >
              {isLoading ? (
                <Loader2 className="h-3 w-3 animate-spin" />
              ) : (
                <Send className="h-3 w-3" />
              )}
            </Button>
          </div>
        </div>
      </PopoverContent>
    </Popover>
  )
}
