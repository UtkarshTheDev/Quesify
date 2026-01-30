'use client'

import { useState, useTransition } from 'react'
import { useRouter } from 'next/navigation'
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
  availableSubjects: string[]
}

export function ProfileEditor({ profile, isOpen, onClose, availableSubjects }: ProfileEditorProps) {
  const router = useRouter()
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
        
        if (profile.username !== formData.username) {
          router.push(`/u/${formData.username}`)
        }
        
        onClose()
      } catch (error: any) {
        toast.error(error.message || 'Failed to update profile')
      }
    })
  }

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="sm:max-w-[450px] p-6 gap-6">
        <DialogHeader>
          <DialogTitle className="text-xl font-bold tracking-tight">Edit Profile</DialogTitle>
        </DialogHeader>

        <form onSubmit={handleSubmit} className="space-y-6">
          <div className="space-y-2">
            <Label htmlFor="display_name" className="text-xs font-semibold uppercase tracking-wider text-muted-foreground/80">
              Full Name
            </Label>
            <Input 
              id="display_name"
              placeholder="Your Name"
              className="bg-muted/30 h-11 border-border/60 focus:border-primary/50 focus:ring-primary/20 transition-all font-medium"
              value={formData.display_name}
              onChange={(e) => setFormData(prev => ({ ...prev, display_name: e.target.value }))}
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="username" className="text-xs font-semibold uppercase tracking-wider text-muted-foreground/80">
              Username
            </Label>
            <div className="relative">
              <span className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground font-medium text-sm">@</span>
              <Input 
                id="username"
                placeholder="username"
                className="bg-muted/30 h-11 border-border/60 pl-8 focus:border-primary/50 focus:ring-primary/20 transition-all font-medium"
                value={formData.username}
                onChange={(e) => setFormData(prev => ({ ...prev, username: e.target.value.toLowerCase().replace(/[^a-z0-9_]/g, '') }))}
              />
            </div>
          </div>

          <div className="space-y-3">
            <Label className="text-xs font-semibold uppercase tracking-wider text-muted-foreground/80">
              Interested Subjects
            </Label>
            <div className="flex flex-wrap gap-2">
              {availableSubjects.map((subject: string) => {
                const isSelected = formData.subjects.includes(subject)
                return (
                  <Badge
                    key={subject}
                    variant={isSelected ? "default" : "outline"}
                    className={cn(
                      "px-3 py-1.5 text-sm font-medium rounded-lg cursor-pointer transition-all border",
                      isSelected 
                        ? "bg-primary text-primary-foreground border-primary hover:bg-primary/90" 
                        : "bg-transparent border-border hover:bg-muted/50 text-muted-foreground hover:text-foreground"
                    )}
                    onClick={() => toggleSubject(subject)}
                  >
                    {subject}
                    {isSelected && <Check className="ml-1.5 h-3 w-3" />}
                  </Badge>
                )
              })}
            </div>
          </div>

          <div className="pt-2 flex gap-3">
             <Button 
                type="button" 
                variant="ghost" 
                className="flex-1 h-11 font-semibold"
                onClick={onClose}
             >
               Cancel
             </Button>
             <Button 
                type="submit" 
                className="flex-[2] h-11 font-bold bg-primary hover:bg-primary/90"
                disabled={isPending}
             >
               {isPending ? <Loader2 className="w-4 h-4 animate-spin mr-2" /> : null}
               Save Changes
             </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  )
}
