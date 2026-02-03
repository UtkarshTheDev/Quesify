"use client";

import { Smartphone, Download, Check, Sparkles } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { useState, useEffect } from "react";
import Link from "next/link";
import { useIsPWA } from "@/hooks/use-is-pwa";

export function PWAPromptCard() {
    const [isMobile, setIsMobile] = useState(false);
    const isPWA = useIsPWA();

    useEffect(() => {
        const ua = navigator.userAgent.toLowerCase();
        setIsMobile(/android|iphone|ipad|ipod/.test(ua));
    }, []);

    if (!isMobile || isPWA) return null;

    return (
        <Card className="border-dashed bg-orange-500/5 border-orange-500/20 mt-6 overflow-hidden relative group">
            <div className="absolute top-0 right-0 p-3 opacity-10 group-hover:opacity-20 transition-opacity">
                <Smartphone className="w-20 h-20 rotate-12" />
            </div>

            <CardContent className="flex flex-col items-center justify-center py-10 px-6 text-center space-y-6 relative z-10">
                <div className="h-16 w-16 rounded-2xl bg-orange-500/10 flex items-center justify-center border border-orange-500/20 shadow-inner">
                    <Sparkles className="h-8 w-8 text-orange-500" />
                </div>

                <div className="space-y-2">
                    <h3 className="font-black text-xl tracking-tight">Upgrade Your Experience</h3>
                    <p className="text-sm text-muted-foreground max-w-[280px] mx-auto leading-relaxed">
                        Install the Quesify App for faster performance, offline access, and a better study workflow.
                    </p>
                </div>

                <div className="flex flex-col w-full gap-3">
                    <Button asChild className="bg-orange-600 hover:bg-orange-700 text-white font-bold h-12 rounded-xl shadow-lg shadow-orange-600/20">
                        <Link href="/download">
                            <Download className="w-4 h-4 mr-2" />
                            Get the App
                        </Link>
                    </Button>
                    <div className="flex items-center justify-center gap-4 text-[10px] font-bold uppercase tracking-widest text-muted-foreground/60">
                        <div className="flex items-center gap-1">
                            <Check className="w-3 h-3 text-green-500" />
                            <span>Android APK</span>
                        </div>
                        <div className="flex items-center gap-1">
                            <Check className="w-3 h-3 text-green-500" />
                            <span>PWA Support</span>
                        </div>
                    </div>
                </div>
            </CardContent>
        </Card>
    );
}
