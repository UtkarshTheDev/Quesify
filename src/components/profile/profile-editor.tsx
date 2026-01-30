'use client'

import { useState, useTransition } from 'react'
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Badge } from '@/components/ui/badge'
import { Loader2, Check } from 'lucide-react'
import { updateProfile } from '@/app/actions/profile'
import { toast } from 'sonner'
import { cn } from '@/lib/utils'

interface ProfileEditorProps {
  profile: any
  isOpen: boolean
  onClose: () => void
}

const AVAILABLE_SUBJECTS = ['Mathematics', 'Physics', 'Chemistry']

export function ProfileEditor({ profile, isOpen, onClose }: ProfileEditorProps) {
  const [isPending, startTransition] = useTransition()
  const [formData, setFormData] = useState({
    display_name: profile.display_name || '',
    username: profile.username || '',
    subjects: profile.subjects || []
  })

  const toggleSubject = (subject: string) => {
    setFormData(prev => ({
      ...prev,
      subjects: prev.subjects.includes(subject)
        ? prev.subjects.filter((s: string) => s !== subject)
        : [...prev.subjects, subject]
    }))
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    
    if (!formData.username) return toast.error('Username is required')
    if (formData.username.length < 3) return toast.error('Username too short')

    startTransition(async () => {
      try {
        await updateProfile(profile.user_id, formData)
        toast.success('Profile updated successfully')
        onClose()
      } catch (error: any) {
        toast.error(error.message || 'Failed to update profile')
      }
    })
  }

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="sm:max-w-[450px]">
        <DialogHeader>
          <DialogTitle className="text-xl font-bold">Edit Profile</DialogTitle>
        </DialogHeader>

        <form onSubmit={handleSubmit} className="space-y-6 pt-4">
          <div className="space-y-2">
            <Label htmlFor="display_name" className="text-sm font-bold uppercase tracking-wider text-muted-foreground">
              Full Name
            </Label>
            <Input 
              id="display_name"
              placeholder="Your Name"
              className="bg-muted/50 h-12 border-none font-medium"
              value={formData.display_name}
              onChange={(e) => setFormData(prev => ({ ...prev, display_name: e.target.value }))}
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="username" className="text-sm font-bold uppercase tracking-wider text-muted-foreground">
              Username
            </Label>
            <div className="relative">
              <span className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground font-bold text-sm">@</span>
              <Input 
                id="username"
                placeholder="username"
                className="bg-muted/50 h-12 border-none pl-8 font-medium"
                value={formData.username}
                onChange={(e) => setFormData(prev => ({ ...prev, username: e.target.value.toLowerCase().replace(/[^a-z0-9_]/g, '') }))}
              />
            </div>
          </div>

          <div className="space-y-3">
            <Label className="text-sm font-bold uppercase tracking-wider text-muted-foreground">
              Interested Subjects
            </Label>
            <div className="flex flex-wrap gap-2">
              {AVAILABLE_SUBJECTS.map((subject) => {
                const isSelected = formData.subjects.includes(subject)
                return (
                  <Badge
                    key={subject}
                    variant={isSelected ? "default" : "outline"}
                    className={cn(
                      "px-4 py-2 text-sm font-bold rounded-xl cursor-pointer transition-all border-2",
                      isSelected 
                        ? "bg-orange-500 hover:bg-orange-600 border-orange-500 shadow-md shadow-orange-500/20" 
                        : "bg-muted/30 border-transparent hover:border-orange-500/30"
                    )}
                    onClick={() => toggleSubject(subject)}
                  >
                    {subject}
                    {isSelected && <Check className="ml-2 h-3 w-3" />}
                  </Badge>
                )
              })}
            </div>
          </div>

          <div className="pt-4 flex gap-3">
             <Button 
                type="button" 
                variant="ghost" 
                className="flex-1 h-12 font-bold"
                onClick={onClose}
             >
               Cancel
             </Button>
             <Button 
                type="submit" 
                className="flex-[2] h-12 bg-orange-500 hover:bg-orange-600 font-bold shadow-lg shadow-orange-500/20"
                disabled={isPending}
             >
               {isPending ? <Loader2 className="w-5 h-5 animate-spin" /> : 'Save Changes'}
             </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  )
}
