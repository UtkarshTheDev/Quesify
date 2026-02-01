"use client";

import { motion, AnimatePresence } from "framer-motion";
import Image from "next/image";

interface SceneSliderProps {
  step: number;
}

const scenes = [
  {
    step: 1,
    src: "/scenes/scene1.png",
    title: "Instant Extraction",
    description: "Upload question screenshots and let AI extract them instantly.",
  },
  {
    step: 2,
    src: "/scenes/scene2.png",
    title: "Smart Organization",
    description: "Organize your questions with smart linking and detailed solutions.",
  },
  {
    step: 3,
    src: "/scenes/scene3.png",
    title: "Daily Practice",
    description: "Get personalized daily feeds and well-picked practice questions.",
  },
  {
    step: 4,
    src: "/scenes/scene4.png",
    title: "Track Progress",
    description: "Build streaks and track your learning journey. You're all set!",
  },
];

export function SceneSlider({ step }: SceneSliderProps) {
  const activeScene = scenes.find((s) => s.step === step) || scenes[0];

  return (
    <div className="relative w-full h-full overflow-hidden bg-black">
      <AnimatePresence mode="popLayout">
        <motion.div
          key={activeScene.step}
          className="absolute inset-0 w-full h-full"
          initial={{ opacity: 0, scale: 1.1 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.8, ease: "easeInOut" }}
        >
          <Image
            src={activeScene.src}
            alt={`Scene ${activeScene.step}`}
            fill
            className="object-cover"
            quality={100}
            priority
          />
          <div className="absolute inset-0 bg-gradient-to-t from-black via-black/50 to-transparent opacity-90 backdrop-blur-[1px]" />
        </motion.div>
      </AnimatePresence>

      <div className="absolute bottom-0 left-0 right-0 p-8 md:p-16 z-10">
        <AnimatePresence mode="wait">
          <motion.div
            key={activeScene.step}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
            transition={{ duration: 0.5, delay: 0.2 }}
            className="max-w-xl space-y-4"
          >
            <div className="space-y-2">
              <motion.div 
                initial={{ width: 0 }}
                animate={{ width: "2rem" }}
                className="h-1 bg-orange-500 rounded-full mb-4"
              />
              <h2 className="text-2xl md:text-3xl font-bold text-white tracking-tight">
                {activeScene.title}
              </h2>
              <p className="text-lg md:text-xl text-white/80 leading-relaxed font-medium">
                {activeScene.description}
              </p>
            </div>
          </motion.div>
        </AnimatePresence>
      </div>
    </div>
  );
}
