'use client'

import { useState, useEffect, useRef } from 'react'
import { Send, Bot, User, Sparkles, Loader2 } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Card, CardContent } from '@/components/ui/card'
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
  const scrollRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight
    }
  }, [messages])

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
    <div className="h-[600px] flex flex-col bg-muted/5 rounded-xl border border-border/50 overflow-hidden">
      {/* Chat Area */}
      <ScrollArea className="flex-1 p-4" ref={scrollRef}>
        <div className="space-y-6 max-w-3xl mx-auto">
          {messages.map((msg) => (
            <div
              key={msg.id}
              className={cn(
                "flex gap-4",
                msg.role === 'user' ? "flex-row-reverse" : "flex-row"
              )}
            >
              <div className={cn(
                "h-8 w-8 rounded-full flex items-center justify-center shrink-0 border shadow-sm",
                msg.role === 'assistant' 
                  ? "bg-primary/10 border-primary/20 text-primary" 
                  : "bg-muted border-border text-muted-foreground"
              )}>
                {msg.role === 'assistant' ? <Bot className="h-4 w-4" /> : <User className="h-4 w-4" />}
              </div>
              
              <div className={cn(
                "flex-1 max-w-[80%] rounded-2xl px-5 py-3 text-sm leading-relaxed shadow-sm",
                msg.role === 'assistant'
                  ? "bg-card border border-border/50 text-foreground rounded-tl-none"
                  : "bg-primary text-primary-foreground rounded-tr-none"
              )}>
                <div className={cn(
                  "prose prose-sm max-w-none break-words font-charter",
                  msg.role === 'assistant' ? "dark:prose-invert" : "text-primary-foreground prose-invert"
                )}>
                  <Latex>{msg.content}</Latex>
                </div>
              </div>
            </div>
          ))}
          
          {isLoading && (
            <div className="flex gap-4">
              <div className="h-8 w-8 rounded-full bg-primary/10 border border-primary/20 text-primary flex items-center justify-center shrink-0">
                <Bot className="h-4 w-4" />
              </div>
              <div className="bg-card border border-border/50 rounded-2xl rounded-tl-none px-5 py-4 flex items-center gap-2">
                <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />
                <span className="text-xs text-muted-foreground font-medium animate-pulse">Thinking...</span>
              </div>
            </div>
          )}
        </div>
      </ScrollArea>

      {/* Input Area */}
      <div className="p-4 bg-background border-t">
        <div className="max-w-3xl mx-auto relative">
          <form 
            onSubmit={handleSubmit}
            className="relative flex items-end gap-2 bg-muted/30 p-2 rounded-3xl border border-border/50 focus-within:border-primary/30 focus-within:ring-4 focus-within:ring-primary/5 transition-all"
          >
            <div className="pl-3 py-3 text-muted-foreground/50">
              <Sparkles className="h-5 w-5" />
            </div>
            
            <Textarea
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={handleKeyDown}
              placeholder="Ask a follow-up question..."
              className="min-h-[20px] max-h-[150px] resize-none border-0 bg-transparent focus-visible:ring-0 px-2 py-3 text-sm shadow-none scrollbar-hide placeholder:text-muted-foreground/50"
              rows={1}
            />
            
            <Button 
              type="submit" 
              size="icon"
              disabled={!input.trim() || isLoading}
              className={cn(
                "h-10 w-10 rounded-full shrink-0 transition-all duration-300",
                input.trim() 
                  ? "bg-primary text-primary-foreground hover:bg-primary/90 shadow-md" 
                  : "bg-muted text-muted-foreground hover:bg-muted/80"
              )}
            >
              <Send className="h-4 w-4 ml-0.5" />
            </Button>
          </form>
          <div className="text-center mt-2">
            <p className="text-[10px] text-muted-foreground/40 font-medium uppercase tracking-widest">
              AI can make mistakes. Check important info.
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}
