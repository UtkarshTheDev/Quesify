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
          code({ node, inline, className, children, ...props }: any) {
            const match = /language-(\w+)/.exec(className || '');
            return !inline ? (
              <pre className="bg-slate-900/70 rounded-xl p-4 border border-slate-700 overflow-x-auto my-4">
                <code className="text-sm font-mono text-slate-200">{children}</code>
              </pre>
            ) : (
              <code className="bg-slate-900/50 px-1.5 py-0.5 rounded text-xs font-mono border border-slate-700 text-slate-200">{children}</code>
            );
          },
          p: ({ children }) => <p className="mb-4 leading-relaxed last:mb-0">{children}</p>,
          blockquote: ({ children }) => (
            <blockquote className="border-l-4 border-indigo-500 pl-6 italic bg-slate-900/50 py-4 my-6 rounded-r-xl">
              {children}
            </blockquote>
          )
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
