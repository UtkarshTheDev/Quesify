"use client";

import { Card, CardHeader, CardContent, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Latex } from "@/components/ui/latex";
import { Edit2, RefreshCw, AlertCircle } from "lucide-react";
import { motion } from "framer-motion";
import { Skeleton } from "./skeleton";
import { SectionFade } from "./section-fade";
import type { GeminiExtractionResult } from "@/lib/types";

interface QuestionSectionProps {
    editMode: boolean;
    setEditMode: (mode: boolean) => void;
    displayData: GeminiExtractionResult;
    localEdits: Partial<GeminiExtractionResult> | null;
    setLocalEdits: (edits: Partial<GeminiExtractionResult> | null) => void;
    status: {
        extracting: boolean;
        extractError: string | null;
    };
    onRetryExtract?: () => void;
}

export function QuestionSection({
    editMode,
    setEditMode,
    displayData,
    localEdits,
    setLocalEdits,
    status,
    onRetryExtract,
}: QuestionSectionProps) {
    const isLoaded = !!displayData.question_text && !status.extracting;

    return (
        <SectionFade isLoaded={isLoaded}>
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
                            if (!editMode) setLocalEdits(displayData);
                            setEditMode(!editMode);
                        }}
                        disabled={!isLoaded}
                    >
                        <Edit2 className="h-3 w-3 sm:h-3.5 mr-1 sm:mr-1.5" />
                        {editMode ? "Preview" : "Edit"}
                    </Button>
                </CardHeader>

                <CardContent className="p-3 sm:p-4 lg:p-6 space-y-6 sm:space-y-8 relative">
                    {status.extracting && (
                        <motion.div
                            initial={{ top: "0%" }}
                            animate={{ top: "100%" }}
                            transition={{
                                repeat: Infinity,
                                duration: 2,
                                ease: "linear",
                            }}
                            className="absolute left-0 right-0 h-[2px] bg-primary/30 blur-[2px] z-10 pointer-events-none"
                        />
                    )}

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
                        ) : status.extracting ? (
                            <Skeleton 
                                className="h-40 w-full rounded-2xl" 
                                statusText="AI is scanning for text and formulas..." 
                            />
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
                                <div className="p-4 sm:p-5 rounded-2xl bg-primary/[0.02] ring-1 ring-white/5 shadow-inner text-sm sm:text-base lg:text-lg leading-relaxed font-charter">
                                    <Latex>{displayData.question_text}</Latex>
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

                    {!status.extractError && !status.extracting &&
                        displayData.options &&
                        displayData.options.length > 0 && (
                            <div className="space-y-3 pb-2">
                                <Label className="uppercase tracking-widest text-[10px] font-bold text-muted-foreground opacity-70">
                                    Choices
                                </Label>
                                <div className="grid gap-3">
                                    {displayData.options.map((option, index) => {
                                        const isCorrect =
                                            displayData.correct_option === index;
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
                                                    className={`mt-1 w-6 h-6 flex items-center justify-center rounded-full text-[10px] font-bold shrink-0 font-mono ${
                                                        isCorrect
                                                            ? "bg-primary text-primary-foreground"
                                                            : "bg-primary/10 text-primary"
                                                    }`}
                                                >
                                                    {String.fromCharCode(65 + index)}
                                                </span>
                                                <div className="flex-1 pt-0.5 font-charter">
                                                    <Latex>{option}</Latex>
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
                                    })}
                                </div>
                            </div>
                        )}
                    
                    {!status.extractError && status.extracting && (
                        <div className="space-y-3 pb-2">
                             <Label className="uppercase tracking-widest text-[10px] font-bold text-muted-foreground opacity-70">
                                Choices
                            </Label>
                            <div className="grid gap-3">
                                {[1, 2, 3, 4].map((i) => (
                                    <Skeleton key={i} className="h-14 w-full rounded-xl" />
                                ))}
                            </div>
                        </div>
                    )}
                </CardContent>
            </Card>
        </SectionFade>
    );
}
