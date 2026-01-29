"use client";

import { useState, useRef, useEffect } from "react";
import {
    Sparkles,
    Loader2,
    SendHorizontal,
    Wand2,
    Type,
    GraduationCap,
    Calculator,
    AlertCircle,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { toast } from "sonner";
import { cn } from "@/lib/utils";

interface AIContentAssistantProps {
    content: string;
    contentType: "solution" | "hint" | "question";
    onContentChange: (newContent: string) => void;
    onComplexUpdate?: (data: {
        tweakedContent: string;
        syncedApproach?: string | null;
        approachChanged?: boolean;
    }) => void;
    className?: string;
}

export function AIContentAssistant({
    content,
    contentType,
    onContentChange,
    onComplexUpdate,
    className,
}: AIContentAssistantProps) {
    const [isLoading, setIsLoading] = useState(false);
    const [isStreaming, setIsStreaming] = useState(false);
    const [customPrompt, setCustomPrompt] = useState("");
    const textareaRef = useRef<HTMLTextAreaElement>(null);

    // Auto-resize textarea
    useEffect(() => {
        const textarea = textareaRef.current;
        if (textarea) {
            textarea.style.height = "auto";
            textarea.style.height = `${Math.min(textarea.scrollHeight, 120)}px`;
        }
    }, [customPrompt]);

    const streamText = async (
        fullText: string,
        syncedApproach?: string | null,
        approachChanged?: boolean,
    ) => {
        setIsStreaming(true);
        let currentText = "";

        // Split by sentences or paragraphs for a more "human-like" chunked rendering
        // We look for patterns like ". " or "\n\n" but keep it simple with a regex split
        const chunks = fullText.split(/((?<=\.)\s+|\n\n)/g).filter(Boolean);
        let chunkIndex = 0;

        return new Promise<void>((resolve) => {
            const interval = setInterval(() => {
                if (chunkIndex < chunks.length) {
                    const batchSize = 8;
                    for (let i = 0; i < batchSize && chunkIndex < chunks.length; i++) {
                        currentText += chunks[chunkIndex];
                        chunkIndex++;
                    }
                    onContentChange(currentText);
                } else {
                    clearInterval(interval);
                    setIsStreaming(false);

                    if (onComplexUpdate) {
                        onComplexUpdate({
                            tweakedContent: fullText,
                            syncedApproach: syncedApproach || null,
                            approachChanged: approachChanged || false,
                        });
                    } else {
                        onContentChange(fullText);
                    }
                    resolve();
                }
            }, 5);
        });
    };

    const handleTweak = async (instruction: string) => {
        if (!instruction) return;

        setIsLoading(true);
        try {
            const response = await fetch("/api/ai/tweak", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    originalContent: content,
                    contentType,
                    instruction: instruction,
                }),
            });

            if (!response.ok) throw new Error("Failed to tweak content");

            const data = await response.json();

            setIsLoading(false);
            await streamText(
                data.tweakedContent,
                data.syncedApproach,
                data.approachChanged,
            );

            toast.success("Refined with AI");
            setCustomPrompt("");
        } catch {
            toast.error("Failed to update content");
            setIsLoading(false);
        }
    };

    const getPresets = () => {
        return [
            {
                label: "Simplify Logic",
                prompt: "Simplify the explanation",
                icon: Wand2,
            },
            {
                label: "Fix Grammar",
                prompt: "Fix grammar and formatting",
                icon: Type,
            },
            {
                label: "Make Professional",
                prompt: "Make the tone professional and academic",
                icon: GraduationCap,
            },
            {
                label: "Fix LaTeX",
                prompt: "Ensure all math is properly formatted with LaTeX",
                icon: Calculator,
            },
        ];
    };

    const presets = getPresets();

    if (isLoading || isStreaming) {
        return (
            <div className="flex justify-center my-4">
                <div
                    className={cn(
                        "inline-flex items-center gap-2.5 px-4 py-1.5 bg-neutral-900/90 rounded-full border border-white/10 shadow-lg backdrop-blur-md transition-all animate-in fade-in zoom-in-95 !pt-1.5",
                        className,
                    )}
                >
                    <div className="relative flex h-1.5 w-1.5 items-center justify-center">
                        <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-orange-500 opacity-75"></span>
                        <span className="relative inline-flex rounded-full h-1.5 w-1.5 bg-orange-500"></span>
                    </div>
                    <span className="text-[11px] font-medium text-neutral-400 tracking-tight">
                        {isStreaming ? "AI is writing..." : "AI is working..."}
                    </span>
                </div>
            </div>
        );
    }

    return (
        <div className={cn("space-y-6 pt-6", className)}>
            <div className="flex justify-center">
                <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-orange-500/10 border border-orange-500/20 text-orange-500 shadow-[0_0_15px_-3px_rgba(249,115,22,0.1)]">
                    <Sparkles className="h-3.5 w-3.5" />
                    <span className="text-[10px] font-black tracking-widest uppercase">
                        AI Copilot
                    </span>
                </div>
            </div>

            <div className="flex flex-wrap justify-center gap-2 px-4">
                {presets.map((preset) => (
                    <button
                        key={preset.label}
                        onClick={() => handleTweak(preset.prompt)}
                        className="group flex items-center gap-2 px-3 py-1.5 text-[10px] font-bold bg-neutral-900/50 hover:bg-neutral-800 border border-white/5 hover:border-orange-500/20 rounded-lg transition-all active:scale-95 text-neutral-400 hover:text-orange-400"
                    >
                        <preset.icon className="h-3 w-3 opacity-60 group-hover:opacity-100 transition-opacity" />
                        {preset.label}
                    </button>
                ))}
            </div>

            <div className="relative group px-1">
                <div className="absolute -inset-0.5 bg-orange-500/15 rounded-2xl blur-md transition-all duration-700 group-hover:bg-orange-500/25 group-focus-within:bg-orange-500/30" />
                <div className="relative flex flex-col bg-[#0a0a0a] rounded-xl border border-orange-500/30 group-hover:border-orange-500/50 group-focus-within:border-orange-500/60 shadow-[0_0_15px_-5px_rgba(249,115,22,0.2)] group-hover:shadow-[0_0_25px_-3px_rgba(249,115,22,0.3)] group-focus-within:shadow-[0_0_30px_-3px_rgba(249,115,22,0.4)] transition-all duration-500 min-h-[160px]">
                    <Textarea
                        ref={textareaRef}
                        value={customPrompt}
                        onChange={(e) => setCustomPrompt(e.target.value)}
                        placeholder="Ask AI to rewrite, explain, or format..."
                        className="flex-1 py-5 border-none bg-transparent shadow-none focus-visible:ring-0 text-sm px-6 placeholder:text-neutral-600 text-neutral-200 resize-none overflow-y-auto min-h-[100px] pb-16"
                        onKeyDown={(e) => {
                            if (e.key === "Enter" && !e.shiftKey) {
                                e.preventDefault();
                                handleTweak(customPrompt);
                            }
                        }}
                    />

                    <div className="absolute bottom-4 right-4">
                        <Button
                            size="lg"
                            className={cn(
                                "h-11 px-6 rounded-xl font-bold text-sm gap-2.5 transition-all duration-300 shadow-xl active:scale-95",
                                customPrompt
                                    ? "bg-orange-600 text-white hover:bg-orange-500 shadow-orange-900/40 border border-orange-400/20"
                                    : "bg-neutral-800 text-neutral-400 border border-white/10 opacity-100 hover:bg-neutral-700 shadow-lg shadow-black/20",
                            )}
                            onClick={() => handleTweak(customPrompt)}
                            disabled={!customPrompt}
                        >
                            <span className="tracking-tight">Send</span>
                            <SendHorizontal className={cn(
                                "h-4 w-4 transition-transform duration-300",
                                customPrompt ? "translate-x-0.5 -translate-y-0.5" : "opacity-50"
                            )} />
                        </Button>
                    </div>
                </div>

                <div className="flex justify-center mt-3 opacity-60">
                    <p className="text-[9px] text-neutral-600 font-medium flex items-center gap-1.5">
                        <AlertCircle className="h-2.5 w-2.5 opacity-50" />
                        AI can make mistakes. Please review the output.
                    </p>
                </div>
            </div>
        </div>
    );
}
