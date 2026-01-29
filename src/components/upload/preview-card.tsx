"use client";

import { useState, useRef, useEffect } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { SolutionSteps } from "@/components/questions/solution-steps";
import { Latex } from "@/components/ui/latex";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import {
    Check,
    Edit2,
    Loader2,
    AlertTriangle,
    Copy,
    Clock,
    ExternalLink,
    CheckCircle2,
    RefreshCw,
    AlertCircle,
} from "lucide-react";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { AIContentAssistant } from "@/components/ai/content-assistant";
import { toast } from "sonner";
import type { GeminiExtractionResult, DuplicateCheckResult } from "@/lib/types";

const Skeleton = ({ className }: { className?: string }) => (
    <div className={`animate-pulse bg-muted/50 rounded-md ${className}`} />
);
const SectionFade = ({
    children,
    isLoaded,
}: {
    children: React.ReactNode;
    isLoaded: boolean;
}) => <div className="transition-all duration-700">{children}</div>;

interface PreviewCardProps {
    data: GeminiExtractionResult & {
        image_url: string;
        embedding: number[];
        duplicate_check?: DuplicateCheckResult | null;
    };
    status: {
        extracting: boolean;
        extractError: string | null;
        solving: boolean;
        solveError: string | null;
        classifying: boolean;
        classifyError: string | null;
        finalizing: boolean;
        finalizeError: string | null;
    };
    onSave: (
        data: GeminiExtractionResult & {
            image_url: string;
            embedding: number[];
            existing_question_id?: string;
        },
    ) => Promise<void>;
    isSaving: boolean;
    onReFinalize?: (text: string, solution?: string) => void;
    onRetryExtract?: () => void;
    onRetrySolve?: () => void;
    onRetryClassify?: () => void;
}

