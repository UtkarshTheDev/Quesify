'use client'

import { LucideIcon } from 'lucide-react'
import { Card } from '@/components/ui/card'

interface ProfileEmptyStateProps {
  icon: LucideIcon
  title: string
  description: string
}

export function ProfileEmptyState({ icon: Icon, title, description }: ProfileEmptyStateProps) {
  return (
    <div className="flex flex-col items-center justify-center py-20 px-6 text-center border-2 border-dashed border-border/60 rounded-[2rem] bg-zinc-900/50 backdrop-blur-sm shadow-xl animate-in fade-in duration-700">
      <div className="w-20 h-20 rounded-3xl bg-orange-500/10 flex items-center justify-center mb-8 border border-orange-500/20 shadow-[0_0_20px_rgba(249,115,22,0.1)]">
        <Icon className="w-10 h-10 text-orange-500/60" />
      </div>
      <h3 className="text-2xl font-bold tracking-tight mb-3 text-stone-100">{title}</h3>
      <p className="text-stone-400 text-sm max-w-[340px] leading-relaxed font-medium">
        {description}
      </p>
    </div>
  )
}
