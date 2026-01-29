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

  // Recursive renderer to handle nested bold/math
  const renderLatex = (text: string): React.ReactNode[] => {
    const parts = text.split(/(\$\$[\s\S]*?\$\$|\$[^$]*?\$|\*\*[\s\S]*?\*\*|__[\s\S]*?__)/g)

    return parts.map((part, index) => {
      if (!part) return null

      if (part.startsWith('$$') && part.endsWith('$$')) {
        const math = part.slice(2, -2).trim()
        return (
          <div key={index} className="my-2 overflow-x-auto py-1">
            <BlockMath math={math} />
          </div>
        )
      }

      if (part.startsWith('$') && part.endsWith('$')) {
        const math = part.slice(1, -1).trim()
        if (!math) return part
        return (
          <span key={index} className="inline-block px-1 py-0.5">
            <InlineMath math={math} />
          </span>
        )
      }

      // Bold Text (Recursive)
      if (
        (part.startsWith('**') && part.endsWith('**')) ||
        (part.startsWith('__') && part.endsWith('__'))
      ) {
        const innerText = part.slice(2, -2)
        return (
          <strong key={index} className="font-bold text-foreground">
            {renderLatex(innerText)}
          </strong>
        )
      }

      // Plain Text
      return <span key={index}>{part}</span>
    })
  }

  return (
    <span className="whitespace-pre-wrap font-charter">
      {renderLatex(resolvedContent)}
    </span>
  )
}

export function LatexBlock({ children }: { children?: string | null }) {
  return <Latex block>{children}</Latex>
}
