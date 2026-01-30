'use client'

import { useState, useMemo } from 'react'
import { formatDistanceToNow, format } from 'date-fns'
import { 
  Link2, Lightbulb, CheckCircle2, PlusCircle, 
  Loader2, Edit3, Trash2, ChevronDown, ChevronRight, History 
} from 'lucide-react'
import Link from 'next/link'
import { cn } from '@/lib/utils'
import { Latex } from '@/components/ui/latex'
import { ProfileEmptyState } from './empty-state'

export type ActivityType = 
  | 'created_question' | 'contributed_solution' | 'solved_question' | 'added_to_bank'
  | 'question_created' | 'solution_contributed' | 'question_solved' | 'question_forked' 
  | 'hint_updated' | 'question_deleted' | 'solution_deleted'

export interface ActivityItem {
  id: string
  type: ActivityType
  date: string
  title: string
  url: string
  meta?: string
  metadata?: any
}

interface ActivityFeedProps {
  items: ActivityItem[]
}

interface GroupedActivity {
  id: string
  type: ActivityType
  subject: string
  date: string
  items: ActivityItem[]
}

export function ActivityFeed({ items }: ActivityFeedProps) {
  const [expandedGroups, setExpandedGroups] = useState<Record<string, boolean>>({})

  const groupedActivities = useMemo(() => {
    const groups: GroupedActivity[] = []
    
    items.forEach(item => {
      const dateKey = format(new Date(item.date), 'yyyy-MM-dd')
      
      let subject = item.metadata?.subject || 'General'
      if (subject.toLowerCase().startsWith('math')) subject = 'Mathematics'
      
      let type = item.type
      if (type === 'created_question') type = 'question_created'
      if (type === 'added_to_bank') type = 'question_forked'
      if (type === 'contributed_solution') type = 'solution_contributed'
      if (type === 'solved_question') type = 'question_solved'

      const groupKey = `${dateKey}-${type}-${subject}`
      
      const existingGroup = groups.find(g => {
        let gType = g.type
        if (gType === 'created_question') gType = 'question_created'
        if (gType === 'added_to_bank') gType = 'question_forked'
        if (gType === 'contributed_solution') gType = 'solution_contributed'
        if (gType === 'solved_question') gType = 'question_solved'

        return format(new Date(g.date), 'yyyy-MM-dd') === dateKey && 
               gType === type && 
               g.subject === subject
      })
      
      if (existingGroup) {
        existingGroup.items.push(item)
      } else {
        groups.push({
          id: groupKey,
          type: type,
          subject: subject,
          date: item.date,
          items: [item]
        })
      }
    })
    
    return groups
  }, [items])

  if (items.length === 0) {
    return (
      <ProfileEmptyState 
        icon={History}
        title="No recent activity"
        description="User hasn't performed any actions on the platform yet."
      />
    )
  }

  const toggleGroup = (groupId: string) => {
    setExpandedGroups(prev => ({
      ...prev,
      [groupId]: !prev[groupId]
    }))
  }

  const getIcon = (type: ActivityType) => {
    switch (type) {
      case 'created_question':
      case 'question_created':
        return <PlusCircle className="w-5 h-5 text-emerald-500" />
      case 'contributed_solution':
      case 'solution_contributed':
        return <Lightbulb className="w-5 h-5 text-orange-500" />
      case 'solved_question':
      case 'question_solved':
        return <CheckCircle2 className="w-5 h-5 text-blue-500" />
      case 'added_to_bank':
      case 'question_forked':
        return <Link2 className="w-5 h-5 text-purple-500" />
      case 'hint_updated':
        return <Edit3 className="w-5 h-5 text-amber-500" />
      case 'question_deleted':
      case 'solution_deleted':
        return <Trash2 className="w-5 h-5 text-red-500" />
    }
  }

  const getGroupLabel = (group: GroupedActivity) => {
    const count = group.items.length
    const s = count > 1 ? 's' : ''
    
    switch (group.type) {
      case 'created_question':
      case 'question_created':
        return { action: `Created ${count} question${s} in`, subject: group.subject }
      case 'contributed_solution':
      case 'solution_contributed':
        return { action: `Contributed ${count} solution${s} to`, subject: group.subject }
      case 'solved_question':
      case 'question_solved':
        return { action: `Solved ${count} question${s} in`, subject: group.subject }
      case 'added_to_bank':
      case 'question_forked':
        return { action: `Added ${count} question${s} to bank in`, subject: group.subject }
      case 'hint_updated':
        return { action: `Updated hints for ${count} question${s} in`, subject: group.subject }
      case 'question_deleted':
        return { action: `Deleted ${count} question${s} in`, subject: group.subject }
      case 'solution_deleted':
        return { action: `Deleted ${count} solution${s} in`, subject: group.subject }
      default:
        return { action: `${count} activities in`, subject: group.subject }
    }
  }

  return (
    <div className="space-y-0">
      {groupedActivities.map((group, index) => {
        const isExpanded = expandedGroups[group.id] || group.items.length === 1
        const canExpand = group.items.length > 1
        const label = getGroupLabel(group)

        return (
          <div key={group.id} className="flex gap-6 pb-10 relative group last:pb-0">
            {index !== groupedActivities.length - 1 && (
              <div className="absolute left-[23px] top-12 bottom-0 w-px bg-border/60 group-hover:bg-primary/20 transition-colors" />
            )}

            <div 
              className={cn(
                "relative z-10 w-12 h-12 rounded-2xl border bg-card flex items-center justify-center shrink-0 shadow-sm transition-all duration-300",
                canExpand && "cursor-pointer hover:border-primary/40 hover:shadow-md active:scale-95"
              )}
              onClick={() => canExpand && toggleGroup(group.id)}
            >
              {getIcon(group.type)}
            </div>

            <div className="flex-1 pt-1 space-y-4">
              <div className="flex items-center justify-between">
                <div 
                  className={cn(
                    "flex items-center gap-2 group/label transition-all",
                    canExpand && "cursor-pointer hover:text-primary active:opacity-70"
                  )}
                  onClick={() => canExpand && toggleGroup(group.id)}
                >
                  <div className="flex items-center gap-1.5">
                    <span className="text-xs md:text-sm font-bold uppercase tracking-widest text-muted-foreground/80 group-hover/label:text-primary transition-colors">
                      {label.action} <span className="text-foreground">{label.subject}</span>
                    </span>
                    {canExpand && (
                      <div className="flex items-center gap-1 ml-1 px-1.5 py-0.5 rounded bg-muted text-[10px] font-black text-muted-foreground group-hover/label:bg-primary/10 group-hover/label:text-primary transition-colors">
                        {isExpanded ? <ChevronDown className="w-3 h-3" /> : <ChevronRight className="w-3 h-3" />}
                      </div>
                    )}
                  </div>
                </div>
                <span className="text-[11px] font-medium text-muted-foreground/60 whitespace-nowrap ml-4">
                  {formatDistanceToNow(new Date(group.date), { addSuffix: true })}
                </span>
              </div>
              
              {isExpanded && (
                <div className="grid grid-cols-1 gap-4 animate-in fade-in slide-in-from-top-2 duration-500">
                  {group.items.map((item) => (
                    <Link key={item.id} href={item.url} className="block group/card">
                      <div className="p-5 md:p-6 rounded-2xl border bg-card/40 hover:bg-card hover:border-primary/30 hover:shadow-lg hover:-translate-y-0.5 transition-all duration-300 space-y-3">
                        <div className="font-bold text-base md:text-lg group-hover/card:text-primary transition-colors line-clamp-1 leading-tight">
                          {item.title}
                        </div>
                        {item.meta && (
                          <div className="text-sm md:text-base text-muted-foreground/80 leading-relaxed line-clamp-3 prose prose-invert max-w-none font-medium">
                            <Latex>{item.meta}</Latex>
                          </div>
                        )}
                      </div>
                    </Link>
                  ))}
                </div>
              )}
            </div>
          </div>
        )
      })}
    </div>
  )
}
