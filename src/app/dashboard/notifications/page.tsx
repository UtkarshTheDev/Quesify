'use client'

import { useState, useEffect } from 'react'
import { Check, Bell, UserPlus, Heart, BookOpen, Lightbulb } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { formatDistanceToNow } from 'date-fns'
import Link from 'next/link'
import { toast } from 'sonner'
import { FollowButton } from '@/components/profile/follow-button'

interface Notification {
  id: string
  type: 'follow' | 'like' | 'link' | 'contribution'
  is_read: boolean
  created_at: string
  sender_id: string
  sender: {
    display_name: string | null
    username: string | null
    avatar_url: string | null
  }
  entityDetails?: any
}

export default function NotificationsPage() {
  const [notifications, setNotifications] = useState<Notification[]>([])
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    fetchNotifications()
    // Auto mark all as read on mount as requested
    markAllRead()
  }, [])

  const fetchNotifications = async () => {
    try {
      const res = await fetch('/api/social/notifications?limit=50')
      const data = await res.json()
      setNotifications(data.notifications || [])
    } catch (error) {
      toast.error('Failed to load notifications')
    } finally {
      setIsLoading(false)
    }
  }

  const markAllRead = async () => {
    try {
      await fetch('/api/social/notifications', {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ mark_all: true })
      })
      setNotifications(prev => prev.map(n => ({ ...n, is_read: true })))
    } catch (error) {
      console.error('Failed to mark all read', error)
    }
  }

  const getIcon = (type: string) => {
    switch (type) {
      case 'follow': return <UserPlus className="h-5 w-5 text-blue-500" />
      case 'like': return <Heart className="h-5 w-5 text-red-500" />
      case 'link': return <BookOpen className="h-5 w-5 text-purple-500" />
      case 'contribution': return <Lightbulb className="h-5 w-5 text-orange-500" />
      default: return <Bell className="h-5 w-5" />
    }
  }

  const getMessage = (notif: Notification) => {
    const name = notif.sender.display_name || 'Someone'
    switch (notif.type) {
      case 'follow': return <><span className="font-bold">@{notif.sender.username}</span> started following you</>
      case 'like': return <><span className="font-bold">@{notif.sender.username}</span> liked your solution</>
      case 'link': return <><span className="font-bold">@{notif.sender.username}</span> added your question to their bank</>
      case 'contribution': return <><span className="font-bold">@{notif.sender.username}</span> contributed a new approach to your question</>
      default: return 'New notification'
    }
  }

  const getAction = (notif: Notification) => {
    if (notif.type === 'follow') {
      return (
        <div className="flex gap-2">
          <FollowButton targetId={notif.sender_id} size="sm" />
          <Button variant="outline" size="sm" asChild>
            <Link href={`/u/${notif.sender.username}`}>View Profile</Link>
          </Button>
        </div>
      )
    }
    
    if (notif.entityDetails?.question_id) {
      return (
        <Button variant="outline" size="sm" asChild>
          <Link href={`/question/${notif.entityDetails.question_id}`}>
            {notif.type === 'link' ? 'View Question' : 'View Solution'}
          </Link>
        </Button>
      )
    }
    
    return null
  }

  return (
    <div className="max-w-3xl mx-auto px-4 py-8 md:py-12 space-y-8">
      <div className="flex items-center justify-between">
        <div className="space-y-1">
          <h1 className="text-3xl font-bold tracking-tight">Notifications</h1>
          <p className="text-muted-foreground">Stay updated with your social activity</p>
        </div>
        <Button variant="outline" onClick={markAllRead} className="gap-2">
          <Check className="h-4 w-4" />
          Mark all as read
        </Button>
      </div>

      <div className="space-y-4">
        {isLoading ? (
          <div className="text-center py-12 text-muted-foreground">Loading notifications...</div>
        ) : notifications.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-24 text-muted-foreground bg-card border rounded-2xl">
            <Bell className="h-12 w-12 mb-4 opacity-20" />
            <p className="text-lg font-medium">No notifications yet</p>
            <p className="text-sm">When someone interacts with you, it will show up here.</p>
          </div>
        ) : (
          notifications.map((notif) => (
            <div 
              key={notif.id}
              className="flex flex-col md:flex-row md:items-center gap-4 p-5 rounded-2xl border bg-card/50 hover:bg-card transition-all"
            >
              <div className="flex items-start gap-4 flex-1">
                <Link href={`/u/${notif.sender.username}`} className="shrink-0">
                  <Avatar className="h-12 w-12 border-2 border-background shadow-sm">
                    <AvatarImage src={notif.sender.avatar_url || ''} />
                    <AvatarFallback>{notif.sender.display_name?.[0]}</AvatarFallback>
                  </Avatar>
                </Link>
                
                <div className="space-y-1 pt-1">
                  <p className="text-base text-foreground/90 leading-relaxed">
                    {getMessage(notif)}
                  </p>
                  <div className="flex items-center gap-2 text-xs font-medium text-muted-foreground uppercase tracking-wider">
                    {getIcon(notif.type)}
                    <span>{formatDistanceToNow(new Date(notif.created_at), { addSuffix: true })}</span>
                  </div>
                </div>
              </div>

              <div className="pl-16 md:pl-0 shrink-0">
                {getAction(notif)}
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  )
}
