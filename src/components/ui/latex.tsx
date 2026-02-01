'use client'

import ReactMarkdown from 'react-markdown'
import remarkMath from 'remark-math'
import rehypeKatex from 'rehype-katex'
import 'katex/dist/katex.min.css'
import { cn } from '@/lib/utils'

interface LatexProps {
  children?: string | null
  className?: string
}

export function Latex({ children, className }: LatexProps) {
  if (!children) return null
  const content = typeof children === 'string' ? children : String(children)

  return (
    <div className={cn(
      "prose dark:prose-invert max-w-none prose-headings:text-foreground prose-p:text-foreground prose-strong:text-foreground prose-ul:text-foreground prose-ol:text-foreground",
      "[&_.katex-display]:overflow-x-auto [&_.katex-display]:overflow-y-hidden [&_.katex-display]:py-4 [&_.katex-display]:my-2",
      className
    )}>
      <ReactMarkdown
        remarkPlugins={[remarkMath]}
        rehypePlugins={[rehypeKatex]}
        components={{
          code({ inline, children }: React.HTMLAttributes<HTMLElement> & { inline?: boolean }) {
            return !inline ? (
              <pre className="bg-slate-900/70 rounded-xl p-4 border border-slate-700 overflow-x-auto my-4">
                <code className="text-sm font-mono text-slate-200">{children}</code>
              </pre>
            ) : (
              <code className="bg-slate-900/50 px-1.5 py-0.5 rounded text-xs font-mono border border-slate-700 text-slate-200">{children}</code>
            )
          }
        }}
      >
        {content}
      </ReactMarkdown>
    </div>
  )
}

export function LatexBlock({ children, className }: { children?: string | null, className?: string }) {
  return <Latex className={className}>{children}</Latex>
}
