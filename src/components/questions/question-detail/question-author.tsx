import Image from 'next/image'
import { Hash } from 'lucide-react'
import Link from 'next/link'

interface QuestionAuthorProps {
  author: {
    display_name: string | null
    avatar_url: string | null
    username?: string | null
  } | undefined
}

export function QuestionAuthor({ author }: QuestionAuthorProps) {
  if (!author) return null

  return (
    <Link 
      href={author.username ? `/u/${author.username}` : "#"} 
      className="flex items-center gap-3 px-1 py-1 bg-primary/5 rounded-full w-fit pr-4 ring-1 ring-primary/10 mb-2 hover:bg-primary/10 transition-colors group"
    >
      <div className="h-8 w-8 rounded-full overflow-hidden border border-primary/20 bg-background flex items-center justify-center shrink-0 group-hover:border-primary/40 transition-colors">
        {author.avatar_url ? (
          <Image src={author.avatar_url} alt="" width={32} height={32} className="h-full w-full object-cover" />
        ) : (
          <Hash className="h-4 w-4 text-primary/40" />
        )}
      </div>
      <div className="flex flex-col -space-y-0.5">
        <span className="text-[10px] uppercase tracking-wider font-bold text-primary/60">Contributed by</span>
        <span className="text-sm font-bold text-foreground group-hover:text-primary transition-colors">
          @{author.username || 'anonymous'}
        </span>
      </div>
    </Link>
  )
}
