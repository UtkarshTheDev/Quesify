'use client'

import 'katex/dist/katex.min.css'
import { InlineMath, BlockMath } from 'react-katex'

interface LatexProps {
  children?: string | null
  block?: boolean
}

export function Latex({ children }: LatexProps) {
  if (!children) return null
  if (typeof children !== 'string') return <span>{String(children)}</span>

  // Resolve literal \n strings into actual newline characters
  const resolvedContent = children.replace(/\\n/g, '\n')

  // Split text by LaTeX delimiters and render
  const parts = resolvedContent.split(/(\$\$[\s\S]*?\$\$|\$[^$]*?\$)/g)

  return (
    <span className="whitespace-pre-wrap">
      {parts.map((part, index) => {
        if (part.startsWith('$$') && part.endsWith('$$')) {
          const math = part.slice(2, -2).trim()
          return (
            <div key={index} className="my-6 overflow-x-auto py-2">
              <BlockMath math={math} />
            </div>
          )
        }
        if (part.startsWith('$') && part.endsWith('$')) {
          const math = part.slice(1, -1).trim()
          return (
            <span key={index} className="inline-block px-1 py-0.5">
              <InlineMath math={math} />
            </span>
          )
        }

        // Handle bold text in non-math parts
        const subParts = part.split(/(\*\*.*?\*\*|__.*?__)/g)
        return (
          <span key={index}>
            {subParts.map((subPart, subIndex) => {
              if (
                (subPart.startsWith('**') && subPart.endsWith('**')) ||
                (subPart.startsWith('__') && subPart.endsWith('__'))
              ) {
                return (
                  <strong key={subIndex} className="font-bold text-foreground">
                    {subPart.slice(2, -2)}
                  </strong>
                )
              }
              return subPart
            })}
          </span>
        )
      })}
    </span>
  )
}

export function LatexBlock({ children }: { children?: string | null }) {
  return <Latex block>{children}</Latex>
}
