'use client'

import { format } from 'date-fns'
import { Calendar, Edit, Share2, Link as LinkIcon, Check } from 'lucide-react'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Button } from '@/components/ui/button'
import { FollowButton } from './follow-button'
import { SocialModal } from './social-modal'
import { ProfileEditor } from './profile-editor'
import type { UserProfile } from '@/lib/types'
import { useState } from 'react'
import { toast } from 'sonner'

interface ProfileSidebarProps {
  profile: UserProfile
  currentUser: any
  followersCount: number
  followingCount: number
  isFollowing: boolean
  availableSubjects: string[]
}

export function ProfileSidebar({ 
  profile, 
  currentUser, 
  followersCount, 
  followingCount,
  isFollowing,
  availableSubjects
}: ProfileSidebarProps) {
  const isOwner = currentUser?.id === profile.user_id
  const [socialModal, setSocialModal] = useState<{ isOpen: boolean, type: 'followers' | 'following' }>({
    isOpen: false,
    type: 'followers'
  })
  const [isEditorOpen, setIsEditorOpen] = useState(false)
  const [isCopied, setIsCopied] = useState(false)

  const handleShare = () => {
    const url = window.location.href
    navigator.clipboard.writeText(url)
    setIsCopied(true)
    toast.success('Profile link copied to clipboard')
    setTimeout(() => setIsCopied(false), 2000)
  }

  return (
    <div className="space-y-8 flex flex-col items-center">
      <ProfileEditor 
        profile={profile}
        isOpen={isEditorOpen}
        onClose={() => setIsEditorOpen(false)}
        availableSubjects={availableSubjects}
      />
      <SocialModal 
        userId={profile.user_id}
        type={socialModal.type}
        isOpen={socialModal.isOpen}
        onClose={() => setSocialModal(prev => ({ ...prev, isOpen: false }))}
        currentUserId={currentUser?.id || null}
      />
      
      <div className="flex flex-col items-center gap-4 text-center">
        <div className="relative group">
          <Avatar className="w-32 h-32 md:w-64 md:h-64 border-4 border-background shadow-xl rounded-full transition-transform duration-500 hover:scale-[1.02]">
            <AvatarImage src={profile.avatar_url || ''} />
            <AvatarFallback className="text-6xl bg-orange-100 text-orange-600">
              {profile.display_name?.[0]?.toUpperCase() || 'U'}
            </AvatarFallback>
          </Avatar>
        </div>

        <div className="space-y-1">
          <h1 className="text-3xl md:text-4xl font-bold leading-tight tracking-tight">{profile.display_name}</h1>
          <p className="text-lg text-muted-foreground font-medium">@{profile.username}</p>
        </div>
      </div>

      <div className="w-full max-w-sm flex gap-3">
        {isOwner ? (
          <Button 
            variant="outline" 
            className="flex-1 font-bold border-border/60 hover:bg-muted/50 h-11"
            onClick={() => setIsEditorOpen(true)}
          >
            <Edit className="w-4 h-4 mr-2" />
            Edit Profile
          </Button>
        ) : (
          <div className="flex-1">
            <FollowButton 
              followingId={profile.user_id} 
              initialIsFollowing={isFollowing} 
              className="h-11 text-base w-full"
            />
          </div>
        )}
        <Button
          variant="outline"
          size="icon"
          className="h-11 w-11 shrink-0 border-border/60 hover:bg-muted/50"
          onClick={handleShare}
        >
          {isCopied ? <Check className="w-4 h-4 text-emerald-500" /> : <Share2 className="w-4 h-4" />}
        </Button>
      </div>

      <div className="w-full max-w-2xl grid grid-cols-4 gap-2 md:gap-8 py-8 border-y border-border/40">
        <div className="flex flex-col items-center gap-1 group cursor-pointer" onClick={() => setSocialModal({ isOpen: true, type: 'followers' })}>
          <span className="text-xl md:text-3xl font-bold text-foreground group-hover:text-primary transition-colors">{followersCount}</span>
          <span className="text-[10px] md:text-sm font-medium text-muted-foreground uppercase tracking-wider text-center line-clamp-1 w-full">Followers</span>
        </div>
        
        <div className="flex flex-col items-center gap-1 group cursor-pointer" onClick={() => setSocialModal({ isOpen: true, type: 'following' })}>
          <span className="text-xl md:text-3xl font-bold text-foreground group-hover:text-primary transition-colors">{followingCount}</span>
          <span className="text-[10px] md:text-sm font-medium text-muted-foreground uppercase tracking-wider text-center line-clamp-1 w-full">Following</span>
        </div>

        <div className="flex flex-col items-center gap-1">
          <span className="text-xl md:text-3xl font-bold text-emerald-500">{profile.total_solved}</span>
          <span className="text-[10px] md:text-sm font-medium text-muted-foreground uppercase tracking-wider text-center line-clamp-1 w-full">Solved</span>
        </div>

        <div className="flex flex-col items-center gap-1">
          <span className="text-xl md:text-3xl font-bold text-blue-500">{profile.total_uploaded}</span>
          <span className="text-[10px] md:text-sm font-medium text-muted-foreground uppercase tracking-wider text-center line-clamp-1 w-full">Uploaded</span>
        </div>
      </div>

      <div className="flex items-center gap-2 text-sm font-medium text-muted-foreground/60">
        <Calendar className="w-4 h-4" />
        <span>Joined {format(new Date(profile.created_at), 'MMMM yyyy')}</span>
      </div>
    </div>
  )
}
