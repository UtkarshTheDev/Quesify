'use client'

import { useState, useEffect } from 'react'
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { ScrollArea } from '@/components/ui/scroll-area'
import Link from 'next/link'
import { FollowButton } from './follow-button'
import { createClient } from '@/lib/supabase/client'

interface FollowStatsProps {
  userId: string
  className?: string
}

interface UserListItem {
  user_id: string
  display_name: string | null
  username: string | null
  avatar_url: string | null
}

export function FollowStats({ userId, className }: FollowStatsProps) {
  const [isOpen, setIsOpen] = useState(false)
  const [activeTab, setActiveTab] = useState<'followers' | 'following'>('followers')
  const [stats, setStats] = useState({ followers: 0, following: 0 })
  const [users, setUsers] = useState<UserListItem[]>([])
  const [loading, setLoading] = useState(false)

  // Fetch stats on mount
  useEffect(() => {
    const fetchStats = async () => {
      const res = await fetch(`/api/social/follow?target_id=${userId}`)
      const data = await res.json()
      setStats({
        followers: data.followers || 0,
        following: data.following || 0
      })
    }
    if (userId) fetchStats()
  }, [userId])

  // Fetch users list when dialog opens or tab changes
  useEffect(() => {
    if (!isOpen) return

    const fetchList = async () => {
      setLoading(true)
      const supabase = createClient()
      
      let query
      if (activeTab === 'followers') {
        query = supabase
          .from('follows')
          .select('follower:user_profiles!follower_id(user_id, display_name, username, avatar_url)')
          .eq('following_id', userId)
      } else {
        query = supabase
          .from('follows')
          .select('following:user_profiles!following_id(user_id, display_name, username, avatar_url)')
          .eq('follower_id', userId)
      }

      const { data } = await query
      
      if (data) {
        const mappedUsers = data.map((item: any) => 
          activeTab === 'followers' ? item.follower : item.following
        )
        setUsers(mappedUsers)
      }
      setLoading(false)
    }

    fetchList()
  }, [isOpen, activeTab, userId])

  const openDialog = (tab: 'followers' | 'following') => {
    setActiveTab(tab)
    setIsOpen(true)
  }

  return (
    <>
      <div className={`flex items-center gap-6 justify-center w-full ${className}`}>
        <button 
          onClick={() => openDialog('followers')}
          className="flex flex-col items-center group cursor-pointer hover:opacity-80 transition-opacity flex-1 sm:flex-initial"
        >
          <span className="text-xl md:text-2xl font-bold">{stats.followers}</span>
          <span className="text-xs font-bold text-muted-foreground tracking-widest uppercase group-hover:text-orange-500 transition-colors text-center">Followers</span>
        </button>
        <div className="h-8 w-px bg-border/50" />
        <button 
          onClick={() => openDialog('following')}
          className="flex flex-col items-center group cursor-pointer hover:opacity-80 transition-opacity flex-1 sm:flex-initial"
        >
          <span className="text-xl md:text-2xl font-bold">{stats.following}</span>
          <span className="text-xs font-bold text-muted-foreground tracking-widest uppercase group-hover:text-orange-500 transition-colors text-center">Following</span>
        </button>
      </div>

      <Dialog open={isOpen} onOpenChange={setIsOpen}>
        <DialogContent className="sm:max-w-md h-[80vh] flex flex-col p-0 gap-0 overflow-hidden">
          <DialogHeader className="px-6 py-4 border-b">
            <DialogTitle className="text-center font-bold">
              {activeTab === 'followers' ? 'Followers' : 'Following'}
            </DialogTitle>
          </DialogHeader>
          
          <Tabs value={activeTab} onValueChange={(v) => setActiveTab(v as any)} className="w-full flex-1 flex flex-col">
            <TabsList className="w-full justify-start rounded-none border-b bg-transparent p-0 h-12">
              <TabsTrigger 
                value="followers" 
                className="flex-1 rounded-none border-b-2 border-transparent data-[state=active]:border-orange-500 data-[state=active]:text-orange-500 h-full font-bold"
              >
                Followers
              </TabsTrigger>
              <TabsTrigger 
                value="following" 
                className="flex-1 rounded-none border-b-2 border-transparent data-[state=active]:border-orange-500 data-[state=active]:text-orange-500 h-full font-bold"
              >
                Following
              </TabsTrigger>
            </TabsList>

            <ScrollArea className="flex-1 p-4">
              {loading ? (
                <div className="flex justify-center p-8 text-muted-foreground">Loading...</div>
              ) : users.length === 0 ? (
                <div className="flex flex-col items-center justify-center p-12 text-muted-foreground space-y-2">
                  <p>No users found</p>
                </div>
              ) : (
                <div className="space-y-4">
                  {users.map((user) => (
                    <div key={user.user_id} className="flex items-center justify-between p-2 rounded-lg hover:bg-muted/50 transition-colors">
                      <Link href={`/u/${user.username}`} onClick={() => setIsOpen(false)} className="flex items-center gap-3 flex-1 min-w-0">
                        <Avatar className="h-10 w-10 border shadow-sm">
                          <AvatarImage src={user.avatar_url || ''} />
                          <AvatarFallback>{user.display_name?.[0]}</AvatarFallback>
                        </Avatar>
                        <div className="min-w-0">
                          <p className="font-bold truncate text-sm">{user.display_name}</p>
                          <p className="text-xs text-muted-foreground truncate">@{user.username}</p>
                        </div>
                      </Link>
                      
                      {/* Don't show follow button for self */}
                      {user.user_id !== userId && (
                        <div className="w-24 shrink-0">
                          <FollowButton targetId={user.user_id} size="sm" className="h-8 text-xs" />
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              )}
            </ScrollArea>
          </Tabs>
        </DialogContent>
      </Dialog>
    </>
  )
}
