'use client'

import { useState, useTransition } from 'react'
import { Button } from '@/components/ui/button'
import { UserPlus, UserMinus, Loader2 } from 'lucide-react'
import { toggleFollow } from '@/app/actions/social'
import { toast } from 'sonner'
import { cn } from '@/lib/utils'

interface FollowButtonProps {
  followingId: string
  initialIsFollowing: boolean
  className?: string
}

export function FollowButton({ followingId, initialIsFollowing, className }: FollowButtonProps) {
  const [isFollowing, setIsFollowing] = useState(initialIsFollowing)
  const [isPending, startTransition] = useTransition()

  const handleToggle = () => {
    startTransition(async () => {
      const newState = !isFollowing
      setIsFollowing(newState)
      
      try {
        await toggleFollow(followingId)
        toast.success(newState ? 'Following user' : 'Unfollowed user')
      } catch (error: any) {
        setIsFollowing(!newState)
        toast.error(error.message || 'Failed to update follow status')
      }
    })
  }

  return (
    <Button
      onClick={handleToggle}
      disabled={isPending}
      variant={isFollowing ? "outline" : "default"}
      className={cn(
        "w-full transition-all duration-300 font-bold",
        isFollowing 
          ? "border-primary/50 text-primary hover:bg-primary/5 hover:border-red-500/50 hover:text-red-500 group/follow" 
          : "bg-orange-500 hover:bg-orange-600 shadow-lg shadow-orange-500/20",
        className
      )}
    >
      {isPending ? (
        <Loader2 className="w-4 h-4 animate-spin mr-2" />
      ) : isFollowing ? (
        <>
          <UserMinus className="w-4 h-4 mr-2 group-hover/follow:inline hidden" />
          <span className="group-hover/follow:hidden inline">Following</span>
          <span className="group-hover/follow:inline hidden">Unfollow</span>
        </>
      ) : (
        <>
          <UserPlus className="w-4 h-4 mr-2" />
          Follow
        </>
      )}
    </Button>
  )
}
