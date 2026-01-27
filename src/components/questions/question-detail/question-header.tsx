'use client'

import { useRouter } from 'next/navigation'
import { ArrowLeft, Hash, Loader2, Share2 } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { toast } from 'sonner'

interface QuestionHeaderProps {
  isPublic: boolean
  userId: string | null
  questionId: string
  ownerId: string
  userQuestions: { id: string }[] | undefined
  isAddingToBank: boolean
  handleAddToBank: () => void
}

export function QuestionHeader({
  isPublic,
  userId,
  questionId,
  ownerId,
  userQuestions,
  isAddingToBank,
  handleAddToBank,
}: QuestionHeaderProps) {
  const router = useRouter()

  return (
    <div className="flex items-center justify-between">
      <Button
        variant="ghost"
        size="sm"
        className="gap-2"
        onClick={() => router.back()}
      >
        <ArrowLeft className="h-4 w-4" />
        Back
      </Button>

      <div className="flex items-center gap-2">
        {isPublic && userId !== ownerId && (!userQuestions || userQuestions.length === 0) && (
          <Button
            variant="default"
            size="sm"
            className="gap-2 font-bold bg-primary hover:bg-primary/90 rounded-full"
            onClick={handleAddToBank}
            disabled={isAddingToBank}
          >
            {isAddingToBank ? (
              <Loader2 className="h-4 w-4 animate-spin" />
            ) : (
              <Hash className="h-4 w-4" />
            )}
            Add to Bank
          </Button>
        )}

        <Button
          variant="outline"
          size="sm"
          className="gap-2 transition-all hover:bg-primary/5 hover:text-primary active:scale-95"
          onClick={() => {
            const url = `${window.location.origin}/question/${questionId}`;
            navigator.clipboard.writeText(url);
            toast.success('Link copied to clipboard');
          }}
        >
          <Share2 className="h-4 w-4" />
          Share
        </Button>
      </div>
    </div>
  )
}
