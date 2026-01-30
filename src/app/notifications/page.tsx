import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import { getNotifications, markAllAsRead } from '@/app/actions/notifications'
import { Bell, Check, UserPlus, ThumbsUp, GitFork, Link as LinkIcon } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { formatDistanceToNow } from 'date-fns'
import { ProfileEmptyState } from '@/components/profile/empty-state'
import { cn } from '@/lib/utils'
import Link from 'next/link'
import { Navbar } from '@/components/layout/navbar'
import { MobileNav } from '@/components/layout/mobile-nav'

export default async function NotificationsPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/')

  const notifications = await getNotifications(50)

  const getIcon = (type: string) => {
    switch (type) {
      case 'follow': return <UserPlus className="h-5 w-5 text-blue-500" />
      case 'solution_like': return <ThumbsUp className="h-5 w-5 text-orange-500" />
      case 'solution_linked': return <LinkIcon className="h-5 w-5 text-purple-500" />
      case 'new_contribution': return <GitFork className="h-5 w-5 text-emerald-500" />
      default: return <Bell className="h-5 w-5 text-primary" />
    }
  }

  const getContent = (notification: any) => {
    switch (notification.type) {
      case 'follow': return `started following you`
      case 'solution_like': return `liked your solution`
      case 'solution_linked': return `linked to your question`
      case 'new_contribution': return `added a solution to your question`
      default: return `sent you a notification`
    }
  }

  const getActionLabel = (type: string) => {
    switch (type) {
      case 'follow': return 'View Profile'
      case 'solution_like': return 'View Solution'
      case 'solution_linked': return 'View Question'
      case 'new_contribution': return 'View Solution'
      default: return 'View Details'
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
    <div className="min-h-screen flex flex-col bg-background">
      <Navbar />
      <main className="flex-1 container mx-auto px-4 py-12 max-w-3xl pb-32">
        <div className="flex items-center justify-between mb-10">
          <div className="space-y-1">
            <h1 className="text-3xl font-bold tracking-tight">Notifications</h1>
            <p className="text-muted-foreground">Stay updated with your social activity</p>
          </div>
          {notifications.length > 0 && (
            <form action={async () => {
              'use server'
              await markAllAsRead()
            }}>
              <Button variant="outline" className="font-bold border-border/60 hover:bg-muted/50 rounded-xl">
                <Check className="w-4 h-4 mr-2" />
                Mark all as read
              </Button>
            </form>
          )}
        </div>

        {notifications.length === 0 ? (
          <ProfileEmptyState 
            icon={<Bell className="w-10 h-10" />}
            title="All caught up!"
            description="You don't have any notifications at the moment. Interactions with your profile will appear here."
          />
        ) : (
          <div className="grid gap-4">
            {notifications.map((n) => (
              <div 
                key={n.id} 
                className={cn(
                  "flex items-center gap-4 p-5 rounded-3xl border transition-all duration-300 relative overflow-hidden group",
                  n.is_read 
                    ? "bg-card/30 border-border/40" 
                    : "bg-orange-500/5 border-orange-500/20 shadow-lg shadow-orange-500/5"
                )}
              >
                {!n.is_read && (
                  <div className="absolute left-0 top-0 bottom-0 w-1.5 bg-orange-500 shadow-[0_0_15px_rgba(249,115,22,0.5)]" />
                )}
                
                <Link href={`/u/${n.sender?.username}`} className="shrink-0">
                  <Avatar className="h-12 w-12 border-2 border-background shadow-md">
                    <AvatarImage src={n.sender?.avatar_url || ''} />
                    <AvatarFallback className="bg-muted font-bold text-muted-foreground uppercase">
                      {n.sender?.display_name?.[0] || 'U'}
                    </AvatarFallback>
                  </Avatar>
                </Link>

                <div className="flex-1 min-w-0 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                  <div className="space-y-1.5">
                    <p className="text-sm md:text-base leading-snug">
                      <Link href={`/u/${n.sender?.username}`} className="font-bold text-foreground hover:text-orange-500 transition-colors">
                        @{n.sender?.username || 'user'}
                      </Link>{' '}
                      <span className="text-muted-foreground">
                        {getContent(n)}
                      </span>
                    </p>
                    
                    <div className="flex items-center gap-3">
                      <div className="flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-muted/30 border text-[10px] font-black uppercase tracking-widest text-muted-foreground">
                        {getIcon(n.type)}
                        {n.type.replace('_', ' ')}
                      </div>
                      <span className="text-[10px] font-bold text-muted-foreground/40 whitespace-nowrap uppercase tracking-tighter">
                        {formatDistanceToNow(new Date(n.created_at), { addSuffix: true })}
                      </span>
                    </div>
                  </div>

                  <Button variant="outline" size="sm" className="h-9 px-4 shrink-0 font-bold border-border/60 hover:bg-muted/50 whitespace-nowrap ml-auto sm:ml-0" asChild>
                    <Link href={getUrl(n)}>
                      {getActionLabel(n.type)}
                    </Link>
                  </Button>
                </div>
              </div>
            ))}
          </div>
        )}
      </main>
      <MobileNav />
    </div>
  )
}
