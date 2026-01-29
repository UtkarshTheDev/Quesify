"use client";

import { motion, AnimatePresence } from "framer-motion";

export const SectionFade = ({
    children,
    isLoaded,
    delay = 0,
}: {
    children: React.ReactNode;
    isLoaded: boolean;
    delay?: number;
}) => {
    return (
        <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay }}
            className="w-full"
        >
            <AnimatePresence mode="wait">
                <motion.div
                    key={isLoaded ? "content" : "loading"}
                    initial={{ opacity: 0, scale: 0.98 }}
                    animate={{ opacity: 1, scale: 1 }}
                    exit={{ opacity: 0, scale: 1.02 }}
                    transition={{ duration: 0.3 }}
                >
                    {children}
                </motion.div>
            </AnimatePresence>
        </motion.div>
    );
};
