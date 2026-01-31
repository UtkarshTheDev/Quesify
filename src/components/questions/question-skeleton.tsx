'use client'

import { Card, CardContent, CardHeader } from '@/components/ui/card'
import { Skeleton } from '@/components/ui/skeleton'
import { ArrowLeft, Share2, Hash } from 'lucide-react'
import { Button } from '@/components/ui/button'

interface QuestionSkeletonProps {
  isPublic?: boolean
}

export function QuestionSkeleton({ isPublic = false }: QuestionSkeletonProps) {
  return (
    <div className="max-w-6xl mx-auto space-y-6 animate-in fade-in duration-500">
      <div className="flex items-center justify-between">
        <Button variant="ghost" size="sm" className="gap-2" disabled>
          <ArrowLeft className="h-4 w-4" />
          Back
        </Button>

        <div className="flex items-center gap-2">
          {isPublic && (
            <Button
              variant="default"
              size="sm"
              className="gap-2 font-bold bg-primary/50 rounded-full"
              disabled
            >
              <Hash className="h-4 w-4" />
              Add to Bank
            </Button>
          )}
          <Button
            variant="outline"
            size="sm"
            className="gap-2"
            disabled
          >
            <Share2 className="h-4 w-4" />
            Share
          </Button>
        </div>
      </div>

      {isPublic && (
        <div className="flex items-center gap-3 py-2">
          <Skeleton className="h-10 w-10 rounded-full" />
          <div className="space-y-1.5">
            <Skeleton className="h-4 w-32" />
            <Skeleton className="h-3 w-20" />
          </div>
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-10 gap-6">
        <div className="md:col-span-7 space-y-6">
          <Card className="overflow-hidden border-border/60">
            <CardHeader className="pb-4">
              <div className="flex items-start justify-between gap-4">
                <div className="space-y-3 flex-1">
                  <div className="flex items-center gap-2">
                    <Skeleton className="h-6 w-24 rounded-full" />
                    <Skeleton className="h-6 w-20 rounded-full" />
                  </div>
                  <Skeleton className="h-7 w-3/4" />
                </div>
                <Skeleton className="h-9 w-9 rounded-md shrink-0" />
              </div>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="space-y-2">
                <Skeleton className="h-5 w-full" />
                <Skeleton className="h-5 w-[95%]" />
                <Skeleton className="h-5 w-[90%]" />
                <Skeleton className="h-5 w-[85%]" />
              </div>

              <div className="space-y-3 pt-2">
                <Skeleton className="h-4 w-16" />
                <div className="grid gap-2">
                  {[...Array(4)].map((_, i) => (
                    <div 
                      key={i} 
                      className="p-3 rounded-md bg-muted/30 border border-transparent flex gap-3"
                    >
                      <Skeleton className="h-5 w-6 shrink-0" />
                      <Skeleton className="h-5 flex-1" />
                    </div>
                  ))}
                </div>
              </div>

              <Skeleton className="h-[200px] w-full rounded-lg" />
            </CardContent>
          </Card>

          <Card className="border-border/60">
            <CardHeader className="pb-2">
              <div className="flex items-center gap-2 border-b pb-2">
                <Skeleton className="h-9 w-28 rounded-md" />
                <Skeleton className="h-9 w-28 rounded-md" />
                <Skeleton className="h-9 w-28 rounded-md" />
              </div>
            </CardHeader>
            <CardContent className="pt-4 space-y-4">
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <Skeleton className="h-6 w-6 rounded-full" />
                    <Skeleton className="h-4 w-24" />
                  </div>
                  <Skeleton className="h-8 w-20 rounded-full" />
                </div>
                <div className="space-y-2">
                  <Skeleton className="h-4 w-full" />
                  <Skeleton className="h-4 w-[95%]" />
                  <Skeleton className="h-4 w-[90%]" />
                  <Skeleton className="h-4 w-[85%]" />
                  <Skeleton className="h-4 w-[80%]" />
                </div>
                <div className="flex items-center gap-2 pt-2">
                  <Skeleton className="h-9 w-24 rounded-md" />
                  <Skeleton className="h-9 w-24 rounded-md" />
                  <Skeleton className="h-9 w-24 rounded-md" />
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        <div className="md:col-span-3 space-y-6">
          <Card className="border-border/60">
            <CardHeader className="pb-3">
              <Skeleton className="h-5 w-28" />
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <Skeleton className="h-3 w-12" />
                  <Skeleton className="h-5 w-20" />
                </div>
                <div className="space-y-1.5">
                  <Skeleton className="h-3 w-12" />
                  <Skeleton className="h-5 w-8" />
                </div>
              </div>
              <div className="h-px bg-border/60" />
              <div className="space-y-1.5">
                <Skeleton className="h-3 w-24" />
                <div className="flex items-center gap-2">
                  <Skeleton className="h-4 w-4 rounded-full" />
                  <Skeleton className="h-4 w-28" />
                </div>
              </div>
              <Skeleton className="h-10 w-full rounded-md" />
            </CardContent>
          </Card>

          <Card className="border-border/60">
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <Skeleton className="h-5 w-20" />
              <Skeleton className="h-6 w-6 rounded-md" />
            </CardHeader>
            <CardContent className="space-y-4 mt-2">
              <div className="space-y-2">
                <Skeleton className="h-3 w-12" />
                <div className="flex flex-wrap gap-2">
                  <Skeleton className="h-6 w-20 rounded-full" />
                  <Skeleton className="h-6 w-24 rounded-full" />
                  <Skeleton className="h-6 w-16 rounded-full" />
                </div>
              </div>
              <div className="space-y-1.5">
                <Skeleton className="h-3 w-8" />
                <div className="flex items-center gap-2">
                  <Skeleton className="h-4 w-4 rounded-full" />
                  <Skeleton className="h-4 w-24" />
                </div>
              </div>
              <div className="space-y-1.5">
                <Skeleton className="h-3 w-16" />
                <div className="flex items-center gap-2">
                  <Skeleton className="h-4 w-4 rounded-full" />
                  <Skeleton className="h-4 w-28" />
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}
