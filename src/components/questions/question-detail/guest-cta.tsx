'use client'

import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'

export function GuestCTA() {
  const router = useRouter()

  return (
    <div className="fixed bottom-6 left-1/2 -translate-x-1/2 w-[95%] max-w-2xl z-50 animate-in slide-in-from-bottom-8 duration-700">
      <div className="bg-foreground text-background shadow-2xl rounded-2xl p-4 md:p-6 flex items-center justify-between gap-6 overflow-hidden relative">
        <div className="absolute top-0 right-0 w-32 h-32 bg-primary/20 blur-[60px] -translate-y-1/2 translate-x-1/2" />
        <div className="space-y-1 relative z-10">
          <h3 className="font-bold text-lg leading-tight">Master this topic with Quesify</h3>
          <p className="text-sm text-background/70 max-w-sm hidden sm:block">
            Sign up to save this question, track your progress, and see more expert solutions.
          </p>
        </div>
        <Button
          className="bg-primary text-primary-foreground hover:bg-primary/90 rounded-full px-8 shrink-0 relative z-10 font-bold"
          onClick={() => router.push('/login')}
        >
          Sign Up Free
        </Button>
      </div>
    </div>
  )
}
