"use client";

import { useState, useRef } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Loader2, Copy, Check } from "lucide-react";
import { toast } from "sonner";
import type { GeminiExtractionResult, DuplicateCheckResult } from "@/lib/types";

import { QuestionSection } from "./preview/question-section";
import { SolutionSection } from "./preview/solution-section";
import { DuplicateNotification } from "./preview/duplicate-notification";
import { ProgressTracker } from "./preview/progress-tracker";
import { ClassificationSummary } from "./preview/classification-summary";
import { StrategyHint } from "./preview/strategy-hint";

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

    const formatTime = (seconds?: number) => {
        if (!seconds) return "N/A";
        if (seconds < 60) return `${seconds}s`;
        const mins = Math.floor(seconds / 60);
        const secs = seconds % 60;
        return secs > 0 ? `${mins}m ${secs}s` : `${mins}m`;
    };

    return (
        <div className="grid grid-cols-1 lg:grid-cols-[1fr_450px] gap-6 sm:gap-8 items-start">
            <div className="space-y-6 sm:space-y-8">
                <QuestionSection
                    editMode={editMode}
                    setEditMode={setEditMode}
                    displayData={displayData}
                    localEdits={localEdits}
                    setLocalEdits={setLocalEdits}
                    status={status}
                    onRetryExtract={onRetryExtract}
                    delay={1.0}
                />

                <SolutionSection
                    status={status}
                    displayData={displayData}
                    localEdits={localEdits}
                    setLocalEdits={setLocalEdits}
                    activeSolutionTab={activeSolutionTab}
                    setActiveSolutionTab={setActiveSolutionTab}
                    isSolutionModified={isSolutionModified}
                    isVerifying={isVerifying}
                    handleVerifyManualChanges={handleVerifyManualChanges}
                    onRetrySolve={onRetrySolve}
                    solutionRef={solutionRef}
                    delay={2.0}
                />
            </div>

            <div className="space-y-6 lg:sticky lg:top-8">
                {data.duplicate_check && (
                    <DuplicateNotification
                        duplicateCheck={data.duplicate_check}
                        isFinalizing={status.finalizing}
                    />
                )}

                <ProgressTracker
                    status={status}
                    data={displayData}
                    onRetryExtract={onRetryExtract}
                    onRetrySolve={onRetrySolve}
                    onRetryClassify={onRetryClassify}
                    delay={1.5}
                    handleSave={handleSave}
                    isSaving={isSaving}
                    duplicateCheck={data.duplicate_check}
                />

                <ClassificationSummary
                    status={status}
                    data={displayData}
                    difficultyColors={difficultyColors}
                    onRetryClassify={onRetryClassify}
                    formatTime={formatTime}
                    delay={2.5}
                />

                <StrategyHint 
                    status={status} 
                    data={displayData} 
                    delay={3.0}
                />
            </div>
        </div>
    );
}
