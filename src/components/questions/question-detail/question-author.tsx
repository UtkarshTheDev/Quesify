/* eslint-disable @next/next/no-img-element */
import { Hash } from 'lucide-react'

interface QuestionAuthorProps {
  author: {
    display_name: string | null
    avatar_url: string | null
  } | undefined
}

export function QuestionAuthor({ author }: QuestionAuthorProps) {
  if (!author) return null

  return (
    <div className="flex items-center gap-3 px-1 py-1 bg-primary/5 rounded-full w-fit pr-4 ring-1 ring-primary/10 mb-2">
      <div className="h-8 w-8 rounded-full overflow-hidden border border-primary/20 bg-background flex items-center justify-center shrink-0">
        {author.avatar_url ? (
          <img src={author.avatar_url} alt="" className="h-full w-full object-cover" />
        ) : (
          <Hash className="h-4 w-4 text-primary/40" />
        )}
      </div>
      <div className="flex flex-col -space-y-0.5">
        <span className="text-[10px] uppercase tracking-wider font-bold text-primary/60">Contributed by</span>
        <span className="text-sm font-bold text-foreground">
          {author.display_name || 'Anonymous User'}
        </span>
      </div>
    </div>
  )
}
