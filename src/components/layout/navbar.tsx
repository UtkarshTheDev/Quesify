import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import Image from "next/image";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { cn } from "@/lib/utils";
import { Home, Upload, Zap, User, LogOut, Search } from "lucide-react";

import { NotificationBell } from "@/components/layout/notification-bell";

export async function Navbar() {
    const supabase = await createClient();
    const {
        data: { user },
    } = await supabase.auth.getUser();

    const { data: profile } = await supabase
        .from("user_profiles")
        .select("display_name, avatar_url, username, total_uploaded, streak_count")
        .eq("user_id", user?.id)
        .single();

    return (
        <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
            <div className="container mx-auto px-4 flex h-14 items-center">
                <div className="mr-4 flex">
                    <Link
                        href="/dashboard"
                        className="mr-6 flex items-center space-x-2 transition-transform hover:scale-105 active:scale-95"
                    >
                        <Image
                            src="/logo.png"
                            alt="Quesify Logo"
                            width={80}
                            height={80}
                            className="h-8 w-8 rounded-lg"
                        />
                        <span className="font-outfit font-bold text-xl tracking-tighter">
                            QUESIFY
                        </span>
                    </Link>
                    <nav className="hidden md:flex items-center space-x-6 text-sm font-medium">
                        <Link
                            href="/dashboard"
                            className="transition-colors hover:text-foreground/80 text-foreground/60"
                        >
                            <span className="flex items-center gap-2">
                                <Home className="h-4 w-4" />
                                Dashboard
                            </span>
                        </Link>
                        <Link
                            href="/upload"
                            className="transition-colors hover:text-foreground/80 text-foreground/60"
                        >
                            <span className="flex items-center gap-2">
                                <Upload className="h-4 w-4" />
                                Upload
                            </span>
                        </Link>
                        <Link
                            href="/dashboard/daily"
                            className="transition-colors hover:text-foreground/80 text-foreground/60"
                        >
                            <span className="flex items-center gap-2">
                                <Zap className="h-4 w-4" />
                                Daily Feed
                            </span>
                        </Link>
                    </nav>
                </div>

                <div className="flex flex-1 items-center justify-end space-x-2">
                    {profile && (
                        <div className="hidden md:flex items-center gap-2 text-sm text-muted-foreground mr-2">
                            <Zap className="h-4 w-4 text-orange-500" />
                            <span>{profile.streak_count} day streak</span>
                        </div>
                    )}

                    <Button variant="ghost" size="icon" asChild className="mr-1">
                        <Link href="/dashboard/search">
                            <Search className="h-5 w-5" />
                            <span className="sr-only">Search</span>
                        </Link>
                    </Button>

                    <NotificationBell userId={user?.id} />

                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button
                                variant="ghost"
                                className="relative h-8 w-8 rounded-full"
                            >
                                <Avatar className="h-8 w-8">
                                    <AvatarImage
                                        src={profile?.avatar_url || ""}
                                        alt={profile?.display_name || ""}
                                    />
                                    <AvatarFallback>
                                        {profile?.display_name?.[0]?.toUpperCase() ||
                                            "U"}
                                    </AvatarFallback>
                                </Avatar>
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent
                            className="w-56"
                            align="end"
                            forceMount
                        >
                            <div className="flex items-center justify-start gap-2 p-2">
                                <div className="flex flex-col space-y-1 leading-none">
                                    <p className="font-medium">
                                        {profile?.display_name}
                                    </p>
                                    <p className="text-xs text-muted-foreground">
                                        {profile?.total_uploaded} questions
                                        uploaded
                                    </p>
                                </div>
                            </div>
                            <DropdownMenuSeparator />
                            <DropdownMenuItem asChild>
                                <Link
                                    href={profile?.username ? `/u/${profile.username}` : "#"}
                                    className={cn("flex items-center", !profile?.username && "pointer-events-none opacity-50")}
                                >
                                    <User className="mr-2 h-4 w-4" />
                                    Profile
                                </Link>
                            </DropdownMenuItem>
                            <DropdownMenuSeparator />
                            <DropdownMenuItem asChild>
                                <form action="/auth/signout" method="post">
                                    <button className="flex w-full items-center">
                                        <LogOut className="mr-2 h-4 w-4" />
                                        Sign out
                                    </button>
                                </form>
                            </DropdownMenuItem>
                        </DropdownMenuContent>
                    </DropdownMenu>
                </div>
            </div>
        </header>
    );
}
