import { Suspense } from "react";
import Image from "next/image";
import { LoginButton } from "@/components/auth/login-button";

export default function LoginPage() {
    return (
        <div className="min-h-screen flex flex-col items-center justify-center p-4">
            <div className="w-full max-w-md space-y-8 text-center">
                <div className="space-y-4">
                    <div className="flex justify-center flex-col items-center gap-4">
                        <Image
                            src="/logo.png"
                            alt="Quesify Logo"
                            width={80}
                            height={80}
                            className="h-20 w-20 rounded-2xl shadow-2xl"
                        />
                        <h1 className="font-outfit text-5xl font-black tracking-tighter">
                            QUESIFY
                        </h1>
                    </div>
                    <p className="text-muted-foreground text-lg">
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
                    <Suspense
                        fallback={
                            <div className="h-10 w-full max-w-sm bg-muted animate-pulse rounded-md mx-auto" />
                        }
                    >
                        <LoginButton />
                    </Suspense>
                </div>

                <p className="text-xs text-muted-foreground">
                    By continuing, you agree to our Terms of Service and Privacy
                    Policy
                </p>
            </div>
        </div>
    );
}
