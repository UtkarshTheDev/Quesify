'use client'

import { useState, useEffect, useRef } from 'react'
import { Send, Sparkles, Loader2, Maximize2, Minimize2 } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Textarea } from '@/components/ui/textarea'
import { Latex } from '@/components/ui/latex'
import { ScrollArea } from '@/components/ui/scroll-area'
import { cn } from '@/lib/utils'
import type { Question, Solution } from '@/lib/types'

interface Message {
  role: 'user' | 'assistant'
  content: string
  id: string
}

interface AIChatTabProps {
  question: Question & { solutions: Solution[] }
  userId: string | null
}

export function AIChatTab({ question, userId }: AIChatTabProps) {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: 'welcome',
      role: 'assistant',
      content: "Hello! I'm your AI study helper. I can help explain this question, break down the solution, or answer any doubts you might have. What's on your mind?"
    }
  ])
  const [input, setInput] = useState('')
  const [isLoading, setIsLoading] = useState(false)
  const [isFullScreen, setIsFullScreen] = useState(false)
  const scrollRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight
    }
  }, [messages])

  // Hide main document scroll when in full screen
  useEffect(() => {
    if (isFullScreen) {
      document.body.style.overflow = 'hidden'
    } else {
      document.body.style.overflow = ''
    }
    return () => {
      document.body.style.overflow = ''
    }
  }, [isFullScreen])

  const handleSubmit = async (e?: React.FormEvent) => {
    e?.preventDefault()
    if (!input.trim() || isLoading) return

    const userMessage: Message = {
      id: Date.now().toString(),
      role: 'user',
      content: input.trim()
    }

    setMessages(prev => [...prev, userMessage])
    setInput('')
    setIsLoading(true)

    try {
      const response = await fetch('/api/questions/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          message: userMessage.content,
          questionContext: {
            text: question.question_text,
            subject: question.subject,
            chapter: question.chapter,
            solution: question.solutions[0]?.solution_text || ''
          }
        })
      })

      if (!response.ok) throw new Error('Failed to get response')

      const data = await response.json()
      
      const aiMessage: Message = {
        id: (Date.now() + 1).toString(),
        role: 'assistant',
        content: data.reply
      }

      setMessages(prev => [...prev, aiMessage])
    } catch (error) {
      console.error('Chat error:', error)
      const errorMessage: Message = {
        id: (Date.now() + 1).toString(),
        role: 'assistant',
        content: "I'm sorry, I encountered an error while processing your request. Please try again."
      }
      setMessages(prev => [...prev, errorMessage])
    } finally {
      setIsLoading(false)
    }
  }

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault()
      handleSubmit()
    }
  }

  return (
    <div className={cn(
      "flex flex-col bg-background/95 backdrop-blur-sm border border-border/50 overflow-hidden transition-all duration-300",
      isFullScreen 
        ? "fixed inset-0 z-50 rounded-none h-full w-full" 
        : "h-[600px] md:h-[600px] h-[calc(100vh-280px)] min-h-[400px] rounded-xl bg-muted/5"
    )}>
      {/* Header (Visible only in full screen usually, but useful for toggle) */}
      <div className={cn(
        "flex items-center justify-between px-4 py-3 border-b bg-background/50 backdrop-blur-sm sticky top-0 z-20",
        !isFullScreen && "hidden md:flex" 
      )}>
        <div className="flex items-center gap-2">
          <Sparkles className="h-4 w-4 text-orange-600" />
          <span className="text-sm font-semibold text-foreground/80">AI Study Assistant</span>
        </div>
        <Button 
          variant="ghost" 
          size="sm" 
          className="h-8 w-8 p-0 rounded-full hover:bg-muted"
          onClick={() => setIsFullScreen(!isFullScreen)}
        >
          {isFullScreen ? <Minimize2 className="h-4 w-4" /> : <Maximize2 className="h-4 w-4" />}
        </Button>
      </div>

      {/* Floating Toggle for Mobile (when not full screen) */}
      {!isFullScreen && (
        <Button 
          variant="ghost" 
          size="sm" 
          className="absolute top-2 right-2 h-8 w-8 p-0 rounded-full hover:bg-muted md:hidden z-20"
          onClick={() => setIsFullScreen(true)}
        >
          <Maximize2 className="h-4 w-4 text-muted-foreground" />
        </Button>
      )}

      {/* Chat Area */}
      <ScrollArea className="flex-1 p-4 overflow-y-auto" ref={scrollRef}>
        <div className="space-y-8 max-w-3xl mx-auto pb-4">
          {messages.map((msg) => (
            <div
              key={msg.id}
              className={cn(
                "flex flex-col gap-1 w-full",
                msg.role === 'user' ? "items-end" : "items-start"
              )}
            >
              <div className={cn(
                "flex-1 rounded-2xl px-4 py-3 md:px-5 md:py-3 text-sm leading-relaxed shadow-sm w-full",
                msg.role === 'assistant'
                  ? "bg-transparent text-foreground pl-0 shadow-none max-w-full"
                  : "bg-orange-600 text-white rounded-tr-sm shadow-md shadow-orange-600/10 max-w-[90%] md:max-w-[85%] ml-auto"
              )}>
                <div className={cn(
                  "prose prose-sm max-w-none font-charter",
                  msg.role === 'assistant' 
                    ? "dark:prose-invert prose-headings:text-foreground prose-a:text-orange-600 prose-p:leading-relaxed" 
                    : "text-white prose-invert prose-p:text-white prose-headings:text-white"
                )}>
                  <Latex>{msg.content}</Latex>
                </div>
              </div>
            </div>
          ))}
          
          {isLoading && (
            <div className="mr-auto items-start pl-0">
              <div className="flex items-center gap-2 text-muted-foreground">
                <Sparkles className="h-4 w-4 animate-pulse text-orange-600" />
                <span className="text-xs font-medium animate-pulse">Thinking...</span>
              </div>
            </div>
          )}
        </div>
      </ScrollArea>

      {/* Input Area */}
      <div className="p-3 md:p-4 bg-background/80 backdrop-blur-md border-t sticky bottom-0 z-30 pb- safe-area-bottom">
        <div className="max-w-3xl mx-auto relative mb-16 md:mb-0">
          <form 
            onSubmit={handleSubmit}
            className="relative flex items-end gap-2 bg-muted/50 hover:bg-muted/70 focus-within:bg-background p-1.5 rounded-[26px] border border-transparent focus-within:border-orange-500/20 focus-within:ring-4 focus-within:ring-orange-500/5 transition-all duration-300 shadow-sm"
          >
            <div className="pl-3 py-3 text-orange-500/50 hidden md:block">
              <Sparkles className="h-5 w-5" />
            </div>
            
            <Textarea
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={handleKeyDown}
              placeholder="Ask anything..."
              className="min-h-[44px] max-h-[150px] resize-none border-0 bg-transparent focus-visible:ring-0 px-3 py-3 text-sm shadow-none scrollbar-hide placeholder:text-muted-foreground/60"
              rows={1}
            />
            
            <Button 
              type="submit" 
              size="icon"
              disabled={!input.trim() || isLoading}
              className={cn(
                "h-9 w-9 rounded-full shrink-0 transition-all duration-300 mb-1 mr-1",
                input.trim() 
                  ? "bg-orange-600 text-white hover:bg-orange-700 shadow-md shadow-orange-500/20 transform hover:scale-105" 
                  : "bg-muted text-muted-foreground hover:bg-muted/80"
              )}
            >
              <Send className="h-4 w-4 ml-0.5" />
            </Button>
          </form>
          <div className="text-center mt-2 hidden md:block">
            <p className="text-[10px] text-muted-foreground/40 font-medium uppercase tracking-widest">
              AI can make mistakes. Check important info.
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}
