'use client'

import 'katex/dist/katex.min.css'
import { InlineMath, BlockMath } from 'react-katex'

interface LatexProps {
  children: string
  block?: boolean
}

export function Latex({ children }: LatexProps) {
  // Split text by LaTeX delimiters and render
  const parts = children.split(/(\$\$[\s\S]*?\$\$|\$[^$]*?\$)/g)

  return (
    <span>
      {parts.map((part, index) => {
        if (part.startsWith('$$') && part.endsWith('$$')) {
          const math = part.slice(2, -2)
          return <BlockMath key={index} math={math} />
        }
        if (part.startsWith('$') && part.endsWith('$')) {
          const math = part.slice(1, -1)
          return <InlineMath key={index} math={math} />
        }
        return <span key={index}>{part}</span>
      })}
    </span>
  )
}

export function LatexBlock({ children }: { children: string }) {
  return <Latex block>{children}</Latex>
}
