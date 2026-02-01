"use client";

import { motion } from "framer-motion";
import { Upload, Camera, Brain, Zap, Sparkles, type LucideIcon } from "lucide-react";
import Link from "next/link";
import { Button } from "@/components/ui/button";

const FeatureCard = ({ icon: Icon, title, description, delay }: { icon: LucideIcon, title: string, description: string, delay: number }) => (
  <motion.div 
    initial={{ opacity: 0, y: 20 }}
    animate={{ opacity: 1, y: 0 }}
    transition={{ duration: 0.5, delay }}
    className="flex flex-col items-center text-center p-6 rounded-2xl border border-white/5 bg-white/5 hover:bg-white/10 transition-colors backdrop-blur-sm"
  >
    <div className="w-12 h-12 rounded-xl bg-orange-500/10 flex items-center justify-center mb-4 text-orange-500">
      <Icon className="w-6 h-6" />
    </div>
    <h3 className="font-semibold text-lg mb-2">{title}</h3>
    <p className="text-sm text-muted-foreground leading-relaxed">{description}</p>
  </motion.div>
);

export function EmptyDashboard() {
  return (
    <div className="min-h-[80vh] flex flex-col items-center justify-center relative overflow-hidden py-12 px-4">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,rgba(249,115,22,0.08)_0%,transparent_60%)] pointer-events-none" />
      
      <div className="z-10 w-full max-w-5xl mx-auto flex flex-col items-center space-y-16">
        
        <div className="text-center space-y-6 max-w-2xl">
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.6 }}
            className="space-y-4"
          >
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-orange-500/10 text-orange-500 text-xs font-medium border border-orange-500/20 mb-2">
              <Sparkles className="w-3 h-3" />
              <span>Day 0</span>
            </div>
            <h1 className="text-4xl md:text-5xl font-bold tracking-tight text-foreground">
              Your Personal Knowledge Bank <span className="text-orange-500">Awaits</span>
            </h1>
            <p className="text-lg text-muted-foreground leading-relaxed">
              Transform your scattered study materials into a structured, smart library.
              Start by adding your first question—we&apos;ll handle the organizing.
            </p>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.2 }}
          >
            <Button size="lg" className="h-14 px-8 rounded-full text-lg shadow-xl shadow-orange-500/20 bg-orange-600 hover:bg-orange-700 text-white font-semibold transition-all hover:scale-105" asChild>
              <Link href="/upload">
                <Upload className="mr-2 w-5 h-5" />
                Upload Your First Question
              </Link>
            </Button>
          </motion.div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 w-full">
          <FeatureCard 
            icon={Camera}
            title="Snap & Upload"
            description="Take a screenshot of any question. Our AI instantly extracts the text, diagrams, and options."
            delay={0.3}
          />
          <FeatureCard 
            icon={Brain}
            title="Smart Sorting"
            description="No manual tagging needed. We automatically detect the subject, chapter, and difficulty level."
            delay={0.4}
          />
          <FeatureCard 
            icon={Zap}
            title="Daily Mastery"
            description="Get a personalized feed of questions targeting your weak spots to boost your retention."
            delay={0.5}
          />
        </div>

      </div>
    </div>
  );
}
