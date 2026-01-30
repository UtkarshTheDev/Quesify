'use client'

import { format } from 'date-fns'
import { Calendar, Users, Edit, UserCheck } from 'lucide-react'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { FollowButton } from './follow-button'
import { SocialModal } from './social-modal'
import { ProfileEditor } from './profile-editor'
import type { UserProfile } from '@/lib/types'
import { useState } from 'react'

interface ProfileSidebarProps {
  profile: UserProfile
  currentUser: any
  followersCount: number
  followingCount: number
  isFollowing: boolean
}

export function ProfileSidebar({ 
  profile, 
  currentUser, 
  followersCount, 
  followingCount,
  isFollowing
}: ProfileSidebarProps) {
  const isOwner = currentUser?.id === profile.user_id
  const [socialModal, setSocialModal] = useState<{ isOpen: boolean, type: 'followers' | 'following' }>({
    isOpen: false,
    type: 'followers'
  })
  const [isEditorOpen, setIsEditorOpen] = useState(false)

  return (
    <div className="space-y-6">
      <ProfileEditor 
        profile={profile}
        isOpen={isEditorOpen}
        onClose={() => setIsEditorOpen(false)}
      />
      <SocialModal 
        userId={profile.user_id}
        type={socialModal.type}
        isOpen={socialModal.isOpen}
        onClose={() => setSocialModal(prev => ({ ...prev, isOpen: false }))}
        currentUserId={currentUser?.id || null}
      />
      <div className="flex flex-col gap-4">
        <div className="relative group w-fit mx-auto md:mx-0">
          <Avatar className="w-32 h-32 md:w-64 md:h-64 border-4 border-background shadow-xl rounded-full transition-transform duration-500 group-hover:scale-[1.02]">
            <AvatarImage src={profile.avatar_url || ''} />
            <AvatarFallback className="text-6xl bg-orange-100 text-orange-600">
              {profile.display_name?.[0]?.toUpperCase() || 'U'}
            </AvatarFallback>
          </Avatar>
        </div>

        <div className="space-y-1 text-center md:text-left">
          <h1 className="text-2xl font-bold leading-tight">{profile.display_name}</h1>
          <p className="text-xl text-muted-foreground font-light tracking-tight">@{profile.username}</p>
        </div>

        <div className="pt-2">
          {isOwner ? (
            <Button 
              variant="outline" 
              className="w-full font-bold border-border/60 hover:bg-muted/50"
              onClick={() => setIsEditorOpen(true)}
            >
              <Edit className="w-4 h-4 mr-2" />
              Edit Profile
            </Button>
          ) : (
            <FollowButton 
              followingId={profile.user_id} 
              initialIsFollowing={isFollowing} 
            />
          )}
        </div>

        <div className="flex flex-wrap justify-center md:justify-start gap-y-2 gap-x-4 text-sm text-muted-foreground pt-2">
            <button 
              className="flex items-center gap-1.5 hover:text-foreground transition-colors group"
              onClick={() => setSocialModal({ isOpen: true, type: 'followers' })}
            >
              <span className="font-bold text-foreground group-hover:text-primary transition-colors">{followersCount}</span> 
              <span>followers</span>
            </button>
            <button 
              className="flex items-center gap-1.5 hover:text-foreground transition-colors group"
              onClick={() => setSocialModal({ isOpen: true, type: 'following' })}
            >
              <span className="font-bold text-foreground group-hover:text-primary transition-colors">{followingCount}</span> 
              <span>following</span>
            </button>
        </div>

        <div className="flex flex-col gap-2.5 text-sm text-muted-foreground pt-4 border-t border-border/40">
            <div className="flex items-center gap-2.5">
              <div className="w-8 h-8 rounded-lg bg-muted/30 flex items-center justify-center shrink-0">
                <UserCheck className="w-4 h-4 text-emerald-500" />
              </div>
              <div>
                <span className="font-bold text-foreground">{profile.total_solved}</span> solved
                <span className="mx-1.5 text-muted-foreground/30">·</span>
                <span className="font-bold text-foreground">{profile.total_uploaded}</span> uploaded
              </div>
            </div>
          
          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-lg bg-muted/30 flex items-center justify-center shrink-0">
              <Calendar className="w-4 h-4 text-orange-500" />
            </div>
            <span>Joined {format(new Date(profile.created_at), 'MMMM yyyy')}</span>
          </div>
        </div>
      </div>

      <div className="space-y-3 pt-6 border-t border-border/40">
        <h3 className="text-xs font-black uppercase tracking-widest text-muted-foreground/60">Subjects</h3>
        <div className="flex flex-wrap gap-2">
          {profile.subjects?.map((subject) => (
            <Badge key={subject} variant="secondary" className="bg-orange-500/5 text-orange-500 hover:bg-orange-500/10 border-orange-500/10 px-3 py-1 text-[11px] font-bold">
              {subject}
            </Badge>
          ))}
        </div>
      </div>
    </div>
  )
}
