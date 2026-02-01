'use client'

import { useState, useEffect } from 'react'
import { Button } from '@/components/ui/button'
import { UserPlus, UserCheck, Loader2 } from 'lucide-react'
import { toast } from 'sonner'
import { cn } from '@/lib/utils'

interface FollowButtonProps {
  targetId: string
  className?: string
  variant?: 'default' | 'outline' | 'ghost'
  size?: 'default' | 'sm' | 'lg' | 'icon'
  onFollowChange?: (isFollowing: boolean) => void
}

export function FollowButton({ 
  targetId, 
  className,
  variant = 'outline',
  size = 'default',
  onFollowChange
}: FollowButtonProps) {
  const [isFollowing, setIsFollowing] = useState(false)
  const [isLoading, setIsLoading] = useState(true)
  const [isPending, setIsPending] = useState(false)

  // Fetch initial state
  useEffect(() => {
    const checkFollowStatus = async () => {
      try {
        const res = await fetch(`/api/social/follow?target_id=${targetId}`)
        const data = await res.json()
        setIsFollowing(data.isFollowing)
        setIsLoading(false)
      } catch (error) {
        console.error('Failed to check follow status', error)
        setIsLoading(false)
      }
    }

    if (targetId) {
      checkFollowStatus()
    }
  }, [targetId])

  const handleToggleFollow = async () => {
    if (isPending) return

    // Optimistic update
    const previousState = isFollowing
    setIsFollowing(!previousState)
    setIsPending(true)

    try {
      const endpoint = '/api/social/follow'
      const method = previousState ? 'DELETE' : 'POST'
      
      const res = await fetch(endpoint, {
        method,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ target_id: targetId })
      })

      if (!res.ok) {
        throw new Error('Action failed')
      }

      await res.json()
      
      // Update parent if needed
      if (onFollowChange) {
        onFollowChange(!previousState)
      }

      toast.success(previousState ? 'Unfollowed successfully' : 'Followed successfully')
    } catch {
      // Revert on failure
      setIsFollowing(previousState)
      toast.error('Failed to update follow status')
    } finally {
      setIsPending(false)
    }
  }

  if (isLoading) {
    return (
      <Button 
        variant={variant} 
        size={size} 
        disabled 
        className={cn("w-full gap-2", className)}
      >
        <Loader2 className="h-4 w-4 animate-spin" />
        Loading...
      </Button>
    )
  }

  return (
    <Button
      variant={isFollowing ? "default" : variant}
      size={size}
      onClick={handleToggleFollow}
      disabled={isPending}
      className={cn(
        "w-full gap-2 transition-all duration-300",
        isFollowing 
          ? "bg-orange-500 hover:bg-orange-600 text-white border-orange-500" 
          : "hover:text-orange-500 hover:border-orange-500",
        className
      )}
    >
      {isFollowing ? (
        <>
          <UserCheck className="h-4 w-4" />
          Following
        </>
      ) : (
        <>
          <UserPlus className="h-4 w-4" />
          Follow
        </>
      )}
    </Button>
  )
}
