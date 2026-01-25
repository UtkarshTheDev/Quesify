'use client'

import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Play, TrendingUp, Zap, Target, BookOpen } from 'lucide-react'
import type { Chart } from '@/lib/types'
import Link from 'next/link'

interface ChartCardProps {
  chart: Chart
}

export function ChartCard({ chart }: ChartCardProps) {
  const icons = {
    daily_feed: TrendingUp,
    topic_review: BookOpen,
    quick_mcq: Zap,
    weak_areas: Target,
    custom: Play,
  }

  const Icon = icons[chart.type] || Play

  const colors = {
    daily_feed: 'text-blue-500 bg-blue-500/10',
    topic_review: 'text-purple-500 bg-purple-500/10',
    quick_mcq: 'text-yellow-500 bg-yellow-500/10',
    weak_areas: 'text-red-500 bg-red-500/10',
    custom: 'text-gray-500 bg-gray-500/10',
  }

  return (
    <Card className="h-full flex flex-col hover:border-primary/50 transition-colors">
      <CardHeader>
        <div className="flex justify-between items-start mb-2">
          <div className={`p-2 rounded-lg ${colors[chart.type]}`}>
            <Icon className="h-5 w-5" />
          </div>
          <Badge variant="outline">{chart.count} Questions</Badge>
        </div>
        <CardTitle className="text-lg">{chart.name}</CardTitle>
        <CardDescription className="line-clamp-2 min-h-[40px]">
          {chart.description}
        </CardDescription>
      </CardHeader>
      <CardContent className="mt-auto pt-0">
        <Button className="w-full gap-2" asChild>
          {/* Pass question IDs via URL since charts are ephemeral */}
          <Link href={`/dashboard/questions?ids=${chart.question_ids.join(',')}&title=${encodeURIComponent(chart.name)}`}>
            <Play className="h-4 w-4" />
            Start Practice
          </Link>
        </Button>
      </CardContent>
    </Card>
  )
}
