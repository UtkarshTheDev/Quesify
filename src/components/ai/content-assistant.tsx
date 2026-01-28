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
        approachChanged?: boolean
    ) => {
        setIsStreaming(true);
        let currentText = "";
        let index = 0;

        // Smooth, readable streaming: 15ms delay, 2 chars per frame
        // This creates a high-quality "typing" feel rather than a "dump"
        const speed = 15;
        const charsPerFrame = 2;

        return new Promise<void>((resolve) => {
            const interval = setInterval(() => {
                currentText += fullText.slice(index, index + charsPerFrame);
                onContentChange(currentText);

                index += charsPerFrame;

                if (index >= fullText.length) {
                    clearInterval(interval);
                    setIsStreaming(false);

                    if (onComplexUpdate) {
                        onComplexUpdate({
                            tweakedContent: fullText,
                            syncedApproach: syncedApproach || null,
                            approachChanged: approachChanged || false
                        });
                    } else {
                        onContentChange(fullText);
                    }
                    resolve();
                }
            }, speed);
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
            await streamText(data.tweakedContent, data.syncedApproach, data.approachChanged);

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
            <div
                className={cn(
                    "w-full py-4 flex items-center justify-center gap-3 bg-neutral-900/80 rounded-full border border-white/5 shadow-2xl backdrop-blur-md max-w-sm mx-auto my-4",
                    className,
                )}
            >
                <div className="relative flex h-2.5 w-2.5 items-center justify-center">
                    <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-orange-500 opacity-75"></span>
                    <span className="relative inline-flex rounded-full h-2 w-2 bg-orange-500"></span>
                </div>
                <span className="text-xs font-medium text-neutral-300 tracking-wide animate-pulse pt-0.5">
                    {isStreaming
                        ? "AI is writing..."
                        : "AI is working on it..."}
                </span>
            </div>
        );
    }

    return (
        <div
            className={cn(
                "space-y-4 pt-5 sm:pt-4 border-t border-border/40",
                className,
            )}
        >
            <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                    <div className="flex items-center justify-center w-6 h-6 rounded-md bg-orange-100 dark:bg-orange-900/30 text-orange-600 dark:text-orange-400 ring-1 ring-orange-500/20">
                        <Sparkles className="h-3.5 w-3.5" />
                    </div>
                    <span className="text-[10px] sm:text-xs font-black text-foreground/80 tracking-widest uppercase">
                        AI Copilot
                    </span>
                </div>
            </div>

            {/* Preset Action Chips */}
            <div className="flex flex-wrap gap-2 sm:gap-3">
                {presets.map((preset) => (
                    <button
                        key={preset.label}
                        onClick={() => handleTweak(preset.prompt)}
                        className="group flex items-center gap-2 px-3.5 py-2 h-9 sm:h-9 sm:px-3 sm:py-1.5 text-xs sm:text-[11px] font-bold bg-background border border-border/60 hover:border-orange-500/30 hover:bg-orange-50/50 dark:hover:bg-orange-900/20 rounded-xl sm:rounded-lg transition-all active:scale-95 shadow-sm hover:shadow-orange-500/5 text-muted-foreground hover:text-orange-600 dark:hover:text-orange-400"
                    >
                        <preset.icon className="h-3.5 w-3.5 opacity-60 group-hover:opacity-100 transition-opacity" />
                        {preset.label}
                    </button>
                ))}
            </div>

            {/* Command Input */}
            <div className="relative group pt-2">
                <div className="absolute -inset-0.5 bg-gradient-to-r from-orange-500/20 to-amber-500/20 rounded-2xl blur opacity-30 group-hover:opacity-60 transition duration-500" />
                <div className="relative flex flex-col bg-neutral-950 hover:bg-neutral-900 focus-within:bg-neutral-900 rounded-xl border border-white/10 hover:border-orange-500/30 focus-within:border-orange-500/50 transition-all duration-300 shadow-xl">
                    <Textarea
                        ref={textareaRef}
                        value={customPrompt}
                        onChange={(e) => setCustomPrompt(e.target.value)}
                        placeholder="Ask AI to rewrite, explain, or format... ✨"
                        className="min-h-[60px] max-h-[120px] py-4 border-none bg-transparent shadow-none focus-visible:ring-0 text-sm px-5 placeholder:text-neutral-500 text-neutral-100 resize-none overflow-y-auto"
                        onKeyDown={(e) => {
                            if (e.key === "Enter" && !e.shiftKey) {
                                e.preventDefault();
                                handleTweak(customPrompt);
                            }
                        }}
                    />

                    <div className="flex items-center justify-end px-3 pb-3 mt-2">
                        <Button
                            className={cn(
                                "h-9 px-5 font-bold text-xs rounded-lg transition-all duration-200 gap-2 shadow-lg",
                                customPrompt
                                    ? "bg-orange-600 text-white hover:bg-orange-500"
                                    : "bg-neutral-800 text-neutral-500 cursor-not-allowed hover:bg-neutral-800"
                            )}
                            onClick={() => handleTweak(customPrompt)}
                            disabled={!customPrompt}
                        >
                            <span>Send Message</span>
                            <SendHorizontal className="h-3.5 w-3.5" />
                        </Button>
                    </div>
                </div>

                <div className="flex justify-center mt-3">
                    <p className="text-[10px] text-muted-foreground/50 font-medium flex items-center gap-1.5">
                        <AlertCircle className="h-3 w-3 opacity-70" />
                        AI can make mistakes. Please review the output.
                    </p>
                </div>
            </div>
        </div>
    );
}
