'use client'

import { useState, useEffect } from 'react'
import { Bell, Check, UserPlus, Heart, BookOpen, Lightbulb } from 'lucide-react'
import { Button } from '@/components/ui/button'
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from '@/components/ui/popover'
import { ScrollArea } from '@/components/ui/scroll-area'
import { createClient } from '@/lib/supabase/client'
import { formatDistanceToNow } from 'date-fns'
import Link from 'next/link'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { toast } from 'sonner'

interface Notification {
  id: string
  type: 'follow' | 'like' | 'link' | 'contribution'
  is_read: boolean
  created_at: string
  sender: {
    display_name: string | null
    username: string | null
    avatar_url: string | null
  }
  entityDetails?: any
}

interface NotificationBellProps {
  userId?: string
}

export function NotificationBell({ userId }: NotificationBellProps) {
  const [notifications, setNotifications] = useState<Notification[]>([])
  const [unreadCount, setUnreadCount] = useState(0)
  const [isOpen, setIsOpen] = useState(false)
  const supabase = createClient()

  useEffect(() => {
    fetchNotifications()

    // Subscribe to realtime updates for the current user
    const subscribeToNotifications = async () => {
      if (!userId) return

      const channel = supabase
        .channel(`notifications-${userId}`)
        .on(
          'postgres_changes',
          {
            event: 'INSERT',
            schema: 'public',
            table: 'notifications',
            filter: `recipient_id=eq.${userId}`
          },
          (payload) => {
            setUnreadCount((prev) => prev + 1)
            fetchNotifications() // Refresh list
            toast.info('New notification received')
          }
        )
        .subscribe()

      return channel
    }

    let notificationChannel: any
    subscribeToNotifications().then(channel => {
      notificationChannel = channel
    })

    return () => {
      if (notificationChannel) {
        supabase.removeChannel(notificationChannel)
      }
    }
  }, [])

  const fetchNotifications = async () => {
    try {
      const res = await fetch('/api/social/notifications?limit=10')
      const data = await res.json()
      setNotifications(data.notifications || [])
      setUnreadCount(data.notifications?.filter((n: Notification) => !n.is_read).length || 0)
    } catch (error) {
      console.error('Failed to fetch notifications', error)
    }
  }

  const markAllRead = async () => {
    try {
      await fetch('/api/social/notifications', {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ mark_all: true })
      })
      setUnreadCount(0)
      setNotifications(prev => prev.map(n => ({ ...n, is_read: true })))
    } catch (error) {
      console.error('Failed to mark all read', error)
    }
  }

  const markRead = async (id: string) => {
    try {
      await fetch('/api/social/notifications', {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id })
      })
      setNotifications(prev => prev.map(n => n.id === id ? ({ ...n, is_read: true }) : n))
      setUnreadCount(prev => Math.max(0, prev - 1))
    } catch (error) {
      console.error('Failed to mark read', error)
    }
  }

  const getIcon = (type: string) => {
    switch (type) {
      case 'follow': return <UserPlus className="h-4 w-4 text-blue-500" />
      case 'like': return <Heart className="h-4 w-4 text-red-500" />
      case 'link': return <BookOpen className="h-4 w-4 text-purple-500" />
      case 'contribution': return <Lightbulb className="h-4 w-4 text-orange-500" />
      default: return <Bell className="h-4 w-4" />
    }
  }

  const getMessage = (notif: Notification) => {
    const name = notif.sender.display_name || 'Someone'
    switch (notif.type) {
      case 'follow': return <><span className="font-bold">{name}</span> started following you</>
      case 'like': return <><span className="font-bold">{name}</span> liked your solution</>
      case 'link': return <><span className="font-bold">{name}</span> added your question to bank</>
      case 'contribution': return <><span className="font-bold">{name}</span> added a new approach</>
      default: return 'New notification'
    }
  }

  const getLink = (notif: Notification) => {
    if (notif.type === 'follow') return `/u/${notif.sender.username}`
    // For solutions/questions, link to the question
    if (notif.entityDetails?.question_id) return `/question/${notif.entityDetails.question_id}`
    return '#'
  }

  return (
    <Popover open={isOpen} onOpenChange={(open) => {
      setIsOpen(open)
      if (open) markAllRead() // Auto-mark read when opening as requested
    }}>
      <PopoverTrigger asChild>
        <Button variant="ghost" size="icon" className="relative">
          <Bell className="h-5 w-5" />
          {unreadCount > 0 && (
            <span className="absolute top-1.5 right-1.5 h-2 w-2 rounded-full bg-red-500 ring-2 ring-background animate-pulse" />
          )}
        </Button>
      </PopoverTrigger>
      <PopoverContent align="end" className="w-80 p-0 shadow-xl border-border/60">
        <div className="flex items-center justify-between px-4 py-3 border-b bg-muted/30">
          <h4 className="font-bold text-sm">Notifications</h4>
          <Link href="/dashboard/notifications" onClick={() => setIsOpen(false)} className="text-xs text-orange-500 hover:underline">
            View all
          </Link>
        </div>
        <ScrollArea className="h-[300px]">
          {notifications.length === 0 ? (
            <div className="flex flex-col items-center justify-center h-full p-8 text-muted-foreground text-sm">
              <Bell className="h-8 w-8 mb-2 opacity-20" />
              No notifications yet
            </div>
          ) : (
            <div className="divide-y">
              {notifications.map((notif) => (
                <Link
                  key={notif.id}
                  href={getLink(notif)}
                  onClick={() => setIsOpen(false)}
                  className={`flex gap-3 p-4 hover:bg-muted/50 transition-colors ${!notif.is_read ? 'bg-orange-500/5' : ''}`}
                >
                  <Avatar className="h-8 w-8 border shrink-0">
                    <AvatarImage src={notif.sender.avatar_url || ''} />
                    <AvatarFallback>{notif.sender.display_name?.[0]}</AvatarFallback>
                  </Avatar>
                  <div className="space-y-1 flex-1 min-w-0">
                    <p className="text-sm leading-tight text-foreground/90">
                      {getMessage(notif)}
                    </p>
                    <div className="flex items-center gap-2 text-xs text-muted-foreground">
                      {getIcon(notif.type)}
                      <span>{formatDistanceToNow(new Date(notif.created_at), { addSuffix: true })}</span>
                    </div>
                  </div>
                </Link>
              ))}
            </div>
          )}
        </ScrollArea>
      </PopoverContent>
    </Popover>
  )
}
