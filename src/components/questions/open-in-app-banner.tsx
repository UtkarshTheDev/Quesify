"use client";

import { useEffect, useState } from "react";
import { Smartphone, ExternalLink, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useIsPWA } from "@/hooks/use-is-pwa";

interface OpenInAppBannerProps {
    questionId: string;
}

export function OpenInAppBanner({ questionId }: OpenInAppBannerProps) {
    const [isVisible, setIsVisible] = useState(false);
    const isPWA = useIsPWA();

    useEffect(() => {
        if (isPWA) {
            setIsVisible(false);
            return;
        }

        const ua = navigator.userAgent.toLowerCase();
        const isAndroidDevice = /android/.test(ua);
        const isIosDevice = /iphone|ipad|ipod/.test(ua);

        if (isAndroidDevice || isIosDevice) {
            const isDismissed = sessionStorage.getItem("app_banner_dismissed");
            if (!isDismissed) {
                setTimeout(() => setIsVisible(true), 100);
            }
        }
    }, [isPWA]);

    const handleOpenInApp = () => {
        const customScheme = `quesify://question/${questionId}`;
        window.location.href = customScheme;

        setTimeout(() => {
            if (document.hasFocus()) {
                console.log("App likely not installed or didn't open");
            }
        }, 2500);
    };

    const handleDismiss = () => {
        setIsVisible(false);
        sessionStorage.setItem("app_banner_dismissed", "true");
    };

    if (!isVisible) return null;

    return (
        <div className="fixed bottom-4 left-4 right-4 z-[100] animate-in slide-in-from-bottom-8 duration-500">
            <div className="bg-orange-600 text-white p-4 rounded-2xl shadow-2xl flex items-center justify-between gap-4 border border-white/20">
                <div className="flex items-center gap-3">
                    <div className="bg-white/20 p-2 rounded-xl">
                        <Smartphone className="w-5 h-5" />
                    </div>
                    <div>
                        <p className="font-bold text-sm">Open in Quesify App</p>
                        <p className="text-xs opacity-90">Better experience for practice</p>
                    </div>
                </div>

                <div className="flex items-center gap-2">
                    <Button
                        size="sm"
                        variant="secondary"
                        className="rounded-full bg-white text-orange-600 hover:bg-white/90 font-bold px-4"
                        onClick={handleOpenInApp}
                    >
                        Open <ExternalLink className="w-3 h-3 ml-1" />
                    </Button>
                    <button
                        onClick={handleDismiss}
                        className="p-1 hover:bg-white/10 rounded-full transition-colors"
                    >
                        <X className="w-5 h-5" />
                    </button>
                </div>
            </div>
        </div>
    );
}
