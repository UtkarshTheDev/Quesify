import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { BookOpen, GitFork, LayoutDashboard } from 'lucide-react'
import { ContributionGraph } from '@/components/profile/contribution-graph'
import { ProfileSidebar } from '@/components/profile/profile-sidebar'
import { InfiniteActivityFeed } from '@/components/profile/infinite-activity-feed'
import { InfiniteProfileQuestions } from '@/components/profile/infinite-profile-questions'
import { InfiniteProfileSolutions } from '@/components/profile/infinite-profile-solutions'
import type { Metadata } from 'next'

export const revalidate = 60

interface PageProps {
  params: Promise<{ username: string }>
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { username } = await params
  return {
    title: `${username} - Quesify Profile`,
    description: `Check out ${username}'s contributions on Quesify.`
  }
}

export default async function PublicProfilePage({ params }: PageProps) {
  const { username } = await params
  const supabase = await createClient()

  const { data: profile } = await supabase
    .from('user_profiles')
    .select('*')
    .eq('username', username)
    .single()

  if (!profile) return notFound()

  const { data: { user: currentUser } } = await supabase.auth.getUser()

  // eslint-disable-next-line react-hooks/purity -- Date.now is safe in server components
  const oneYearAgo = new Date(Date.now() - 365 * 24 * 60 * 60 * 1000).toISOString()

  const { data: allActivityCounts } = await supabase
    .from('user_activities')
    .select('created_at')
    .eq('user_id', profile.user_id)
    .gte('created_at', oneYearAgo)

  const contributionCounts: Record<string, number> = {}
  allActivityCounts?.forEach(act => {
    const date = act.created_at.split('T')[0]
    contributionCounts[date] = (contributionCounts[date] || 0) + 1
  })

  const graphData = Object.entries(contributionCounts).map(([date, count]) => ({ date, count }))
  const totalContributions = allActivityCounts?.length || 0

  return (
    <div className="max-w-7xl mx-auto px-4 py-12 pb-32 md:pb-12 overflow-x-hidden">
      <div className="grid grid-cols-1 md:grid-cols-4 gap-16">
        <div className="md:col-span-1">
           <ProfileSidebar profile={profile} currentUser={currentUser} />
        </div>

        <div className="md:col-span-3 space-y-12">
          <Tabs defaultValue="overview" className="w-full">
            <div className="sticky top-0 bg-background/95 backdrop-blur z-20 border-b mb-8">
              <TabsList className="w-full justify-start h-16 p-0 bg-transparent gap-10 overflow-x-auto no-scrollbar">
                <TabsTrigger 
                  value="overview"
                  className="rounded-none border-b-2 border-transparent data-[state=active]:border-orange-500 data-[state=active]:shadow-none h-full px-2 bg-transparent font-bold text-base md:text-lg flex items-center gap-3 transition-all duration-300 hover:text-orange-500/80 data-[state=active]:text-orange-500"
                >
                  <LayoutDashboard className="w-5 h-5 md:w-6 h-6" />
                  <span>Overview</span>
                </TabsTrigger>
                <TabsTrigger 
                  value="questions"
                  className="rounded-none border-b-2 border-transparent data-[state=active]:border-orange-500 data-[state=active]:shadow-none h-full px-2 bg-transparent font-bold text-base md:text-lg flex items-center gap-3 transition-all duration-300 hover:text-orange-500/80 data-[state=active]:text-orange-500"
                >
                  <BookOpen className="w-5 h-5 md:w-6 h-6" />
                  <span>Questions</span>
                  <span className="bg-muted px-2.5 py-1 rounded-full text-[11px] font-black flex items-center justify-center min-w-6 h-6">
                    {profile.total_uploaded}
                  </span>
                </TabsTrigger>
                <TabsTrigger 
                  value="solutions"
                  className="rounded-none border-b-2 border-transparent data-[state=active]:border-orange-500 data-[state=active]:shadow-none h-full px-2 bg-transparent font-bold text-base md:text-lg flex items-center gap-3 transition-all duration-300 hover:text-orange-500/80 data-[state=active]:text-orange-500"
                >
                  <GitFork className="w-5 h-5 md:w-6 h-6" />
                  <span>Solutions</span>
                  <span className="bg-muted px-2.5 py-1 rounded-full text-[11px] font-black flex items-center justify-center min-w-6 h-6">
                    {profile.total_solved}
                  </span>
                </TabsTrigger>
              </TabsList>
            </div>

            <TabsContent value="overview" className="space-y-12 mt-0 animate-in fade-in duration-500">
               <div className="space-y-8">
                 <div className="flex items-center justify-between">
                   <div className="space-y-1">
                     <h2 className="text-xl font-bold tracking-tight">Contributions Heatmap</h2>
                     <p className="text-sm text-muted-foreground">Your platform activity over the past year</p>
                   </div>
                   <div className="text-xs text-muted-foreground font-bold uppercase tracking-wider bg-muted/40 px-4 py-2 rounded-xl border border-border/50">
                     365 Days
                   </div>
                 </div>
                 <div className="border rounded-3xl p-8 md:p-10 bg-card/30 backdrop-blur-sm shadow-xl shadow-orange-500/5">
                   <ContributionGraph data={graphData} totalContributions={totalContributions} />
                 </div>
               </div>

               <div className="space-y-8">
                 <h2 className="text-xl font-bold tracking-tight">Activity Timeline</h2>
                 <div className="pl-2">
                   <InfiniteActivityFeed userId={profile.user_id} />
                 </div>
               </div>
            </TabsContent>

            <TabsContent value="questions" className="space-y-8 mt-0 animate-in fade-in duration-500">
              <InfiniteProfileQuestions userId={profile.user_id} />
            </TabsContent>

            <TabsContent value="solutions" className="space-y-6 pt-8 mt-0 animate-in fade-in slide-in-from-bottom-4 duration-500">
               <InfiniteProfileSolutions 
                  userId={profile.user_id} 
                  currentUserId={currentUser?.id || null} 
                />
            </TabsContent>
          </Tabs>
        </div>
      </div>
    </div>
  )
}
