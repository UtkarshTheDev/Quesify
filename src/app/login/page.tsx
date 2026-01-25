import { LoginButton } from '@/components/auth/login-button'

export default function LoginPage() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-4">
      <div className="w-full max-w-md space-y-8 text-center">
        <div className="space-y-2">
          <h1 className="text-4xl font-bold tracking-tight">Quesify</h1>
          <p className="text-muted-foreground">
            AI-Powered Question Bank for Smart Practice
          </p>
        </div>

        <div className="space-y-4">
          <div className="space-y-2 text-sm text-muted-foreground">
            <p>Upload question screenshots</p>
            <p>AI auto-organizes them perfectly</p>
            <p>Get personalized daily practice feeds</p>
          </div>
        </div>

        <div className="pt-4">
          <LoginButton />
        </div>

        <p className="text-xs text-muted-foreground">
          By continuing, you agree to our Terms of Service and Privacy Policy
        </p>
      </div>
    </div>
  )
}
