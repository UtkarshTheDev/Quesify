'use client'

import { Lock, Sparkles } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Card, CardContent } from '@/components/ui/card'

interface RevealSolutionPlaceholderProps {
  onReveal: () => void
  solutionCount: number
}

export function RevealSolutionPlaceholder({ onReveal, solutionCount }: RevealSolutionPlaceholderProps) {
  return (
    <Card className="relative overflow-hidden border-dashed border-2 border-primary/20 bg-gradient-to-br from-background to-muted/30 animate-in fade-in zoom-in-95 duration-500">
      <div className="absolute inset-0 opacity-[0.03]" style={{ backgroundImage: `radial-gradient(circle at 2px 2px, currentColor 1px, transparent 0)`, backgroundSize: '24px 24px' }} />
      <CardContent className="flex flex-col items-center justify-center py-16 text-center relative z-10">
        <div className="h-16 w-16 rounded-2xl bg-primary/10 flex items-center justify-center mb-6 ring-4 ring-primary/5 shadow-xl shadow-primary/10 backdrop-blur-sm animate-pulse">
          <Lock className="h-8 w-8 text-primary" />
        </div>
        
        <h3 className="text-2xl font-bold tracking-tight mb-2">
          Solution Locked
        </h3>
        
        <p className="text-muted-foreground max-w-sm mb-8">
          Give it a try first! Solving it yourself builds stronger understanding. Reveal when you're ready to check.
        </p>

        <Button 
          onClick={onReveal} 
          size="lg" 
          className="group relative overflow-hidden px-8 py-6 text-lg font-semibold shadow-lg shadow-primary/20 transition-all hover:shadow-primary/40 hover:scale-105"
        >
          <div className="absolute inset-0 bg-gradient-to-r from-primary/0 via-white/20 to-primary/0 translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700" />
          <Sparkles className="mr-2 h-5 w-5 transition-transform group-hover:rotate-12" />
          Reveal Solution
        </Button>
      </CardContent>
    </Card>
  )
}
