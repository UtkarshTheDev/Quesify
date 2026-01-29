"use client";

import { motion } from "framer-motion";
import { cn } from "@/lib/utils";

export const Skeleton = ({ 
    className, 
    statusText 
}: { 
    className?: string;
    statusText?: string;
}) => (
    <div className={cn("relative overflow-hidden bg-muted/30 rounded-md", className)}>
        <motion.div
            initial={{ x: "-100%" }}
            animate={{ x: "100%" }}
            transition={{
                repeat: Infinity,
                duration: 1.5,
                ease: "linear",
            }}
            className="absolute inset-0 bg-gradient-to-r from-transparent via-primary/5 to-transparent"
        />
        {statusText && (
            <div className="absolute inset-0 flex items-center justify-center">
                <span className="text-[10px] font-bold uppercase tracking-widest text-muted-foreground/40 animate-pulse">
                    {statusText}
                </span>
            </div>
        )}
    </div>
);
