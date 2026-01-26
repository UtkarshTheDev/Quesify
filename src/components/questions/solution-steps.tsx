'use client'

import { Latex } from '@/components/ui/latex'
import { cn } from '@/lib/utils'

interface SolutionStepsProps {
  content: string
  className?: string
}

export function SolutionSteps({ content, className }: SolutionStepsProps) {
  // Split content by double newlines to get potential steps
  // We filter out empty strings
  const rawSteps = content.split(/\n\s*\n/).filter(step => step.trim().length > 0)

  // Improved step detection:
  // Sometimes "Step 1" might be inline.
  // For now, we'll treat each paragraph as a meaningful chunk/step.

  return (
    <div className={cn("space-y-0", className)}>
      {rawSteps.map((stepContent, index) => {
        // Check if the step starts with a bold header like "**Step 1:**" or "**Analysis:**"
        // Regex looks for: Start of string, optional markup, "Step/Part/Phase" word, number, separator
        const isExplicitStep = /^(?:\*\*|__)?(?:Step|Part|Phase)\s+\d+(?:[:.]|\s)(?:\*\*|__)?/i.test(stepContent)

        return (
          <div key={index} className="relative pl-8 pb-8 last:pb-0 group">
            {/* Connector Line - only show if not the last item */}
            {index !== rawSteps.length - 1 && (
              <div
                className="absolute left-[11px] top-8 bottom-0 w-px bg-border group-hover:bg-primary/20 transition-colors"
                aria-hidden="true"
              />
            )}

            {/* Step Number/Bullet */}
            <div className={cn(
              "absolute left-0 top-0 h-6 w-6 rounded-full border flex items-center justify-center text-[10px] font-mono font-medium z-10 transition-colors shadow-sm",
              isExplicitStep
                ? "bg-primary text-primary-foreground border-primary"
                : "bg-background text-muted-foreground border-border group-hover:border-primary/50"
            )}>
              {index + 1}
            </div>

            {/* Content */}
            <div className="pt-0.5 min-w-0">
              <div className="prose dark:prose-invert max-w-none text-sm">
                <Latex>{stepContent}</Latex>
              </div>
            </div>
          </div>
        )
      })}
    </div>
  )
}
