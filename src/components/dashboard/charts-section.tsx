import { generateUserCharts } from '@/lib/services/charts'
import { ChartCard } from '@/components/dashboard/chart-card'
import { Skeleton } from '@/components/ui/skeleton'

export async function ChartsSection({ userId }: { userId: string }) {
  const charts = await generateUserCharts(userId)

  if (charts.length === 0) {
    return (
      <div className="text-center py-10 px-4 border rounded-2xl bg-muted/5 border-dashed">
        <p className="text-muted-foreground text-sm md:text-base max-w-[280px] mx-auto leading-relaxed">
          Upload more questions to get personalized AI practice feeds.
        </p>
      </div>
    )
  }

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {charts.map((chart) => (
        <ChartCard key={chart.id} chart={chart} />
      ))}
    </div>
  )
}

export function ChartsSkeleton() {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {[1, 2, 3].map((i) => (
        <div key={i} className="h-[180px] rounded-xl border bg-card text-card-foreground shadow">
          <div className="p-6 space-y-4">
            <div className="flex justify-between">
              <Skeleton className="h-10 w-10 rounded-lg" />
              <Skeleton className="h-5 w-24" />
            </div>
            <Skeleton className="h-6 w-3/4" />
            <Skeleton className="h-4 w-full" />
          </div>
        </div>
      ))}
    </div>
  )
}
