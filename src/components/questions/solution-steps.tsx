"use client";

import { Latex } from "@/components/ui/latex";
import { cn } from "@/lib/utils";
import { motion, AnimatePresence } from "framer-motion";

interface SolutionStepsProps {
    content: string;
    className?: string;
}

export function SolutionSteps({ content, className }: SolutionStepsProps) {
    const normalizedContent = content.replace(/\\n/g, "\n");

    let rawSteps = normalizedContent
        .split(/(?=\*\*Step\s+\d+)/i)
        .filter((step) => step.trim().length > 0);

    if (rawSteps.length === 1 && /Step\s+[2-9]/i.test(normalizedContent)) {
        rawSteps = normalizedContent
            .split(/(?=\*\*?Step\s+\d+[:.]?)/i)
            .filter((step) => step.trim().length > 0);
    }

    return (
        <div className={cn("space-y-0", className)}>
            <AnimatePresence mode="popLayout">
                {rawSteps.map((stepContent, index) => {
                    const isExplicitStep =
                        /^(?:\*\*|__)?(?:Step|Part|Phase)\s+\d+(?:[:.]|\s)(?:\*\*|__)?/i.test(
                            stepContent.trim(),
                        );

                    return (
                        <motion.div
                            key={index}
                            initial={{ opacity: 0, y: 2, filter: "blur(2px)" }}
                            animate={{ opacity: 1, y: 0, filter: "blur(0px)" }}
                            transition={{
                                duration: 0.2,
                                ease: "easeOut",
                            }}
                            className="relative pl-10 lg:pl-12 pb-8 lg:pb-12 last:pb-0 group"
                        >
                            {index !== rawSteps.length - 1 && (
                                <div
                                    className="absolute left-[15px] top-10 bottom-0 w-px bg-border group-hover:bg-primary/20 transition-colors"
                                    aria-hidden="true"
                                />
                            )}

                            <div
                                className={cn(
                                    "absolute left-0 top-[4px] h-8 w-8 rounded-full border-2 flex items-center justify-center text-[12px] font-mono font-black z-10 transition-colors shadow-md",
                                    isExplicitStep
                                        ? "bg-primary text-primary-foreground border-primary"
                                        : "bg-background text-muted-foreground border-border group-hover:border-primary/50",
                                )}
                            >
                                {index + 1}
                            </div>

                            <div className="pt-0.5 min-w-0">
                                <Latex className="prose-xl sm:prose-2xl leading-relaxed whitespace-pre-wrap font-charter font-medium tracking-tight">
                                    {stepContent.trim()}
                                </Latex>
                            </div>
                        </motion.div>
                    );
                })}
            </AnimatePresence>
        </div>
    );
}
