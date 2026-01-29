import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { CardContent, Card } from "@/components/ui/card";
import { AlertTriangle, ExternalLink } from "lucide-react";
import type { DuplicateCheckResult } from "@/lib/types";

interface DuplicateNotificationProps {
    duplicateCheck: DuplicateCheckResult;
    isFinalizing: boolean;
}

export function DuplicateNotification({ duplicateCheck, isFinalizing }: DuplicateNotificationProps) {
    if (!duplicateCheck?.is_duplicate || isFinalizing) return null;

    return (
        <Card className="border-none !pt-0 shadow-2xl bg-yellow-500/[0.03] ring-1 ring-yellow-500/20 overflow-hidden group">
            <div className="bg-yellow-500/10 px-6 py-3 border-b border-yellow-500/10 flex items-center justify-between">
                <div className="flex items-center gap-2 text-yellow-600">
                    <AlertTriangle className="h-4 w-4" />
                    <span className="text-[10px] font-black uppercase tracking-widest">
                        Duplicate Found
                    </span>
                </div>
                <Badge
                    variant="outline"
                    className="bg-yellow-500/10 text-yellow-600 border-yellow-500/20 text-[9px]"
                >
                    {Math.round((duplicateCheck.confidence || 0) * 100)}% Match
                </Badge>
            </div>
            <CardContent className="px-6 space-y-6">
                <div className="space-y-4">
                    <div className="flex items-center gap-3">
                        <Avatar className="h-10 w-10 ring-2 ring-yellow-500/20">
                            <AvatarImage
                                src={duplicateCheck.author?.avatar_url || ""}
                            />
                            <AvatarFallback className="bg-yellow-500/10 text-yellow-600 text-xs">
                                {(duplicateCheck.author?.display_name || "U").charAt(0)}
                            </AvatarFallback>
                        </Avatar>
                        <div className="space-y-0.5">
                            <p className="text-[10px] text-muted-foreground font-bold uppercase tracking-tight opacity-60">
                                Already Added By
                            </p>
                            <p className="text-sm font-bold text-foreground">
                                {duplicateCheck.author?.display_name || "Community Member"}
                            </p>
                        </div>
                    </div>

                    <div className="p-4 rounded-xl bg-yellow-500/[0.05] border border-yellow-500/10">
                        <p className="text-xs text-yellow-700/80 leading-relaxed font-medium italic">
                            "{duplicateCheck.differences || "This question is already available in our global question bank."}"
                        </p>
                    </div>
                </div>

                <Button
                    variant="outline"
                    className="w-full h-11 rounded-xl text-xs font-bold border-yellow-500/20 hover:bg-yellow-500/10 hover:text-yellow-600 transition-all gap-2"
                    onClick={() =>
                        window.open(
                            `/question/${duplicateCheck.matched_question_id}`,
                            "_blank",
                        )
                    }
                >
                    <ExternalLink className="h-3.5 w-3.5" />
                    View Original Question
                </Button>
            </CardContent>
        </Card>
    );
}
