"use client";

import { format } from "date-fns";
import { Calendar, MapPin, Link as LinkIcon, Users, Edit } from "lucide-react";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import type { UserProfile } from "@/lib/types";

interface ProfileSidebarProps {
    profile: UserProfile;
    currentUser: any;
}

export function ProfileSidebar({ profile, currentUser }: ProfileSidebarProps) {
    const isOwner = currentUser?.id === profile.user_id;

    return (
        <div className="space-y-6">
            <div className="flex flex-col gap-4">
                <div className="relative group w-fit mx-auto md:mx-0">
                    <Avatar className="w-32 h-32 md:w-64 md:h-64 border-4 border-background shadow-xl rounded-full">
                        <AvatarImage src={profile.avatar_url || ""} />
                        <AvatarFallback className="text-6xl bg-orange-100 text-orange-600">
                            {profile.display_name?.[0]?.toUpperCase() || "U"}
                        </AvatarFallback>
                    </Avatar>
                </div>

                <div className="space-y-1 text-center md:text-left">
                    <h1 className="text-2xl font-bold leading-tight">
                        {profile.display_name}
                    </h1>
                    <p className="text-xl text-muted-foreground font-light">
                        @{profile.username}
                    </p>
                </div>

                {isOwner && (
                    <Button variant="outline" className="w-full">
                        <Edit className="w-4 h-4 mr-2" />
                        Edit Profile
                    </Button>
                )}

                <div className="flex flex-col gap-2 text-sm text-muted-foreground pt-2">
                    <div className="flex items-center gap-2">
                        <Users className="w-4 h-4" />
                        <span className="font-bold text-foreground">
                            {profile.total_solved}
                        </span>{" "}
                        solved
                        <span className="mx-1">·</span>
                        <span className="font-bold text-foreground">
                            {profile.total_uploaded}
                        </span>{" "}
                        uploaded
                    </div>

                    <div className="flex items-center gap-2">
                        <Calendar className="w-4 h-4" />
                        <span>
                            Joined{" "}
                            {format(new Date(profile.created_at), "MMMM yyyy")}
                        </span>
                    </div>
                </div>
            </div>

            <div className="space-y-3 pt-4 border-t">
                <h3 className="text-sm font-semibold">Subjects</h3>
                <div className="flex flex-wrap gap-2">
                    {profile.subjects?.map((subject) => (
                        <Badge
                            key={subject}
                            variant="secondary"
                            className="bg-orange-50 text-orange-700 hover:bg-orange-100 border-orange-100"
                        >
                            {subject}
                        </Badge>
                    ))}
                </div>
            </div>
        </div>
    );
}
