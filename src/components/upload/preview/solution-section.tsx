"use client";

import { Card, CardHeader, CardContent, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "./skeleton";
import { SectionFade } from "./section-fade";
import { SolutionSteps } from "@/components/questions/solution-steps";
import { Latex } from "@/components/ui/latex";
import { AIContentAssistant } from "@/components/ai/content-assistant";
import { Loader2, AlertTriangle, CheckCircle2 } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { stripBoxed } from "@/lib/utils";
import type { GeminiExtractionResult } from "@/lib/types";

interface SolutionSectionProps {
    status: {
        extracting: boolean;
        extractError: string | null;
        solving: boolean;
        solveError: string | null;
    };
    displayData: GeminiExtractionResult;
    localEdits: Partial<GeminiExtractionResult> | null;
    setLocalEdits: (edits: any) => void;
    activeSolutionTab: "preview" | "edit";
    setActiveSolutionTab: (tab: "preview" | "edit") => void;
    isSolutionModified: boolean;
    isVerifying: boolean;
    handleVerifyManualChanges: () => Promise<void>;
    onRetrySolve?: () => void;
    solutionRef: React.RefObject<HTMLDivElement | null>;
    delay?: number;
}

export function SolutionSection({
    status,
    displayData,
    localEdits,
    setLocalEdits,
    activeSolutionTab,
    setActiveSolutionTab,
    isSolutionModified,
    isVerifying,
    handleVerifyManualChanges,
    onRetrySolve,
    solutionRef,
    delay = 0,
}: SolutionSectionProps) {
    const isActuallyLoaded = !!displayData.solution && !status.solving && !status.extracting;
    const showSkeleton = status.solving || status.extracting || (!displayData.solution && !status.solveError);

    return (
        <SectionFade isLoaded={true} delay={delay}>
            <Card
                ref={solutionRef}
                className="overflow-hidden border-none shadow-2xl bg-card/60 backdrop-blur-md ring-1 ring-white/10 py-0 gap-0"
            >
                <CardHeader className="bg-muted/20 border-b border-border/40 p-4 sm:p-6">
                    <div className="flex items-center justify-between">
                        <CardTitle className="text-lg sm:text-xl font-bold flex items-center gap-2.5">
                            {status.solving || status.extracting ? (
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
                                <AlertTriangle className="h-3 w-3 sm:h-3.5 mr-1 sm:mr-1.5" />
                                Retry Solve
                            </Button>
                        )}
                    </div>
                </CardHeader>
                <CardContent className="p-3 sm:p-5 lg:p-8">
                    {status.solveError ? (
                        <div className="py-8 sm:py-12 text-center space-y-4 px-4">
                            <div className="p-2.5 rounded-full bg-destructive/10 w-10 h-10 sm:w-12 sm:h-12 mx-auto flex items-center justify-center text-destructive">
                                <AlertTriangle className="h-5 w-5 sm:h-6" />
                            </div>
                            <div className="space-y-1">
                                <p className="text-xs sm:text-sm font-bold text-destructive">
                                    Analysis Failed
                                </p>
                                <p className="text-[10px] sm:text-xs text-muted-foreground px-4 sm:px-12 leading-relaxed font-medium">
                                    The AI was unable to generate a solution. This
                                    can happen with very low-quality images or
                                    ambiguous text.
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
                    ) : (
                        <div className="space-y-6">
                            <div className="min-h-[200px] relative">
                                <AnimatePresence mode="wait">
                                    {showSkeleton ? (
                                        <motion.div
                                            key="skeleton"
                                            initial={{ opacity: 0 }}
                                            animate={{ opacity: 1 }}
                                            exit={{ opacity: 0 }}
                                            className="space-y-5 sm:space-y-6"
                                        >
                                            <Skeleton 
                                                className="h-8 w-3/4" 
                                                statusText={status.extracting ? "Waiting for text..." : "Thinking through logic..."} 
                                            />
                                            <Skeleton 
                                                className="h-40 w-full" 
                                                statusText={status.extracting ? "AI is preparing..." : "Writing step-by-step guidance..."} 
                                            />
                                        </motion.div>
                                    ) : (
                                        <motion.div
                                            key="content"
                                            initial={{ opacity: 0 }}
                                            animate={{ opacity: 1 }}
                                            exit={{ opacity: 0 }}
                                        >
                                            <Tabs
                                                value={activeSolutionTab}
                                                onValueChange={(v) => setActiveSolutionTab(v as any)}
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
                                                                setLocalEdits((prev: any) => ({
                                                                    ...prev,
                                                                    solution: e.target.value,
                                                                }))
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
                                                                onClick={handleVerifyManualChanges}
                                                                disabled={
                                                                    isVerifying ||
                                                                    !isSolutionModified
                                                                }
                                                            >
                                                                {isVerifying ? (
                                                                    <>
                                                                        <Loader2 className="h-4 w-4 animate-spin" />{" "}
                                                                        Analyzing Strategy...
                                                                    </>
                                                                ) : (
                                                                    <>
                                                                        <CheckCircle2 className="h-4 w-4" />{" "}
                                                                        Verify Changes & Sync
                                                                        Strategy
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
                                                                content={stripBoxed(
                                                                    displayData.solution || "",
                                                                )}
                                                            />
                                                        </div>

                                                        {displayData.numerical_answer && (
                                                            <div className="mt-6 sm:mt-8 pt-4 sm:pt-6 border-t border-border/40 flex flex-col sm:flex-row items-center justify-between gap-4">
                                                                <span className="text-[11px] sm:text-xs font-black text-primary uppercase tracking-widest opacity-80">
                                                                    Final Answer
                                                                </span>
                                                                <div className="bg-primary/5 ring-1 ring-primary/20 shadow-[0_0_15px_rgba(var(--primary),0.05)] px-5 sm:px-6 py-2 sm:py-2.5 rounded-xl transition-all hover:bg-primary/10 hover:ring-primary/40 group">
                                                                    <div className="text-base sm:text-lg font-bold text-foreground font-charter">
                                                                        <Latex>{`$${stripBoxed(displayData.numerical_answer)}$`}</Latex>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        )}
                                                    </div>
                                                </TabsContent>
                                            </Tabs>
                                        </motion.div>
                                    )}
                                </AnimatePresence>
                            </div>

                            <div className="border-t pt-6">
                                <AIContentAssistant
                                    content={displayData.solution}
                                    contentType="solution"
                                    onContentChange={(val) => {
                                        setLocalEdits((prev: any) => ({
                                            ...prev,
                                            solution: val,
                                        }));
                                    }}
                                    onComplexUpdate={(update) => {
                                        setLocalEdits((prev: any) => ({
                                            ...prev,
                                            solution: update.tweakedContent,
                                            ...(update.syncedApproach
                                                ? {
                                                      hint: update.syncedApproach,
                                                  }
                                                : {}),
                                        }));
                                    }}
                                />
                            </div>
                        </div>
                    )}
                </CardContent>
            </Card>
        </SectionFade>
    );
}
