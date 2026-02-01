"use client";

import { WifiOff } from "lucide-react";
import { Button } from "@/components/ui/button";
import Link from "next/link";

export default function OfflinePage() {
    return (
        <div className="min-h-screen flex flex-col items-center justify-center p-4 text-center">
            <div className="bg-orange-500/10 p-6 rounded-full mb-6">
                <WifiOff className="w-12 h-12 text-orange-600" />
            </div>
            <h1 className="text-3xl font-bold mb-2">You&apos;re Offline</h1>
            <p className="text-muted-foreground mb-8 max-w-xs">
                It looks like you don&apos;t have an internet connection right now. 
                Some parts of the app may still work if you&apos;ve visited them recently.
            </p>
            <div className="flex flex-col gap-3 w-full max-w-xs">
                <Button asChild className="bg-orange-600 hover:bg-orange-700 text-white font-bold h-12 rounded-xl">
                    <Link href="/dashboard">Go to Dashboard</Link>
                </Button>
                <Button variant="ghost" onClick={() => window.location.reload()}>
                    Try Refreshing
                </Button>
            </div>
        </div>
    );
}
