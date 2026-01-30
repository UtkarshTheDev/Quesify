'use client'

import { useState, useEffect, useCallback } from 'react'
import { Bell, Check, History, Loader2, Sparkles, UserPlus, ThumbsUp, GitFork, Link as LinkIcon } from 'lucide-react'
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover'
import { Button } from '@/components/ui/button'
import { ScrollArea } from '@/components/ui/scroll-area'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { formatDistanceToNow } from 'date-fns'
import { createClient } from '@/lib/supabase/client'
import { getNotifications, markAsRead, markAllAsRead, getUnreadCount } from '@/app/actions/notifications'
import { cn } from '@/lib/utils'
import Link from 'next/link'

export function NotificationBell({ userId }: { userId: string }) {
  const [notifications, setNotifications] = useState<any[]>([])
  const [unreadCount, setUnreadCount] = useState(0)
  const [isOpen, setIsOpen] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const supabase = createClient()

  const fetchInitialData = useCallback(async () => {
    setIsLoading(true)
    const [notifs, count] = await Promise.all([
      getNotifications(20),
      getUnreadCount()
    ])
    setNotifications(notifs)
    setUnreadCount(count)
    setIsLoading(false)
  }, [])

  useEffect(() => {
    fetchInitialData()

    const channel = supabase
      .channel('schema-db-changes')
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'notifications',
          filter: `recipient_id=eq.${userId}`
        },
        async (payload) => {
          const { data } = await supabase
            .from('notifications')
            .select(`
              *,
              sender:user_profiles!sender_id (display_name, avatar_url, username)
            `)
            .eq('id', payload.new.id)
            .single()

          if (data) {
            setNotifications(prev => [data, ...prev].slice(0, 20))
            setUnreadCount(prev => prev + 1)
          }
        }
      )
      .subscribe()

    return () => {
      supabase.removeChannel(channel)
    }
  }, [userId, fetchInitialData, supabase])

  const handleMarkAsRead = async (id: string) => {
    await markAsRead(id)
    setNotifications(prev => 
      prev.map(n => n.id === id ? { ...n, is_read: true } : n)
    )
    setUnreadCount(prev => Math.max(0, prev - 1))
  }

  const handleMarkAllAsRead = async () => {
    await markAllAsRead()
    setNotifications(prev => prev.map(n => ({ ...n, is_read: true })))
    setUnreadCount(0)
  }

  const getIcon = (type: string) => {
    switch (type) {
      case 'follow': return <UserPlus className="h-4 w-4 text-blue-500" />
      case 'solution_like': return <ThumbsUp className="h-4 w-4 text-orange-500" />
      case 'solution_linked': return <LinkIcon className="h-4 w-4 text-purple-500" />
      case 'new_contribution': return <GitFork className="h-4 w-4 text-emerald-500" />
      default: return <Bell className="h-4 w-4 text-primary" />
    }
  }

  const getContent = (notification: any) => {
    const senderName = notification.sender?.display_name || 'Someone'
    switch (notification.type) {
      case 'follow': return `started following you`
      case 'solution_like': return `liked your solution`
      case 'solution_linked': return `linked to your question`
      case 'new_contribution': return `added a solution to your question`
      default: return `sent you a notification`
    }
  }

  const getUrl = (notification: any) => {
    switch (notification.type) {
      case 'follow': return `/u/${notification.sender?.username}`
      case 'solution_like':
      case 'solution_linked':
      case 'new_contribution': return `/dashboard/questions/${notification.target_id}`
      default: return '#'
    }
  }

  return (
    <Popover open={isOpen} onOpenChange={setIsOpen}>
      <PopoverTrigger asChild>
        <Button variant="ghost" size="icon" className="relative h-8 w-8 rounded-full">
          <Bell className="h-5 w-5" />
          {unreadCount > 0 && (
            <span className="absolute -top-0.5 -right-0.5 flex h-4 w-4 items-center justify-center rounded-full bg-orange-500 text-[10px] font-bold text-white shadow-sm ring-2 ring-background">
              {unreadCount > 9 ? '9+' : unreadCount}
            </span>
          )}
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-80 p-0" align="end">
        <div className="flex items-center justify-between border-b px-4 py-3">
          <h4 className="text-sm font-bold flex items-center gap-2">
            Notifications
            {unreadCount > 0 && (
              <span className="text-[10px] bg-primary/10 text-primary px-1.5 py-0.5 rounded-full font-black uppercase tracking-tighter">
                {unreadCount} New
              </span>
            )}
          </h4>
          {unreadCount > 0 && (
            <Button 
              variant="ghost" 
              size="sm" 
              className="h-7 px-2 text-[10px] font-bold uppercase tracking-widest text-muted-foreground hover:text-primary"
              onClick={handleMarkAllAsRead}
            >
              Mark all read
            </Button>
          )}
        </div>
        <ScrollArea className="h-[400px]">
          {isLoading ? (
            <div className="flex h-40 items-center justify-center">
              <Loader2 className="h-6 w-6 animate-spin text-muted-foreground" />
            </div>
          ) : notifications.length === 0 ? (
            <div className="flex h-40 flex-col items-center justify-center text-center p-4">
              <div className="h-12 w-12 rounded-full bg-muted/20 flex items-center justify-center mb-3">
                <Bell className="h-6 w-6 text-muted-foreground/30" />
              </div>
              <p className="text-sm font-medium text-muted-foreground">All caught up!</p>
              <p className="text-[11px] text-muted-foreground/60">No new notifications yet.</p>
            </div>
          ) : (
            <div className="grid divide-y">
              {notifications.map((n) => (
                <div 
                  key={n.id} 
                  className={cn(
                    "flex items-start gap-3 p-4 transition-colors hover:bg-muted/50 relative group",
                    !n.is_read && "bg-primary/[0.02]"
                  )}
                >
                  {!n.is_read && (
                    <div className="absolute left-0 top-0 bottom-0 w-1 bg-primary" />
                  )}
                  <Link href={getUrl(n)} className="shrink-0" onClick={() => { setIsOpen(false); handleMarkAsRead(n.id); }}>
                    <Avatar className="h-9 w-9 border-2 border-background shadow-sm">
                      <AvatarImage src={n.sender?.avatar_url || ''} />
                      <AvatarFallback className="text-[10px] bg-muted font-bold text-muted-foreground uppercase">
                        {n.sender?.display_name?.[0] || 'U'}
                      </AvatarFallback>
                    </Avatar>
                  </Link>
                  <div className="flex-1 space-y-1 min-w-0">
                    <p className="text-xs leading-relaxed">
                      <span className="font-bold text-foreground">
                        @{n.sender?.username || 'user'}
                      </span>{' '}
                      <span className="text-muted-foreground">
                        {getContent(n)}
                      </span>
                    </p>
                    <div className="flex items-center justify-between gap-2">
                      <div className="flex items-center gap-2">
                         {getIcon(n.type)}
                         <span className="text-[10px] text-muted-foreground/60 font-medium">
                           {formatDistanceToNow(new Date(n.created_at), { addSuffix: true })}
                         </span>
                      </div>
                      {!n.is_read && (
                        <Button 
                          variant="ghost" 
                          size="icon" 
                          className="h-5 w-5 rounded-full opacity-0 group-hover:opacity-100 transition-opacity hover:bg-primary/10 hover:text-primary"
                          onClick={() => handleMarkAsRead(n.id)}
                        >
                          <Check className="h-3 w-3" />
                        </Button>
                      )}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </ScrollArea>
        <div className="border-t p-2">
          <Button variant="ghost" size="sm" className="w-full text-xs font-bold h-9 hover:bg-muted/50" asChild onClick={() => setIsOpen(false)}>
            <Link href="/notifications">
              View all history
            </Link>
          </Button>
        </div>
      </PopoverContent>
    </Popover>
  )
}
