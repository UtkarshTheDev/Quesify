import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Badge } from '@/components/ui/badge'
import { Separator } from '@/components/ui/separator'
import { User, Zap, BookOpen, Trophy } from 'lucide-react'

export default async function ProfilePage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    redirect('/login')
  }

  const { data: profile } = await supabase
    .from('user_profiles')
    .select('*')
    .eq('user_id', user.id)
    .single()

  if (!profile) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh]">
        <h1 className="text-2xl font-bold mb-4">Profile not found</h1>
        <p className="text-muted-foreground">We couldn't load your profile information.</p>
      </div>
    )
  }

  return (
    <div className="max-w-4xl mx-auto space-y-8">
      <div className="flex flex-col md:flex-row gap-8 items-start">
        {/* Profile Card */}
        <Card className="w-full md:w-1/3">
          <CardHeader className="flex flex-col items-center text-center pb-2">
            <Avatar className="h-24 w-24 mb-4">
              <AvatarImage src={profile.avatar_url || ''} />
              <AvatarFallback className="text-2xl">
                {profile.display_name?.[0]?.toUpperCase() || 'U'}
              </AvatarFallback>
            </Avatar>
            <CardTitle className="text-2xl">{profile.display_name}</CardTitle>
            <p className="text-sm text-muted-foreground">{user.email}</p>
          </CardHeader>
          <CardContent className="space-y-6">
            <div className="flex items-center justify-center gap-2 text-sm">
              <Badge variant="secondary" className="px-4 py-1">
                Member since {new Date(user.created_at).toLocaleDateString()}
              </Badge>
            </div>

            <Separator />

            <div className="grid grid-cols-2 gap-4 text-center">
              <div className="space-y-1">
                <div className="text-2xl font-bold">{profile.total_uploaded}</div>
                <div className="text-xs text-muted-foreground uppercase tracking-wider">Uploaded</div>
              </div>
              <div className="space-y-1">
                <div className="text-2xl font-bold">{profile.total_solved}</div>
                <div className="text-xs text-muted-foreground uppercase tracking-wider">Solved</div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Stats & Achievements */}
        <div className="flex-1 w-full space-y-6">
          <h2 className="text-2xl font-bold">Stats & Activity</h2>

          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            <Card>
              <CardContent className="pt-6 flex flex-col items-center text-center space-y-2">
                <div className="p-3 rounded-full bg-yellow-500/10 text-yellow-500">
                  <Zap className="h-6 w-6" />
                </div>
                <div className="font-bold text-xl">{profile.streak_count} Days</div>
                <div className="text-xs text-muted-foreground">Current Streak</div>
              </CardContent>
            </Card>

            <Card>
              <CardContent className="pt-6 flex flex-col items-center text-center space-y-2">
                <div className="p-3 rounded-full bg-blue-500/10 text-blue-500">
                  <BookOpen className="h-6 w-6" />
                </div>
                <div className="font-bold text-xl">{profile.solutions_helped_count}</div>
                <div className="text-xs text-muted-foreground">Solutions Contributed</div>
              </CardContent>
            </Card>

            <Card>
              <CardContent className="pt-6 flex flex-col items-center text-center space-y-2">
                <div className="p-3 rounded-full bg-purple-500/10 text-purple-500">
                  <Trophy className="h-6 w-6" />
                </div>
                <div className="font-bold text-xl">N/A</div>
                <div className="text-xs text-muted-foreground">Global Rank</div>
              </CardContent>
            </Card>
          </div>

          <Card>
            <CardHeader>
              <CardTitle>Recent Activity</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-muted-foreground text-sm">No recent activity recorded.</p>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}
