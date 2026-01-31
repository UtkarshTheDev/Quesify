'use client'

import { useState, useEffect } from 'react'
import { Share2, Link2, Check, Twitter, Facebook } from 'lucide-react'
import { Button } from '@/components/ui/button'
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
import { toast } from 'sonner'

interface ShareProfileProps {
  username: string
}

export function ShareProfile({ username }: ShareProfileProps) {
  const [isOpen, setIsOpen] = useState(false)
  const [hasCopied, setHasCopied] = useState(false)
  const [profileUrl, setProfileUrl] = useState('')

  useEffect(() => {
    if (typeof window !== 'undefined') {
      setProfileUrl(`${window.location.origin}/u/${username}`)
    }
  }, [username])

  const copyToClipboard = () => {
    navigator.clipboard.writeText(profileUrl)
    setHasCopied(true)
    toast.success('Link copied to clipboard')
    setTimeout(() => setHasCopied(false), 2000)
  }

  const shareTwitter = () => {
    window.open(`https://twitter.com/intent/tweet?url=${encodeURIComponent(profileUrl)}&text=Check out ${username}'s profile on Quesify!`, '_blank')
  }

  const shareFacebook = () => {
    window.open(`https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(profileUrl)}`, '_blank')
  }

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <DialogTrigger asChild>
        <Button variant="outline" size="icon" className="shrink-0 hover:bg-orange-50 hover:text-orange-500 hover:border-orange-200 transition-colors">
          <Share2 className="h-4 w-4" />
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle>Share Profile</DialogTitle>
        </DialogHeader>
        <div className="flex flex-col gap-4 py-4">
          <div className="flex items-center gap-2">
            <div className="grid flex-1 gap-2">
              <Input
                id="link"
                defaultValue={profileUrl}
                readOnly
                className="bg-muted text-muted-foreground"
              />
            </div>
            <Button size="icon" onClick={copyToClipboard} className={hasCopied ? "bg-green-500 hover:bg-green-600" : "bg-orange-500 hover:bg-orange-600"}>
              {hasCopied ? <Check className="h-4 w-4 text-white" /> : <Link2 className="h-4 w-4 text-white" />}
            </Button>
          </div>
          <div className="grid grid-cols-2 gap-2">
            <Button variant="outline" className="w-full gap-2" onClick={shareTwitter}>
              <Twitter className="h-4 w-4 text-blue-400" />
              Twitter
            </Button>
            <Button variant="outline" className="w-full gap-2" onClick={shareFacebook}>
              <Facebook className="h-4 w-4 text-blue-600" />
              Facebook
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  )
}
