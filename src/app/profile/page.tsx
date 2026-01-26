import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Link from 'next/link'
import { format } from 'date-fns'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Badge } from '@/components/ui/badge'
import { Separator } from '@/components/ui/separator'
import { Zap, BookOpen, Trophy, Download, CheckCircle2, XCircle, Clock, ArrowRight } from 'lucide-react'
import { Button } from '@/components/ui/button'

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

  const { data: recentActivity } = await supabase
    .from('user_question_stats')
    .select(`
      updated_at,
      solved,
      failed,
      attempts,
      question:questions (
        id,
        chapter,
        subject,
        difficulty
      )
    `)
    .eq('user_id', user.id)
    .order('updated_at', { ascending: false })
    .limit(5)

  if (!profile) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh]">
        <h1 className="text-2xl font-bold mb-4">Profile not found</h1>
        <p className="text-muted-foreground">We couldn&apos;t load your profile information.</p>
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

            <Separator />

            <div className="pt-2">
              <a href="/api/export" download className="w-full block">
                <Button variant="outline" className="w-full gap-2">
                  <Download className="h-4 w-4" />
                  Export My Data
                </Button>
              </a>
              <p className="text-xs text-center text-muted-foreground mt-2">
                Download a CSV of all your questions
              </p>
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
              {recentActivity && recentActivity.length > 0 ? (
                <div className="space-y-4">
                  {recentActivity.map((activity, idx) => {
                    // Type assertion since fetch result can be generic
                    const question = activity.question as any
                    if (!question) return null

                    return (
                      <div key={idx} className="flex items-start gap-4 pb-4 border-b last:border-0 last:pb-0">
                        <div className="mt-1">
                          {activity.solved ? (
                            <CheckCircle2 className="h-5 w-5 text-green-500" />
                          ) : activity.failed ? (
                            <XCircle className="h-5 w-5 text-red-500" />
                          ) : (
                            <Clock className="h-5 w-5 text-muted-foreground" />
                          )}
                        </div>
                        <div className="flex-1 space-y-1">
                          <div className="flex items-center justify-between">
                            <p className="font-medium text-sm">
                              {activity.solved ? 'Solved' : activity.failed ? 'Attempted' : 'Practiced'}{' '}
                              <span className="text-muted-foreground">
                                {question.subject} question
                              </span>
                            </p>
                            <span className="text-xs text-muted-foreground">
                              {format(new Date(activity.updated_at), 'MMM d, h:mm a')}
                            </span>
                          </div>
                          <p className="text-sm text-muted-foreground line-clamp-1">
                            {question.chapter}
                          </p>
                        </div>
                        <Button variant="ghost" size="icon" asChild>
                          <Link href={`/dashboard/questions/${question.id}`}>
                            <ArrowRight className="h-4 w-4" />
                          </Link>
                        </Button>
                      </div>
                    )
                  })}
                </div>
              ) : (
                <p className="text-muted-foreground text-sm">No recent activity recorded.</p>
              )}
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}
