'use client'

import { useState, useEffect } from 'react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import type { UserProfile } from '@/lib/types'
import { toast } from 'sonner'

interface EditProfileDialogProps {
  profile: UserProfile
  open: boolean
  onOpenChange: (open: boolean) => void
  onProfileUpdate: (profile: UserProfile) => void
}

export function EditProfileDialog({
  profile,
  open,
  onOpenChange,
  onProfileUpdate
}: EditProfileDialogProps) {
  const [displayName, setDisplayName] = useState(profile.display_name || '')
  const [username, setUsername] = useState(profile.username || '')
  const [selectedSubjects, setSelectedSubjects] = useState<string[]>(profile.subjects || [])
  const [availableSubjects, setAvailableSubjects] = useState<string[]>([])
  const [isLoadingSubjects, setIsLoadingSubjects] = useState(true)
  const [isSaving, setIsSaving] = useState(false)

  useEffect(() => {
    const fetchSubjects = async () => {
      try {
        const response = await fetch('/api/subjects')
        const data = await response.json()
        if (data.subjects) {
          setAvailableSubjects(data.subjects)
        }
      } catch {
        toast.error('Failed to load subjects')
      } finally {
        setIsLoadingSubjects(false)
      }
    }

    if (open) {
      fetchSubjects()
    }
  }, [open])

  const toggleSubject = (subject: string) => {
    setSelectedSubjects(prev =>
      prev.includes(subject)
        ? prev.filter(s => s !== subject)
        : [...prev, subject]
    )
  }

  const handleSave = async () => {
    setIsSaving(true)
    try {
      const response = await fetch('/api/profile', {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          display_name: displayName,
          username: username,
          subjects: selectedSubjects
        })
      })

      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.error || 'Failed to update profile')
      }

      toast.success('Profile updated successfully')
      onProfileUpdate(data.data)
      onOpenChange(false)
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to update profile')
    } finally {
      setIsSaving(false)
    }
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[425px] bg-background border-border">
        <DialogHeader>
          <DialogTitle className="text-xl font-bold">Edit Profile</DialogTitle>
        </DialogHeader>

        <div className="space-y-6 pt-4">
          <div className="space-y-2">
            <Label htmlFor="displayName" className="text-xs font-bold uppercase tracking-wider text-muted-foreground">
              Full Name
            </Label>
            <Input
              id="displayName"
              value={displayName}
              onChange={(e) => setDisplayName(e.target.value)}
              className="border-orange-500/30 focus:border-orange-500 focus:ring-orange-500/20 shadow-[0_0_0_1px_rgba(249,115,22,0.1)] focus:shadow-[0_0_0_3px_rgba(249,115,22,0.1)]"
              placeholder="Enter your full name"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="username" className="text-xs font-bold uppercase tracking-wider text-muted-foreground">
              Username
            </Label>
            <div className="relative">
              <span className="absolute left-3 top-1/2 -translate-y-1/2 text-orange-500 font-bold">@</span>
              <Input
                id="username"
                value={username}
                onChange={(e) => setUsername(e.target.value.toLowerCase())}
                className="pl-8 border-orange-500/30 focus:border-orange-500 focus:ring-orange-500/20 shadow-[0_0_0_1px_rgba(249,115,22,0.1)] focus:shadow-[0_0_0_3px_rgba(249,115,22,0.1)]"
                placeholder="username"
              />
            </div>
          </div>

          <div className="space-y-3">
            <Label className="text-xs font-bold uppercase tracking-wider text-muted-foreground">
              Interested Subjects
            </Label>
            <div className="flex flex-wrap gap-2">
              {isLoadingSubjects ? (
                <span className="text-sm text-muted-foreground">Loading subjects...</span>
              ) : (
                availableSubjects.map((subject: string) => (
                  <button
                    key={subject}
                    onClick={() => toggleSubject(subject)}
                    className={`px-3 py-1.5 rounded-full text-sm font-medium transition-all border ${
                      selectedSubjects.includes(subject)
                        ? 'bg-orange-500 text-white border-orange-500 shadow-[0_2px_8px_rgba(249,115,22,0.3)]'
                        : 'bg-background text-foreground border-orange-500/30 hover:border-orange-500/60 shadow-[0_1px_3px_rgba(249,115,22,0.1)]'
                    }`}
                  >
                    {subject}
                    {selectedSubjects.includes(subject) && (
                      <span className="ml-1.5">✓</span>
                    )}
                  </button>
                ))
              )}
            </div>
          </div>

          <div className="flex gap-3 pt-4">
            <Button
              variant="outline"
              onClick={() => onOpenChange(false)}
              className="flex-1"
            >
              Cancel
            </Button>
            <Button
              onClick={handleSave}
              disabled={isSaving}
              className="flex-1 bg-orange-500 hover:bg-orange-600 text-white"
            >
              {isSaving ? 'Saving...' : 'Save Changes'}
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  )
}
