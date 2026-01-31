'use client'

import { Clock, Sparkles, BookOpen, ArrowRight } from 'lucide-react'
import { Card, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import Link from 'next/link'

export default function DailyFeedPage() {
  return (
    <div className="min-h-screen bg-background">
      <div className="max-w-4xl mx-auto px-4 py-16 md:py-24">
        <div className="text-center space-y-6 mb-16">
          <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-orange-500/10 border border-orange-500/20 text-orange-500">
            <Sparkles className="w-4 h-4" />
            <span className="text-sm font-semibold">Coming Soon</span>
          </div>
          
          <h1 className="text-4xl md:text-6xl font-bold tracking-tight">
            Daily Feed
          </h1>
          
          <p className="text-lg md:text-xl text-muted-foreground max-w-2xl mx-auto leading-relaxed">
            Get personalized questions delivered to you every day based on your 
            weak areas and learning patterns.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-16">
          <Card className="border-orange-500/20 bg-gradient-to-br from-orange-500/5 to-transparent">
            <CardContent className="p-6 space-y-4">
              <div className="w-12 h-12 rounded-xl bg-orange-500/10 flex items-center justify-center">
                <Clock className="w-6 h-6 text-orange-500" />
              </div>
              <h3 className="font-semibold text-lg">Daily Practice</h3>
              <p className="text-sm text-muted-foreground">
                Fresh questions every day tailored to your schedule and goals
              </p>
            </CardContent>
          </Card>

          <Card className="border-orange-500/20 bg-gradient-to-br from-orange-500/5 to-transparent">
            <CardContent className="p-6 space-y-4">
              <div className="w-12 h-12 rounded-xl bg-orange-500/10 flex items-center justify-center">
                <Sparkles className="w-6 h-6 text-orange-500" />
              </div>
              <h3 className="font-semibold text-lg">AI Powered</h3>
              <p className="text-sm text-muted-foreground">
                Smart recommendations based on your performance and weak areas
              </p>
            </CardContent>
          </Card>

          <Card className="border-orange-500/20 bg-gradient-to-br from-orange-500/5 to-transparent">
            <CardContent className="p-6 space-y-4">
              <div className="w-12 h-12 rounded-xl bg-orange-500/10 flex items-center justify-center">
                <BookOpen className="w-6 h-6 text-orange-500" />
              </div>
              <h3 className="font-semibold text-lg">Track Progress</h3>
              <p className="text-sm text-muted-foreground">
                Monitor your improvement with detailed analytics and insights
              </p>
            </CardContent>
          </Card>
        </div>

        <div className="text-center space-y-6">
          <p className="text-muted-foreground">
            We&apos;re working hard to bring this feature to you. 
            Stay tuned for updates!
          </p>
          
          <Button 
            asChild
            className="bg-orange-500 hover:bg-orange-600 text-white px-8 py-6 text-lg rounded-xl shadow-lg shadow-orange-500/20"
          >
            <Link href="/dashboard" className="gap-2">
              Go to Dashboard
              <ArrowRight className="w-5 h-5" />
            </Link>
          </Button>
        </div>

        <div className="absolute inset-0 -z-10 overflow-hidden pointer-events-none">
          <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-orange-500/5 rounded-full blur-3xl" />
          <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-orange-500/5 rounded-full blur-3xl" />
        </div>
      </div>
    </div>
  )
}
