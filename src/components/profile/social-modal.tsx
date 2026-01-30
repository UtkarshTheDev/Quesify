'use client'

import { useState, useEffect } from 'react'
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Button } from '@/components/ui/button'
import { Loader2, UserPlus, UserMinus, Search } from 'lucide-react'
import { getFollowers, getFollowing, checkIsFollowing } from '@/app/actions/social'
import { FollowButton } from './follow-button'
import { Input } from '@/components/ui/input'
import Link from 'next/link'

interface SocialModalProps {
  userId: string
  type: 'followers' | 'following'
  isOpen: boolean
  onClose: () => void
  currentUserId: string | null
}

export function SocialModal({ userId, type, isOpen, onClose, currentUserId }: SocialModalProps) {
  const [users, setUsers] = useState<any[]>([])
  const [isLoading, setIsLoading] = useState(false)
  const [searchQuery, setSearchQuery] = useState('')

  useEffect(() => {
    if (isOpen) {
      fetchUsers()
    }
  }, [isOpen, type, userId])

  const fetchUsers = async () => {
    setIsLoading(true)
    try {
      const data = type === 'followers' ? await getFollowers(userId) : await getFollowing(userId)
      
      const enrichedUsers = await Promise.all((data || []).map(async (u: any) => {
        const isFollowing = currentUserId ? await checkIsFollowing(u.user_id) : false
        return { ...u, isFollowing }
      }))
      
      setUsers(enrichedUsers)
    } catch (error) {
      console.error('Failed to fetch social list', error)
    } finally {
      setIsLoading(false)
    }
  }

  const filteredUsers = users.filter(u => 
    u.display_name?.toLowerCase().includes(searchQuery.toLowerCase()) || 
    u.username?.toLowerCase().includes(searchQuery.toLowerCase())
  )

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="sm:max-w-[425px] p-0 overflow-hidden gap-0">
        <DialogHeader className="p-6 pb-2">
          <DialogTitle className="text-xl font-bold capitalize">
            {type}
          </DialogTitle>
        </DialogHeader>

        <div className="px-6 pb-4">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input 
              placeholder="Search people..." 
              className="pl-9 bg-muted/50 border-none h-10"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
          </div>
        </div>

        <div className="max-h-[400px] overflow-y-auto px-2 pb-6">
          {isLoading ? (
            <div className="flex h-40 items-center justify-center">
              <Loader2 className="h-6 w-6 animate-spin text-primary" />
            </div>
          ) : filteredUsers.length === 0 ? (
            <div className="flex h-40 flex-col items-center justify-center text-center p-4">
              <p className="text-sm text-muted-foreground font-medium">
                {searchQuery ? 'No results found' : `No ${type} yet`}
              </p>
            </div>
          ) : (
            <div className="grid gap-1">
              {filteredUsers.map((user) => (
                <div 
                  key={user.user_id} 
                  className="flex items-center justify-between gap-3 p-3 rounded-xl hover:bg-muted/50 transition-colors group"
                >
                  <Link 
                    href={`/u/${user.username}`} 
                    className="flex items-center gap-3 min-w-0" 
                    onClick={onClose}
                  >
                    <Avatar className="h-10 w-10 border-2 border-background shadow-sm">
                      <AvatarImage src={user.avatar_url || ''} />
                      <AvatarFallback className="bg-muted font-bold text-muted-foreground uppercase text-xs">
                        {user.display_name?.[0] || 'U'}
                      </AvatarFallback>
                    </Avatar>
                    <div className="min-w-0">
                      <p className="text-sm font-bold truncate text-foreground group-hover:text-primary transition-colors">
                        {user.display_name}
                      </p>
                      <p className="text-[11px] text-muted-foreground truncate">
                        @{user.username}
                      </p>
                    </div>
                  </Link>
                  
                  {currentUserId && currentUserId !== user.user_id && (
                    <FollowButton 
                      followingId={user.user_id} 
                      initialIsFollowing={user.isFollowing} 
                      className="h-8 w-24 text-[10px] uppercase tracking-widest px-0"
                    />
                  )}
                </div>
              ))}
            </div>
          )}
        </div>
      </DialogContent>
    </Dialog>
  )
}
