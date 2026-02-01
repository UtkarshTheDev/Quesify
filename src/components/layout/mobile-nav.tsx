"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { Home, Upload, Zap, User } from "lucide-react";
import { cn } from "@/lib/utils";
import { createClient } from "@/lib/supabase/client";

export function MobileNav() {
    const pathname = usePathname();
    const [username, setUsername] = useState<string | null>(null);
    const supabase = createClient();

    useEffect(() => {
        const getProfile = async () => {
            const {
                data: { user },
            } = await supabase.auth.getUser();
            if (user) {
                const { data: profile } = await supabase
                    .from("user_profiles")
                    .select("username")
                    .eq("user_id", user.id)
                    .single();
                if (profile?.username) setUsername(profile.username);
            }
        };
        getProfile();
    }, [supabase]);

    const navItems = [
        { href: "/dashboard", label: "Home", icon: Home },
        { href: "/upload", label: "Upload", icon: Upload },
        { href: "/dashboard/daily", label: "Daily", icon: Zap },
        {
            href: username ? `/u/${username}` : "#",
            label: "Profile",
            icon: User,
        },
    ];

    return (
        <nav className="fixed bottom-0 left-0 right-0 z-50 border-t bg-background md:hidden">
            <div className="flex items-center justify-around h-16">
                {navItems.map((item) => {
                    const isActive =
                        pathname === item.href ||
                        pathname.startsWith(`${item.href}/`);
                    return (
                        <Link
                            key={item.label}
                            href={item.href}
                            className={cn(
                                "flex flex-col items-center justify-center flex-1 h-full transition-colors",
                                isActive
                                    ? "text-foreground"
                                    : "text-muted-foreground",
                                item.href === "#" &&
                                    "pointer-events-none opacity-50",
                            )}
                        >
                            <item.icon className="h-5 w-5" />
                            <span className="text-xs mt-1">{item.label}</span>
                        </Link>
                    );
                })}
            </div>
        </nav>
    );
}
