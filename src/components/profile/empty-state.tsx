'use client'

import { ReactNode } from 'react'
import { Card } from '@/components/ui/card'

interface ProfileEmptyStateProps {
  icon: ReactNode
  title: string
  description: string
}

export function ProfileEmptyState({ icon, title, description }: ProfileEmptyStateProps) {
  return (
    <Card className="flex flex-col items-center justify-center py-20 px-6 text-center border-dashed bg-card/50 border-2 rounded-3xl animate-in fade-in zoom-in-95 duration-500 shadow-lg">
      <div className="w-20 h-20 rounded-full bg-primary/5 flex items-center justify-center mb-6 border border-primary/10 shadow-inner text-primary/40">
        {icon}
      </div>
      <h3 className="text-2xl font-bold tracking-tight mb-2 text-foreground">{title}</h3>
      <p className="text-muted-foreground text-sm max-w-[320px] leading-relaxed font-medium">
        {description}
      </p>
    </Card>
  )
}
