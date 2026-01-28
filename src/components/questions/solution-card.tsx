"use client";

import { useState, useEffect } from "react";
import { format } from "date-fns";
import {
    Edit,
    Trash2,
    MoreVertical,
    Loader2,
    Clock,
    ThumbsUp,
    Sparkles,
    CheckCircle2,
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { Card, CardHeader, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Textarea } from "@/components/ui/textarea";
import { Latex } from "@/components/ui/latex";
import { SolutionSteps } from "./solution-steps";
import { AIContentAssistant } from "@/components/ai/content-assistant";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import type { Solution } from "@/lib/types";
import { toast } from "sonner";
import { cn } from "@/lib/utils";

interface SolutionCardProps {
    solution: Solution & {
        author?: { display_name: string | null; avatar_url: string | null };
    };
    currentUserId: string | null;
    onDelete?: (id: string) => void;
    onUpdate?: () => void;
    isHighlighted?: boolean;
}

export function SolutionCard({
    solution,
    currentUserId,
    onDelete,
    onUpdate,
    isHighlighted,
}: SolutionCardProps) {
    const [isEditing, setIsEditing] = useState(false);
    const [isSaving, setIsSaving] = useState(false);
    const [isLiking, setIsLiking] = useState(false);
    const [liked, setLiked] = useState(false);
    const [likesCount, setLikesCount] = useState(solution.likes || 0);
    const [editedText, setEditedText] = useState(solution.solution_text);

    useEffect(() => {
        setEditedText(solution.solution_text);
    }, [solution.solution_text]);

    useEffect(() => {
        setLikesCount(solution.likes || 0);
    }, [solution.likes]);

    useEffect(() => {
        if (currentUserId) {
            fetch(`/api/solutions/${solution.id}/like`)
                .then((res) => res.json())
                .then((data) => setLiked(data.liked))
                .catch(() => {});
        }
    }, [solution.id, currentUserId]);

    const isOwner = currentUserId === solution.contributor_id;

    const handleLike = async () => {
        if (!currentUserId) {
            toast.error("Please login to like solutions");
            return;
        }

        if (isLiking) return;

        const prevLiked = liked;
        const prevLikes = likesCount;

        setLiked(!prevLiked);
        setLikesCount((prev) =>
            !prevLiked ? prev + 1 : Math.max(0, prev - 1),
        );
        setIsLiking(true);

        try {
            const response = await fetch(`/api/solutions/${solution.id}/like`, {
                method: "POST",
            });
            const data = await response.json();
            if (data.success) {
                setLiked(data.liked);
                setLikesCount(data.likes);
            } else {
                throw new Error("Failed");
            }
        } catch {
            setLiked(prevLiked);
            setLikesCount(prevLikes);
            toast.error("Failed to update like");
        } finally {
            setIsLiking(false);
        }
    };

    const handleSave = async () => {
        setIsSaving(true);
        try {
            const response = await fetch(`/api/solutions/${solution.id}`, {
                method: "PATCH",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ solution_text: editedText }),
            });

            if (!response.ok) throw new Error("Failed to update solution");

            toast.success("Solution updated");
            setIsEditing(false);
            onUpdate?.();
        } catch {
            toast.error("Failed to update solution");
        } finally {
            setIsSaving(false);
        }
    };

    const displayDate = solution.updated_at || solution.created_at;
    const dateLabel = solution.updated_at ? "Updated" : "Posted";

    return (
        <Card
            className={cn(
                "transition-all duration-300 border shadow-sm",
                isHighlighted
                    ? "bg-card/50 border-primary/20 shadow-md ring-1 ring-primary/5"
                    : "bg-muted/10 border-border/60",
                isEditing ? "ring-2 ring-primary/30 border-primary/40" : "",
            )}
        >
            <CardHeader className="pb-3 pt-4 px-4 md:px-6">
                <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                        {!isEditing && (
                            <Avatar className="h-8 w-8 border shadow-sm">
                                <AvatarImage
                                    src={solution.author?.avatar_url || ""}
                                />
                                <AvatarFallback className="bg-muted text-muted-foreground text-[10px] font-bold">
                                    {solution.author?.display_name?.charAt(0) ||
                                        "U"}
                                </AvatarFallback>
                            </Avatar>
                        )}
                        <div className="flex flex-col gap-0.5">
                            {!isEditing && (
                                <div className="flex items-center gap-2">
                                    <span className="text-sm font-semibold">
                                        {solution.author?.display_name ||
                                            "Contributor"}
                                    </span>
                                    <Badge
                                        variant={
                                            solution.is_ai_best
                                                ? "default"
                                                : "secondary"
                                        }
                                        className="font-bold text-[10px] uppercase tracking-tight h-4 px-1.5"
                                    >
                                        {solution.is_ai_best
                                            ? "AI Best"
                                            : "Contributor"}
                                    </Badge>
                                </div>
                            )}
                            {!isEditing && (
                                <div className="flex items-center gap-1 text-[11px] text-muted-foreground/70 font-medium">
                                    <Clock className="h-3 w-3" />
                                    <span>
                                        {dateLabel}{" "}
                                        {format(
                                            new Date(displayDate),
                                            "MMM d, yyyy",
                                        )}
                                    </span>
                                </div>
                            )}
                            {isEditing && (
                                <div className="flex items-center gap-2 text-primary">
                                    <Edit className="h-4 w-4" />
                                    <span className="font-bold text-xs uppercase tracking-widest">
                                        Editor Mode
                                    </span>
                                </div>
                            )}
                        </div>
                    </div>

                    <div className="flex items-center gap-2">
                        {!isEditing && (
                            <motion.button
                                whileHover={{ scale: 1.05 }}
                                whileTap={{ scale: 0.9 }}
                                className={cn(
                                    "flex items-center gap-2 px-3 py-1.5 rounded-full transition-all border shadow-sm",
                                    liked
                                        ? "bg-primary/10 border-primary/20 text-primary"
                                        : "bg-background border-border/50 text-muted-foreground hover:bg-muted",
                                )}
                                onClick={handleLike}
                                disabled={isLiking}
                            >
                                <ThumbsUp
                                    className={cn(
                                        "h-4 w-4 transition-all",
                                        liked && "fill-current scale-110",
                                    )}
                                />
                                <AnimatePresence mode="wait">
                                    <motion.span
                                        key={likesCount}
                                        initial={{ y: 5, opacity: 0 }}
                                        animate={{ y: 0, opacity: 1 }}
                                        exit={{ y: -5, opacity: 0 }}
                                        className="text-xs font-bold tabular-nums"
                                    >
                                        {likesCount}
                                    </motion.span>
                                </AnimatePresence>
                            </motion.button>
                        )}

                        {!isEditing && isOwner && (
                            <DropdownMenu>
                                <DropdownMenuTrigger asChild>
                                    <Button
                                        variant="ghost"
                                        size="icon"
                                        className="h-8 w-8 rounded-full"
                                    >
                                        <MoreVertical className="h-4 w-4" />
                                    </Button>
                                </DropdownMenuTrigger>
                                <DropdownMenuContent
                                    align="end"
                                    className="rounded-xl"
                                >
                                    <DropdownMenuItem
                                        onClick={() => setIsEditing(true)}
                                    >
                                        <Edit className="h-4 w-4 mr-2" />
                                        Edit
                                    </DropdownMenuItem>
                                    <DropdownMenuItem
                                        className="text-destructive"
                                        onClick={() => onDelete?.(solution.id)}
                                    >
                                        <Trash2 className="h-4 w-4 mr-2" />
                                        Delete
                                    </DropdownMenuItem>
                                </DropdownMenuContent>
                            </DropdownMenu>
                        )}
                    </div>
                </div>
            </CardHeader>
            <CardContent className="space-y-6 overflow-x-auto pb-8 px-4 md:px-6">
                {isEditing ? (
                    <div className="space-y-6 animate-in fade-in zoom-in-95 duration-200">
                        <Tabs defaultValue="preview" className="w-full">
                            <div className="flex items-center justify-between mb-4">
                                <TabsList className="bg-muted/50 p-1 h-10">
                                    <TabsTrigger
                                        value="preview"
                                        className="px-4 text-xs font-bold uppercase tracking-widest"
                                    >
                                        Preview
                                    </TabsTrigger>
                                    <TabsTrigger
                                        value="edit"
                                        className="px-4 text-xs font-bold uppercase tracking-widest"
                                    >
                                        Write
                                    </TabsTrigger>
                                </TabsList>

                                <div className="flex items-center gap-2">
                                    <Button
                                        variant="ghost"
                                        size="sm"
                                        className="h-8 text-xs rounded-full"
                                        onClick={() => setIsEditing(false)}
                                    >
                                        Cancel
                                    </Button>
                                    <Button
                                        size="sm"
                                        onClick={handleSave}
                                        disabled={isSaving}
                                        className="h-8 text-xs rounded-full px-4"
                                    >
                                        {isSaving ? (
                                            <Loader2 className="h-3 w-3 animate-spin mr-2" />
                                        ) : (
                                            <CheckCircle2 className="h-3 w-3 mr-2" />
                                        )}
                                        Save
                                    </Button>
                                </div>
                            </div>

                            <TabsContent
                                value="edit"
                                className="mt-0 focus-visible:outline-none"
                            >
                                <Textarea
                                    value={editedText}
                                    onChange={(e) =>
                                        setEditedText(e.target.value)
                                    }
                                    className="min-h-[400px] font-mono resize-y rounded-xl bg-muted/20 border-border/50 focus:border-primary/50 transition-colors"
                                    placeholder="Write your step-by-step solution here..."
                                />
                            </TabsContent>

                            <TabsContent
                                value="preview"
                                className="mt-0 focus-visible:outline-none space-y-6"
                            >
                                <div className="rounded-2xl border-2 border-dashed border-border/50 bg-muted/10 p-6 min-h-[300px]">
                                    <p className="text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/50 mb-4">
                                        Live Rendered Output
                                    </p>
                                    <div className="prose dark:prose-invert max-w-none text-sm leading-relaxed">
                                        <Latex>
                                            {editedText ||
                                                "Start writing to see preview..."}
                                        </Latex>
                                    </div>
                                </div>

                                <AIContentAssistant
                                    content={editedText}
                                    contentType="solution"
                                    onContentChange={setEditedText}
                                />
                            </TabsContent>
                        </Tabs>
                    </div>
                ) : (
                    <div className="space-y-8">
                        {solution.approach_description && (
                            <div
                                className={cn(
                                    "p-6 rounded-2xl transition-all border relative overflow-hidden group/approach",
                                    isHighlighted
                                        ? "bg-primary/[0.04] border-primary/20 shadow-lg shadow-primary/5"
                                        : "bg-accent/40 border-accent/20 text-foreground",
                                )}
                            >
                                <div className="absolute top-0 left-0 w-1 h-full bg-primary" />
                                <div className="flex items-center gap-2 text-[10px] font-black uppercase tracking-[0.2em] mb-4 text-primary/80">
                                    <Sparkles className="h-3 w-3" />
                                    Core Strategy \u0026 Approach
                                </div>
                                <div className="prose dark:prose-invert max-w-none text-sm leading-relaxed font-semibold italic opacity-90">
                                    <Latex>
                                        {solution.approach_description}
                                    </Latex>
                                </div>
                            </div>
                        )}

                        <div className="animate-in fade-in duration-700">
                            <SolutionSteps content={solution.solution_text} />
                        </div>

                        {solution.numerical_answer && (
                            <div className="mt-10 pt-8 border-t border-border/40 flex flex-col sm:flex-row items-center justify-between gap-6">
                                <div className="flex items-center gap-3">
                                    <div className="h-2 w-2 rounded-full bg-primary animate-pulse" />
                                    <span className="text-xs font-black text-foreground/40 uppercase tracking-[0.2em]">
                                        Final Answer
                                    </span>
                                </div>
                                <div className="bg-primary/5 ring-1 ring-primary/20 shadow-[0_4px_20px_rgba(var(--primary),0.1)] px-8 py-4 rounded-2xl transition-all hover:bg-primary/10 hover:shadow-[0_4px_25px_rgba(var(--primary),0.15)] group relative overflow-hidden">
                                    <div className="absolute inset-0 bg-gradient-to-tr from-primary/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity" />
                                    <div className="text-4xl font-bold text-foreground relative z-10">
                                        <Latex>{`$${(solution.numerical_answer || "").replace(/\\boxed\{([\s\S]*?)\}/g, "$1").trim()}$`}</Latex>
                                    </div>
                                </div>
                            </div>
                        )}
                    </div>
                )}
            </CardContent>
        </Card>
    );
}
