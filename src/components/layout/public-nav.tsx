"use client";

import Link from "next/link";
import { Hash } from "lucide-react";
import { Button } from "@/components/ui/button";

interface PublicNavProps {
    userId?: string | null;
}

export function PublicNav({ userId }: PublicNavProps) {
    return (
        <nav className="sticky top-0 z-50 w-full border-b bg-background/80 backdrop-blur-md">
            <div className="container mx-auto flex h-16 items-center justify-between px-4">
                <Link
                    href="/"
                    className="flex items-center gap-2 group transition-transform hover:scale-105 active:scale-95"
                >
                    <div className="h-8 w-8 rounded-lg overflow-hidden transition-transform group-hover:rotate-3">
                        <img
                            src="/logo.png"
                            alt="Quesify Logo"
                            className="h-full w-full object-cover"
                        />
                    </div>
                    <span className="font-outfit text-xl font-black tracking-tighter text-foreground">
                        QUESIFY
                    </span>
                </Link>

                <div className="flex items-center gap-4">
                    {userId ? (
                        <Link href="/dashboard">
                            <Button
                                variant="outline"
                                size="sm"
                                className="font-bold rounded-full px-6"
                            >
                                Go to Dashboard
                            </Button>
                        </Link>
                    ) : (
                        <>
                            <Link href="/login">
                                <Button
                                    variant="ghost"
                                    size="sm"
                                    className="font-bold"
                                >
                                    Login
                                </Button>
                            </Link>
                            <Link href="/login?signup=true">
                                <Button
                                    size="sm"
                                    className="font-bold px-6 rounded-full"
                                >
                                    Sign Up Free
                                </Button>
                            </Link>
                        </>
                    )}
                </div>
            </div>
        </nav>
    );
}
