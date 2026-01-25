import { createClient } from '@/lib/supabase/server'
import { Button } from '@/components/ui/button'
import { Upload } from 'lucide-react'
import Link from 'next/link'

export default async function DashboardPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  // Get user's questions count
  const { count: questionCount } = await supabase
    .from('user_questions')
    .select('*', { count: 'exact', head: true })
    .eq('user_id', user?.id)

  if (!questionCount || questionCount === 0) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh] text-center space-y-6">
        <div className="space-y-2">
          <h1 className="text-3xl font-bold">Welcome to Quesify!</h1>
          <p className="text-muted-foreground max-w-md">
            Upload your first question screenshot to get started. Our AI will organize it automatically.
          </p>
        </div>

        <Button asChild size="lg">
          <Link href="/upload" className="flex items-center gap-2">
            <Upload className="h-5 w-5" />
            Upload Your First Question
          </Link>
        </Button>
      </div>
    )
  }

  // TODO: Render subjects and charts when user has questions
  return (
    <div className="space-y-8">
      <section>
        <h2 className="text-2xl font-bold mb-4">Your Subjects</h2>
        <p className="text-muted-foreground">Coming soon...</p>
      </section>

      <section>
        <h2 className="text-2xl font-bold mb-4">Today&apos;s Charts</h2>
        <p className="text-muted-foreground">Coming soon...</p>
      </section>
    </div>
  )
}
