'use client'

import { Latex } from '@/components/ui/latex'
import { cn } from '@/lib/utils'

interface SolutionStepsProps {
  content: string
  className?: string
}

export function SolutionSteps({ content, className }: SolutionStepsProps) {
  // Normalize literal \n into actual newlines if AI sends them as strings
  const normalizedContent = content.replace(/\\n/g, '\n')

  // Split content by double newlines or single newlines if they start with Step X
  // We filter out empty strings
  const rawSteps = normalizedContent.split(/\n\s*\n/).filter(step => step.trim().length > 0)

  return (
    <div className={cn("space-y-0", className)}>
      {rawSteps.map((stepContent, index) => {
        // Check if the step starts with a bold header like "**Step 1:**" or "Step 1:"
        const isExplicitStep = /^(?:\*\*|__)?(?:Step|Part|Phase)\s+\d+(?:[:.]|\s)(?:\*\*|__)?/i.test(stepContent.trim())

        return (
          <div key={index} className="relative pl-8 pb-12 last:pb-0 group">
            {/* Connector Line */}
            {index !== rawSteps.length - 1 && (
              <div
                className="absolute left-[11px] top-8 bottom-0 w-px bg-border group-hover:bg-primary/20 transition-colors"
                aria-hidden="true"
              />
            )}

            {/* Step Number/Bullet */}
            <div className={cn(
              "absolute left-0 top-[2px] h-6 w-6 rounded-full border flex items-center justify-center text-[10px] font-mono font-medium z-10 transition-colors shadow-sm",
              isExplicitStep
                ? "bg-primary text-primary-foreground border-primary"
                : "bg-background text-muted-foreground border-border group-hover:border-primary/50"
            )}>
              {index + 1}
            </div>

            {/* Content */}
            <div className="pt-0 min-w-0">
              <div className="prose dark:prose-invert max-w-none text-base leading-loose whitespace-pre-wrap">
                <Latex>{stepContent.trim()}</Latex>
              </div>
            </div>
          </div>
        )
      })}
    </div>
  )
}
