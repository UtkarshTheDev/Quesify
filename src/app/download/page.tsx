"use client";

import { Smartphone, Download, Apple, Check, Star, Shield, Zap } from "lucide-react";
import { Button } from "@/components/ui/button";
import { motion } from "framer-motion";
import { Card, CardContent } from "@/components/ui/card";
import { PublicNav } from "@/components/layout/public-nav";
import Link from "next/link";

export default function DownloadPage() {
    return (
        <div className="min-h-screen bg-background selection:bg-orange-500/30">
            <PublicNav />
            
            <main className="container mx-auto px-4 py-20 relative overflow-hidden">
                <div className="absolute top-0 left-1/2 -translate-x-1/2 w-full h-[500px] bg-[radial-gradient(circle_at_center,rgba(249,115,22,0.05)_0%,transparent_70%)] pointer-events-none" />
                <div className="absolute -top-24 -left-24 w-96 h-96 bg-orange-600/10 blur-[100px] rounded-full pointer-events-none" />
                
                <div className="max-w-4xl mx-auto text-center space-y-8 relative z-10">
                    <motion.div
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ duration: 0.5 }}
                        className="space-y-4"
                    >
                        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-orange-500/10 border border-orange-500/20 text-orange-500 text-xs font-bold uppercase tracking-widest">
                            <Star className="w-3 h-3 fill-current" />
                            Premium Mobile Experience
                        </div>
                        <h1 className="text-5xl md:text-7xl font-black tracking-tighter text-foreground">
                            Master your studies <br /> 
                            <span className="text-orange-500">Everywhere.</span>
                        </h1>
                        <p className="text-xl text-muted-foreground max-w-2xl mx-auto leading-relaxed">
                            Take Quesify on the go. Faster uploads, offline access, and 
                            a truly native experience designed for students.
                        </p>
                    </motion.div>

                    <motion.div
                        initial={{ opacity: 0, scale: 0.95 }}
                        animate={{ opacity: 1, scale: 1 }}
                        transition={{ delay: 0.2, duration: 0.5 }}
                        className="grid grid-cols-1 md:grid-cols-2 gap-6 pt-12"
                    >
                        <Card className="bg-card/50 border-white/10 backdrop-blur-xl overflow-hidden group hover:border-orange-500/30 transition-all duration-500">
                            <CardContent className="p-8 space-y-6">
                                <div className="h-16 w-16 rounded-2xl bg-orange-500/10 flex items-center justify-center text-orange-500 group-hover:scale-110 transition-transform duration-500">
                                    <Smartphone className="w-8 h-8" />
                                </div>
                                <div className="text-left space-y-2">
                                    <h3 className="text-2xl font-bold">Android</h3>
                                    <p className="text-muted-foreground text-sm">Download the latest APK for your Android device. Fully compatible with Android 10+.</p>
                                </div>
                                <div className="space-y-3">
                                    <div className="flex items-center gap-2 text-xs text-muted-foreground/80">
                                        <Check className="w-4 h-4 text-green-500" />
                                        <span>Direct APK Download</span>
                                    </div>
                                    <div className="flex items-center gap-2 text-xs text-muted-foreground/80">
                                        <Check className="w-4 h-4 text-green-500" />
                                        <span>Instant Updates</span>
                                    </div>
                                </div>
                                <Button asChild className="w-full bg-orange-600 hover:bg-orange-700 text-white h-12 rounded-xl font-bold group">
                                    <Link href="/downloads/Quesify.apk" download>
                                        <Download className="w-4 h-4 mr-2 group-hover:translate-y-0.5 transition-transform" />
                                        Download APK
                                    </Link>
                                </Button>
                                <p className="text-[10px] text-center text-muted-foreground font-medium uppercase tracking-widest opacity-50">
                                    Version 1.0.2 • Stable Release
                                </p>
                            </CardContent>
                        </Card>

                        <Card className="bg-card/50 border-white/10 backdrop-blur-xl overflow-hidden group hover:border-blue-500/30 transition-all duration-500">
                            <CardContent className="p-8 space-y-6">
                                <div className="h-16 w-16 rounded-2xl bg-white/5 flex items-center justify-center text-foreground group-hover:scale-110 transition-transform duration-500">
                                    <Apple className="w-8 h-8" />
                                </div>
                                <div className="text-left space-y-2">
                                    <h3 className="text-2xl font-bold">iOS / iPhone</h3>
                                    <p className="text-muted-foreground text-sm">The best experience for Apple users. Coming soon to App Store or install via PWA today.</p>
                                </div>
                                <div className="space-y-3">
                                    <div className="flex items-center gap-2 text-xs text-muted-foreground/80">
                                        <Check className="w-4 h-4 text-green-500" />
                                        <span>PWA Optimized</span>
                                    </div>
                                    <div className="flex items-center gap-2 text-xs text-muted-foreground/80">
                                        <Shield className="w-4 h-4 text-blue-500" />
                                        <span>Safe & Private</span>
                                    </div>
                                </div>
                                <Button variant="secondary" className="w-full h-12 rounded-xl font-bold bg-white/5 hover:bg-white/10 text-foreground border-white/10">
                                    Install via Browser
                                </Button>
                                <p className="text-[10px] text-center text-muted-foreground font-medium uppercase tracking-widest opacity-50">
                                    App Store Link • Pending
                                </p>
                            </CardContent>
                        </Card>
                    </motion.div>

                    <div className="pt-20 grid grid-cols-1 md:grid-cols-3 gap-8">
                        <div className="flex flex-col items-center text-center space-y-3">
                            <div className="p-3 rounded-full bg-orange-500/5 text-orange-500">
                                <Zap className="w-6 h-6" />
                            </div>
                            <h4 className="font-bold">Fast Performance</h4>
                            <p className="text-sm text-muted-foreground">Optimized code for smooth scrolling and instant AI responses.</p>
                        </div>
                        <div className="flex flex-col items-center text-center space-y-3">
                            <div className="p-3 rounded-full bg-blue-500/5 text-blue-500">
                                <Shield className="w-6 h-6" />
                            </div>
                            <h4 className="font-bold">Secure Access</h4>
                            <p className="text-sm text-muted-foreground">Biometric login support and secure token management.</p>
                        </div>
                        <div className="flex flex-col items-center text-center space-y-3">
                            <div className="p-3 rounded-full bg-green-500/5 text-green-500">
                                <Smartphone className="w-6 h-6" />
                            </div>
                            <h4 className="font-bold">PWA Support</h4>
                            <p className="text-sm text-muted-foreground">Works offline and installs directly from your mobile browser.</p>
                        </div>
                    </div>
                </div>
            </main>

            <footer className="py-12 border-t border-white/5 text-center text-xs text-muted-foreground uppercase tracking-widest">
                © 2026 Quesify • Designed for Excellence
            </footer>
        </div>
    );
}