export function PreviewCard({
    data,
    status,
    onSave,
    isSaving,
    onReFinalize,
    onRetryExtract,
    onRetrySolve,
    onRetryClassify,
}: PreviewCardProps) {
    const [editMode, setEditMode] = useState(false);
    const [localEdits, setLocalEdits] =
        useState<Partial<GeminiExtractionResult> | null>(null);
    const [activeSolutionTab, setActiveSolutionTab] = useState<
        "preview" | "edit"
    >("preview");
    const [isVerifying, setIsVerifying] = useState(false);
    const debounceTimer = useRef<any>(null);

    const displayData = {
        ...data,
        ...(localEdits || {}),
    };

    const isSolutionModified =
        localEdits?.solution !== undefined &&
        localEdits.solution !== null &&
        localEdits.solution.trim() !== data.solution?.trim();

    const handleSave = async () => {
        if (
            data.duplicate_check?.is_duplicate &&
            data.duplicate_check.matched_question_id
        ) {
            await onSave({
                ...displayData,
                existing_question_id: data.duplicate_check.matched_question_id,
            } as any);
        } else {
            await onSave(displayData as any);
        }
    };

    const solutionRef = useRef<HTMLDivElement>(null);

    const handleAITweak = (
        tweakedContent: string,
        syncedApproach?: string,
        approachChanged?: boolean,
    ) => {
        // Auto-scroll to solution area on mobile when generation starts
        if (window.innerWidth < 768 && solutionRef.current) {
            solutionRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
        }
        
        setLocalEdits((prev) => ({
            ...prev,
            solution: tweakedContent,
            ...(syncedApproach ? { hint: syncedApproach } : {}),
        }));

        // If AI says the approach fundamentally changed, re-run duplication check automatically
        if (approachChanged && onReFinalize) {
            onReFinalize(displayData.question_text, tweakedContent);
        }
    };

    const handleVerifyManualChanges = async () => {
        if (!localEdits?.solution || !onReFinalize) return;

        setIsVerifying(true);
        try {
            const res = await fetch("/api/ai/analyze-change", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    oldSolution: data.solution,
                    newSolution: localEdits.solution,
                }),
            });

            if (!res.ok) throw new Error("Analysis failed");

            const { approachChanged, newApproach } = await res.json();

            setLocalEdits((prev) => ({
                ...prev,
                hint: newApproach,
            }));

            // Only re-run duplication check if AI confirms approach changed
            if (approachChanged) {
                onReFinalize(displayData.question_text, localEdits.solution);
            } else {
                toast.success("Changes verified (Same approach)");
            }
        } catch (e) {
            toast.error("Failed to verify strategy changes");
        } finally {
            setIsVerifying(false);
        }
    };

    const difficultyColors: Record<string, string> = {
        easy: "bg-green-500/10 text-green-500 border-green-500/20",
        medium: "bg-yellow-500/10 text-yellow-500 border-yellow-500/20",
        hard: "bg-orange-500/10 text-orange-500 border-orange-500/20",
        very_hard: "bg-red-500/10 text-red-500 border-red-500/20",
    };

    // Robust math preparation for the final answer
    const prepareMath = (text: string) => {
        if (!text) return "";
        // Remove any leftover manual \boxed (we render the box in UI)
        const clean = text.replace(/\\boxed\{([\s\S]*?)\}/g, "$1").trim();
        // Wrap in display math if not already wrapped
        if (clean.startsWith("$")) return clean;
        return `$$${clean}$$`;
    };

    const stripBoxed = (text: string) =>
        text.replace(/\\boxed\{([\s\S]*?)\}/g, "$1").trim();

    const formatTime = (seconds?: number) => {
        if (!seconds) return "N/A";
        if (seconds < 60) return `${seconds}s`;
        const mins = Math.floor(seconds / 60);
        const secs = seconds % 60;
        return secs > 0 ? `${mins}m ${secs}s` : `${mins}m`;
    };

    interface ProgressLinkProps {
        label: string;
        isLoading: boolean;
        error: string | null;
        done: boolean;
        onRetry?: () => void;
    }

    const ProgressLink = ({
        label,
        isLoading,
        error,
        done,
        onRetry,
    }: ProgressLinkProps) => (
        <div className="flex items-center justify-between text-xs px-2 py-1.5 rounded-lg bg-white/5">
            <span className="text-muted-foreground">{label}</span>
            {error ? (
                <Button
                    variant="ghost"
                    size="icon"
                    className="h-5 w-5 text-destructive"
                    onClick={onRetry}
                >
                    <AlertTriangle className="h-3 w-3" />
                </Button>
            ) : isLoading ? (
                <Loader2 className="h-3 w-3 animate-spin" />
            ) : done ? (
                <Check className="h-3 w-3 text-green-500" />
            ) : null}
        </div>
    );

    return (
        <div className="grid grid-cols-1 lg:grid-cols-[1fr_450px] gap-6 sm:gap-8 items-start">
            {/* LEFT COLUMN: Question & Solution Stream */}
            <div className="space-y-6 sm:space-y-8">
                {/* Question Card */}
                <Card className="overflow-hidden border-none shadow-xl bg-card/60 backdrop-blur-md ring-1 ring-white/10 pb-4 sm:pb-6 gap-0 py-0">
                    <CardHeader className="flex flex-row items-center justify-between bg-muted/20 py-3 sm:py-4 px-4 sm:px-6">
                        <div className="space-y-0.5">
                            <CardTitle className="text-lg sm:text-xl font-bold">
                                Extraction Result
                            </CardTitle>
                            <p className="text-[10px] sm:text-xs text-muted-foreground font-medium opacity-70 tracking-tight">
                                Verification & Preview
                            </p>
                        </div>
                        <Button
                            variant="secondary"
                            size="sm"
                            className="h-7 sm:h-8 px-2.5 sm:px-3 text-[10px] sm:text-xs"
                            onClick={() => {
                                if (!editMode) setLocalEdits(data);
                                setEditMode(!editMode);
                            }}
                        >
                            <Edit2 className="h-3 w-3 sm:h-3.5 sm:h-3.5 mr-1 sm:mr-1.5" />
                            {editMode ? "Preview" : "Edit"}
                        </Button>
                    </CardHeader>

                    <CardContent className="p-3 sm:p-4 lg:p-6 space-y-6 sm:space-y-8">
                        {/* Question */}
                        <div className="space-y-2.5 sm:space-y-3">
                            <Label className="uppercase tracking-widest text-[9px] sm:text-[10px] font-black text-primary/60 opacity-80">
                                The Question
                            </Label>
                            {status.extractError ? (
                                <div className="p-6 sm:p-8 rounded-2xl bg-destructive/5 border border-destructive/20 text-center space-y-3">
                                    <p className="text-xs sm:text-sm text-destructive font-medium">
                                        {status.extractError}
                                    </p>
                                    <Button
                                        variant="outline"
                                        size="sm"
                                        onClick={onRetryExtract}
                                    >
                                        Try Again
                                    </Button>
                                </div>
                            ) : editMode ? (
                                <textarea
                                    className="w-full min-h-32 p-3 sm:p-4 rounded-xl bg-muted/50 border-none ring-1 ring-border/50 focus:ring-primary/40 focus:bg-muted/80 transition-all font-mono text-[13px] sm:text-sm lg:text-base leading-relaxed"
                                    value={displayData.question_text}
                                    onChange={(e) =>
                                        setLocalEdits({
                                            ...localEdits,
                                            question_text: e.target.value,
                                        })
                                    }
                                />
                            ) : (
                                <div className="space-y-3">
                                    <div className="p-4 sm:p-5 rounded-2xl bg-primary/[0.02] ring-1 ring-white/5 shadow-inner text-sm sm:text-base lg:text-lg leading-relaxed">
                                        <Latex>
                                            {displayData.question_text}
                                        </Latex>
                                    </div>
                                    <div className="flex items-center justify-between px-2 pt-3 border-t border-border/40 mt-4">
                                        <p className="text-[10px] sm:text-xs text-muted-foreground/60 font-medium flex items-center gap-2">
                                            <AlertCircle className="h-3.5 w-3.5 opacity-70 text-orange-500" />
                                            AI may be inaccurate with formulas.
                                        </p>
                                        <Button
                                            variant="outline"
                                            size="sm"
                                            onClick={onRetryExtract}
                                            className="h-9 text-xs font-bold text-muted-foreground hover:text-orange-600 hover:bg-orange-500/5 px-4 rounded-xl border-border/40 hover:border-orange-500/50 transition-all gap-2"
                                        >
                                            <RefreshCw className="h-3.5 w-3.5" />
                                            Regenerate
                                        </Button>
                                    </div>
                                </div>
                            )}
                        </div>

                        {/* Options */}
                        {!status.extractError &&
                            displayData.options &&
                            displayData.options.length > 0 && (
                                <div className="space-y-3 pb-2">
                                    <Label className="uppercase tracking-widest text-[10px] font-bold text-muted-foreground opacity-70">
                                        Choices
                                    </Label>
                                    <div className="grid gap-3">
                                        {displayData.options.map(
                                            (option, index) => {
                                                const isCorrect =
                                                    displayData.correct_option ===
                                                    index;
                                                return (
                                                    <div
                                                        key={index}
                                                        className={`group p-4 rounded-xl border transition-all flex gap-3 items-start ${
                                                            isCorrect
                                                                ? "bg-primary/10 border-primary shadow-[0_0_15px_rgba(var(--primary),0.1)]"
                                                                : "bg-muted/20 border-transparent hover:border-primary/20 hover:bg-muted/30"
                                                        }`}
                                                    >
                                                        <span
                                                            className={`mt-1 w-6 h-6 flex items-center justify-center rounded-full text-[10px] font-bold shrink-0 ${
                                                                isCorrect
                                                                    ? "bg-primary text-primary-foreground"
                                                                    : "bg-primary/10 text-primary"
                                                            }`}
                                                        >
                                                            {String.fromCharCode(
                                                                65 + index,
                                                            )}
                                                        </span>
                                                        <div className="flex-1 pt-0.5">
                                                            <Latex>
                                                                {option}
                                                            </Latex>
                                                        </div>
                                                        {isCorrect && (
                                                            <Badge
                                                                variant="secondary"
                                                                className="bg-primary/20 text-primary border-none text-[8px] uppercase tracking-wider py-0 px-1.5 h-4"
                                                            >
                                                                Correct
                                                            </Badge>
                                                        )}
                                                    </div>
                                                );
                                            },
                                        )}
                                    </div>
                                </div>
                            )}
                    </CardContent>
                </Card>

                {/* Detailed Solution Card (Directly below Question, matching width) */}
                <Card ref={solutionRef} className="overflow-hidden border-none shadow-2xl bg-card/60 backdrop-blur-md ring-1 ring-white/10 py-0 gap-0">
                    <CardHeader className="bg-muted/20 border-b border-border/40 p-4 sm:p-6">
                        <div className="flex items-center justify-between">
                            <CardTitle className="text-lg sm:text-xl font-bold flex items-center gap-2.5">
                                {status.solving ? (
                                    <Loader2 className="h-4 w-4 sm:h-5 sm:w-5 animate-spin text-primary" />
                                ) : (
                                    <div className="w-2 h-2 rounded-full bg-primary" />
                                )}
                                Step-by-Step Solution
                            </CardTitle>
                            {status.solveError && (
                                <Button
                                    variant="ghost"
                                    size="sm"
                                    className="h-7 sm:h-8 text-[10px] sm:text-xs text-destructive hover:bg-destructive/10"
                                    onClick={onRetrySolve}
                                >
                                    <AlertTriangle className="h-3 w-3 sm:h-3.5 sm:h-3.5 mr-1 sm:mr-1.5" />
                                    Retry Solve
                                </Button>
                            )}
                        </div>
                    </CardHeader>
                    <CardContent className="p-3 sm:p-5 lg:p-8">
                        {status.solveError ? (
                            <div className="py-8 sm:py-12 text-center space-y-4 px-4">
                                <div className="p-2.5 rounded-full bg-destructive/10 w-10 h-10 sm:w-12 sm:h-12 mx-auto flex items-center justify-center text-destructive">
                                    <AlertTriangle className="h-5 w-5 sm:h-6 sm:w-6" />
                                </div>
                                <div className="space-y-1">
                                    <p className="text-xs sm:text-sm font-bold text-destructive">
                                        Analysis Failed
                                    </p>
                                    <p className="text-[10px] sm:text-xs text-muted-foreground px-4 sm:px-12 leading-relaxed font-medium">
                                        The AI was unable to generate a
                                        solution. This can happen with very
                                        low-quality images or ambiguous text.
                                    </p>
                                </div>
                                <Button
                                    variant="outline"
                                    size="sm"
                                    onClick={onRetrySolve}
                                    className="rounded-xl h-8 text-[10px] font-bold"
                                >
                                    Regenerate Solution
                                </Button>
                            </div>
                        ) : status.solving ? (
                            <div className="space-y-5 sm:space-y-6">
                                <Skeleton className="h-8 sm:h-10 w-3/4" />
                                <Skeleton className="h-32 sm:h-40 w-full" />
                            </div>
                        ) : (
                            <SectionFade isLoaded={true}>
                                <Tabs
                                    value={activeSolutionTab}
                                    onValueChange={(v) =>
                                        setActiveSolutionTab(v as any)
                                    }
                                    className="w-full"
                                >
                                    <div className="flex items-center justify-between mb-4 sm:mb-6">
                                        <TabsList className="bg-muted/50 p-1 h-8 sm:h-9">
                                            <TabsTrigger
                                                value="preview"
                                                className="px-4 sm:px-6 text-[9px] sm:text-[10px] font-black uppercase tracking-widest"
                                            >
                                                Preview
                                            </TabsTrigger>
                                            <TabsTrigger
                                                value="edit"
                                                className="px-4 sm:px-6 text-[9px] sm:text-[10px] font-black uppercase tracking-widest"
                                            >
                                                Write
                                            </TabsTrigger>
                                        </TabsList>

                                        {activeSolutionTab === "edit" && (
                                            <Badge
                                                variant="outline"
                                                className="text-[8px] sm:text-[9px] font-bold uppercase tracking-tight bg-primary/5 text-primary/70 border-primary/20"
                                            >
                                                Editing Active
                                            </Badge>
                                        )}
                                    </div>

                                    <TabsContent
                                        value="edit"
                                        className="mt-0 space-y-4 sm:space-y-6 focus-visible:outline-none animate-in fade-in zoom-in-95 duration-200"
                                    >
                                        <div className="space-y-4 pb-2 sm:pb-4">
                                            <textarea
                                                className="w-full min-h-64 p-4 sm:p-6 rounded-2xl bg-muted/50 border-none ring-1 ring-border/50 focus:ring-primary/40 focus:bg-muted/80 transition-all font-mono text-[13px] sm:text-sm leading-relaxed"
                                                value={displayData.solution}
                                                onChange={(e) =>
                                                    setLocalEdits({
                                                        ...localEdits,
                                                        solution:
                                                            e.target.value,
                                                    })
                                                }
                                                placeholder="Fine-tune the solution steps..."
                                            />

                                            <div className="flex justify-end pt-2 sm:pt-4">
                                                <Button
                                                    size="lg"
                                                    variant="default"
                                                    className={`w-full rounded-xl h-11 sm:h-12 font-bold gap-2.5 sm:gap-3 transition-all active:scale-95 shadow-lg ${
                                                        !isSolutionModified
                                                            ? "bg-orange-600/10 text-orange-400/50 cursor-not-allowed shadow-none border border-orange-500/10"
                                                            : "bg-orange-600 hover:bg-orange-500 text-white shadow-orange-500/30"
                                                    }`}
                                                    onClick={
                                                        handleVerifyManualChanges
                                                    }
                                                    disabled={
                                                        isVerifying ||
                                                        !isSolutionModified
                                                    }
                                                >
                                                    {isVerifying ? (
                                                        <>
                                                            <Loader2 className="h-4 w-4 animate-spin" />{" "}
                                                            Analyzing
                                                            Strategy...
                                                        </>
                                                    ) : (
                                                        <>
                                                            <CheckCircle2 className="h-4 w-4" />{" "}
                                                            Verify Changes &
                                                            Sync Strategy
                                                        </>
                                                    )}
                                                </Button>
                                            </div>
                                        </div>
                                    </TabsContent>

                                    <TabsContent
                                        value="preview"
                                        className="mt-0 focus-visible:outline-none"
                                    >
                                        <div className="space-y-8 sm:space-y-10 pb-4 sm:pb-6 text-sm sm:text-base">
                                            <div className="solution-content">
                                                <SolutionSteps
                                                    content={(
                                                        displayData.solution ||
                                                        ""
                                                    ).replace(
                                                        /\\boxed\{([\s\S]*?)\}/g,
                                                        "$1",
                                                    )}
                                                />
                                            </div>

                                            {displayData.numerical_answer && (
                                                <div className="mt-6 sm:mt-8 pt-4 sm:pt-6 border-t border-border/40 flex flex-col sm:flex-row items-center justify-between gap-4">
                                                    <span className="text-[11px] sm:text-xs font-black text-primary uppercase tracking-widest opacity-80">
                                                        Final Answer
                                                    </span>
                                                    <div className="bg-primary/5 ring-1 ring-primary/20 shadow-[0_0_15px_rgba(var(--primary),0.05)] px-5 sm:px-6 py-2 sm:py-2.5 rounded-xl transition-all hover:bg-primary/10 hover:ring-primary/40 group">
                                                        <div className="text-base sm:text-lg font-bold text-foreground">
                                                            <Latex>{`$${stripBoxed(displayData.numerical_answer)}$`}</Latex>
                                                        </div>
                                                    </div>
                                                </div>
                                            )}
                                        </div>
                                    </TabsContent>
                                </Tabs>

                                <AIContentAssistant
                                    content={displayData.solution}
                                    contentType="solution"
                                    onContentChange={(val) => {
                                        setLocalEdits((prev) => ({
                                            ...prev,
                                            solution: val,
                                        }));
                                    }}
                                    onComplexUpdate={(update) => {
                                        setLocalEdits((prev) => ({
                                            ...prev,
                                            solution: update.tweakedContent,
                                            ...(update.syncedApproach
                                                ? {
                                                      hint: update.syncedApproach,
                                                  }
                                                : {}),
                                        }));
                                    }}
                                    className="border-t pt-6"
                                />
                            </SectionFade>
                        )}
                    </CardContent>
                </Card>
            </div>

            {/* RIGHT COLUMN: Professional Sidebar */}
            <div className="space-y-6 lg:sticky lg:top-8">
                {/* Duplicate Notification Card (Top Priority) */}
                {data.duplicate_check?.is_duplicate && !status.finalizing && (
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
                                {Math.round(
                                    (data.duplicate_check.confidence || 0) *
                                        100,
                                )}
                                % Match
                            </Badge>
                        </div>
                        <CardContent className="px-6 space-y-6">
                            <div className="space-y-4">
                                <div className="flex items-center gap-3">
                                    <Avatar className="h-10 w-10 ring-2 ring-yellow-500/20">
                                        <AvatarImage
                                            src={
                                                data.duplicate_check.author
                                                    ?.avatar_url || ""
                                            }
                                        />
                                        <AvatarFallback className="bg-yellow-500/10 text-yellow-600 text-xs">
                                            {(
                                                data.duplicate_check.author
                                                    ?.display_name || "U"
                                            ).charAt(0)}
                                        </AvatarFallback>
                                    </Avatar>
                                    <div className="space-y-0.5">
                                        <p className="text-[10px] text-muted-foreground font-bold uppercase tracking-tight opacity-60">
                                            Already Added By
                                        </p>
                                        <p className="text-sm font-bold text-foreground">
                                            {data.duplicate_check.author
                                                ?.display_name ||
                                                "Community Member"}
                                        </p>
                                    </div>
                                </div>

                                <div className="p-4 rounded-xl bg-yellow-500/[0.05] border border-yellow-500/10">
                                    <p className="text-xs text-yellow-700/80 leading-relaxed font-medium italic">
                                        "
                                        {data.duplicate_check.differences ||
                                            "This question is already available in our global question bank."}
                                        "
                                    </p>
                                </div>
                            </div>

                            <Button
                                variant="outline"
                                className="w-full h-11 rounded-xl text-xs font-bold border-yellow-500/20 hover:bg-yellow-500/10 hover:text-yellow-600 transition-all gap-2"
                                onClick={() =>
                                    window.open(
                                        `/question/${data.duplicate_check?.matched_question_id}`,
                                        "_blank",
                                    )
                                }
                            >
                                <ExternalLink className="h-3.5 w-3.5" />
                                View Original Question
                            </Button>
                        </CardContent>
                    </Card>
                )}

                {/* Progress & Action Card */}
                <Card className="border-none bg-primary/5 ring-1 ring-primary/20 shadow-lg">
                    <CardContent className="p-6 py-0 space-y-4">
                        <div className="flex items-center justify-between">
                            <Label className="uppercase tracking-widest text-[10px] font-bold text-primary/70">
                                AI Progress Tracker
                            </Label>
                            {status.finalizing ||
                            status.solving ||
                            status.classifying ? (
                                <Badge
                                    variant="secondary"
                                    className="animate-pulse bg-primary/20 text-primary border-none text-[10px]"
                                >
                                    Processing
                                </Badge>
                            ) : status.solveError ||
                              status.classifyError ||
                              status.extractError ? (
                                <Badge
                                    variant="destructive"
                                    className="bg-destructive/20 text-destructive border-none text-[10px]"
                                >
                                    Attention Required
                                </Badge>
                            ) : (
                                <Badge
                                    variant="secondary"
                                    className="bg-green-500/20 text-green-500 border-none text-[10px]"
                                >
                                    Ready
                                </Badge>
                            )}
                        </div>

                        <div className="grid grid-cols-1 gap-2.5">
                            <ProgressLink
                                label="Reading Question Text"
                                isLoading={status.extracting}
                                error={status.extractError}
                                done={
                                    !status.extracting &&
                                    !status.extractError &&
                                    !!data.question_text
                                }
                                onRetry={onRetryExtract}
                            />
                            <ProgressLink
                                label="Thinking through Solution"
                                isLoading={status.solving}
                                error={status.solveError}
                                done={
                                    !status.solving &&
                                    !status.solveError &&
                                    !!data.solution
                                }
                                onRetry={onRetrySolve}
                            />
                            <ProgressLink
                                label="Organizing by Subject"
                                isLoading={status.classifying}
                                error={status.classifyError}
                                done={
                                    !status.classifying &&
                                    !status.classifyError &&
                                    data.subject !== "Pending..."
                                }
                                onRetry={onRetryClassify}
                            />
                        </div>

                        <Button
                            className={`w-full h-12 rounded-xl text-sm font-bold shadow-lg mt-2 ring-1 ring-white/10 hover:scale-[1.02] active:scale-95 transition-all ${data.duplicate_check?.is_duplicate ? "bg-green-600 hover:bg-green-500 text-white" : ""}`}
                            onClick={handleSave}
                            disabled={
                                isSaving ||
                                status.solving ||
                                status.classifying ||
                                status.extracting ||
                                !!status.extractError
                            }
                        >
                            {isSaving ? (
                                <>
                                    <Loader2 className="h-4 w-4 mr-2 animate-spin" />{" "}
                                    {data.duplicate_check?.is_duplicate
                                        ? data.duplicate_check.match_type ===
                                          "DIFFERENT_APPROACH"
                                            ? "Contributing..."
                                            : "Linking..."
                                        : "Adding to Bank..."}
                                </>
                            ) : (
                                <>
                                    {data.duplicate_check?.is_duplicate ? (
                                        data.duplicate_check.match_type ===
                                        "DIFFERENT_APPROACH" ? (
                                            <>
                                                <Copy className="h-4 w-4 mr-2" />{" "}
                                                Add Your Approach & Link
                                            </>
                                        ) : (
                                            <>
                                                <Copy className="h-4 w-4 mr-2" />{" "}
                                                Link to Your Bank
                                            </>
                                        )
                                    ) : (
                                        <>
                                            <Check className="h-4 w-4 mr-2" />{" "}
                                            Add to Question Bank
                                        </>
                                    )}
                                </>
                            )}
                        </Button>
                    </CardContent>
                </Card>

                {/* Classification Summary */}
                <Card className="border-none shadow-lg bg-card/40 backdrop-blur-sm ring-1 ring-white/5">
                    <CardHeader className="pb-3 border-b border-border/40 flex flex-row items-center justify-between">
                        <Label className="uppercase tracking-widest text-[10px] font-bold text-muted-foreground opacity-70">
                            Classification
                        </Label>
                        {status.classifyError && (
                            <Button
                                variant="ghost"
                                size="icon"
                                className="h-5 w-5 text-destructive"
                                onClick={onRetryClassify}
                            >
                                <AlertTriangle className="h-3 w-3" />
                            </Button>
                        )}
                    </CardHeader>
                    <CardContent className="px-6 pb-3 space-y-6">
                        {status.classifyError ? (
                            <div className="text-center py-4 space-y-2">
                                <p className="text-[10px] text-destructive leading-tight px-4 font-medium">
                                    {status.classifyError}
                                </p>
                                <Button
                                    variant="link"
                                    className="h-auto p-0 text-[10px] text-primary"
                                    onClick={onRetryClassify}
                                >
                                    Retry Classification
                                </Button>
                            </div>
                        ) : status.classifying ? (
                            <div className="space-y-4">
                                <Skeleton className="h-5 w-3/4" />
                                <Skeleton className="h-4 w-1/2" />
                                <div className="flex gap-2">
                                    <Skeleton className="h-6 w-12" />
                                    <Skeleton className="h-6 w-16" />
                                </div>
                            </div>
                        ) : (
                            <SectionFade isLoaded={true}>
                                <div className="space-y-6">
                                    <div className="space-y-1.5">
                                        <h3 className="text-lg font-bold text-primary/90 leading-tight">
                                            {displayData.subject ||
                                                "Detecting..."}
                                        </h3>
                                        <p className="text-xs text-muted-foreground font-medium leading-relaxed">
                                            {displayData.chapter}
                                        </p>
                                    </div>

                                    <div className="flex flex-wrap gap-2">
                                        <Badge
                                            variant="outline"
                                            className="text-[10px] px-3 py-1 border-primary/20 bg-primary/5 uppercase"
                                        >
                                            {displayData.type}
                                        </Badge>
                                        <Badge
                                            className={`text-[10px] px-3 py-1 border uppercase ${difficultyColors[displayData.difficulty || "medium"]}`}
                                        >
                                            {displayData.difficulty || "medium"}
                                        </Badge>
                                        {displayData.avg_solve_time ? (
                                            <Badge
                                                variant="outline"
                                                className="text-[10px] px-3 py-1 border-blue-500/20 bg-blue-500/5 text-blue-500 flex items-center gap-1.5"
                                            >
                                                <Clock className="h-3 w-3" />
                                                {formatTime(
                                                    displayData.avg_solve_time,
                                                )}
                                            </Badge>
                                        ) : null}
                                    </div>

                                    <div className="space-y-3">
                                        <Label className="text-[10px] font-bold text-muted-foreground uppercase opacity-50">
                                            Related Topics
                                        </Label>
                                        <div className="flex flex-wrap gap-1.5">
                                            {(displayData.topics || []).map(
                                                (topic) => (
                                                    <Badge
                                                        key={topic}
                                                        variant="secondary"
                                                        className="text-[10px] bg-white/5 border-none font-normal px-2.5 py-1"
                                                    >
                                                        {topic}
                                                    </Badge>
                                                ),
                                            )}
                                        </div>
                                    </div>
                                </div>
                            </SectionFade>
                        )}
                    </CardContent>
                </Card>

                {/* Strategy Hint */}
                <Card className="border-none shadow-lg bg-yellow-500/[0.03] ring-1 ring-yellow-500/10">
                    <CardHeader className="pb-2 border-b border-yellow-500/10">
                        <Label className="uppercase tracking-widest text-[10px] font-bold text-yellow-600/70">
                            Expert Hint / Strategy
                        </Label>
                    </CardHeader>
                    <CardContent className="p-6 py-0">
                        {status.solving ? (
                            <Skeleton className="h-20 w-full" />
                        ) : (
                            <SectionFade isLoaded={true}>
                                <div className="text-sm italic text-muted-foreground leading-relaxed border-l-4 border-yellow-500/20 pl-4 py-1">
                                    <Latex>
                                        {displayData.hint ||
                                            "Developing strategy..."}
                                    </Latex>
                                </div>
                            </SectionFade>
                        )}
                    </CardContent>
                </Card>
            </div>
        </div>
    );
}
