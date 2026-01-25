'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { Home, Upload, Zap, User } from 'lucide-react'
import { cn } from '@/lib/utils'

const navItems = [
  { href: '/dashboard', label: 'Home', icon: Home },
  { href: '/upload', label: 'Upload', icon: Upload },
  { href: '/daily', label: 'Daily', icon: Zap },
  { href: '/profile', label: 'Profile', icon: User },
]

export function MobileNav() {
  const pathname = usePathname()

  return (
    <nav className="fixed bottom-0 left-0 right-0 z-50 border-t bg-background md:hidden">
      <div className="flex items-center justify-around h-16">
        {navItems.map((item) => {
          const isActive = pathname === item.href || pathname.startsWith(`${item.href}/`)
          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                'flex flex-col items-center justify-center flex-1 h-full transition-colors',
                isActive ? 'text-foreground' : 'text-muted-foreground'
              )}
            >
              <item.icon className="h-5 w-5" />
              <span className="text-xs mt-1">{item.label}</span>
            </Link>
          )
        })}
      </div>
    </nav>
  )
}
