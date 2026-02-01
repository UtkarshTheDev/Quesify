"use client";

import { useState, useEffect } from "react";
import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";
import {
    Loader2,
    Check,
    ArrowRight,
    Sparkles,
    Calculator,
    Atom,
    FlaskConical,
    Dna,
    Binary,
    BookOpen,
    Globe,
    Landmark,
    Github,
    User,
} from "lucide-react";
import { Button } from "@/components/ui/button-1";
import { Input } from "@/components/ui/input";
import { Stepper, StepperItem, StepperTrigger } from "@/components/ui/stepper";
import { toast } from "sonner";
import { cn } from "@/lib/utils";
import confetti from "canvas-confetti";
import { AuthLayout } from "@/components/auth/auth-layout";
import { SlideButton } from "@/components/ui/slide-button";

const getSubjectIcon = (subject: string, isMobile = false) => {
    const s = subject.toLowerCase();
    const iconSize = isMobile ? "w-4 h-4" : "w-5 h-5";
    if (s.includes("math")) return <Calculator className={iconSize} />;
    if (s.includes("physics")) return <Atom className={iconSize} />;
    if (s.includes("chem")) return <FlaskConical className={iconSize} />;
    if (s.includes("bio")) return <Dna className={iconSize} />;
    if (s.includes("computer") || s.includes("cs"))
        return <Binary className={iconSize} />;
    if (s.includes("history")) return <Landmark className={iconSize} />;
    if (s.includes("geo")) return <Globe className={iconSize} />;
    return <BookOpen className={iconSize} />;
};

export function OnboardingFlow() {
    const router = useRouter();
    const supabase = createClient();
    const [activeStep, setActiveStep] = useState(1);
    const [, setUser] = useState<{ id: string } | null>(null);

    const [username, setUsername] = useState("");
    const [isCheckingUsername, setIsCheckingUsername] = useState(false);
    const [isUsernameAvailable, setIsUsernameAvailable] = useState(false);
    const [usernameError, setUsernameError] = useState("");

    const [availableSubjects, setAvailableSubjects] = useState<string[]>([]);
    const [selectedSubjects, setSelectedSubjects] = useState<string[]>([]);
    const [isLoadingSubjects, setIsLoadingSubjects] = useState(false);

    const [isSubmitting, setIsSubmitting] = useState(false);
    const [isGoogleLoading, setIsGoogleLoading] = useState(false);
    const [isGithubLoading, setIsGithubLoading] = useState(false);

    useEffect(() => {
        const checkUser = async () => {
            const {
                data: { user },
            } = await supabase.auth.getUser();
            if (user) {
                setUser(user);

                if (activeStep === 1) {
                    const { data: profile } = await supabase
                        .from("user_profiles")
                        .select("username, subjects")
                        .eq("user_id", user.id)
                        .single();

                    if (
                        profile?.username &&
                        profile?.subjects &&
                        profile.subjects.length > 0
                    ) {
                        router.push("/dashboard");
                    } else {
                        setActiveStep(2);
                    }
                }
            }
        };
        checkUser();
    }, [supabase, router, activeStep]);

    useEffect(() => {
        if (activeStep === 3 && availableSubjects.length === 0) {
            setIsLoadingSubjects(true);
            fetch("/api/subjects")
                .then((res) => res.json())
                .then((data) => {
                    if (data.subjects) setAvailableSubjects(data.subjects);
                })
                .catch(() => toast.error("Failed to load subjects"))
                .finally(() => setIsLoadingSubjects(false));
        }
    }, [activeStep, availableSubjects.length]);

    useEffect(() => {
        const checkAvailability = async () => {
            if (username.length < 3) {
                setIsUsernameAvailable(false);
                setUsernameError(username.length > 0 ? "Too short" : "");
                return;
            }

            const regex = /^[a-z0-9_]+$/;
            if (!regex.test(username)) {
                setIsUsernameAvailable(false);
                setUsernameError(
                    "Only lowercase letters, numbers, and underscores",
                );
                return;
            }

            setIsCheckingUsername(true);
            try {
                const res = await fetch(
                    `/api/onboarding/check-username?username=${username}`,
                );
                const data = await res.json();
                setIsUsernameAvailable(data.available);
                setUsernameError(data.available ? "" : "Username taken");
            } catch {
                setUsernameError("Error checking availability");
            } finally {
                setIsCheckingUsername(false);
            }
        };

        const timeout = setTimeout(checkAvailability, 500);
        return () => clearTimeout(timeout);
    }, [username]);

    useEffect(() => {
        if (activeStep === 4) {
            const end = Date.now() + 3 * 1000;
            const colors = ["#f97316", "#fb923c", "#fdba74", "#fff7ed"];

            const frame = () => {
                if (Date.now() > end) return;

                confetti({
                    particleCount: 2,
                    angle: 60,
                    spread: 55,
                    startVelocity: 60,
                    origin: { x: 0, y: 0.5 },
                    colors: colors,
                });
                confetti({
                    particleCount: 2,
                    angle: 120,
                    spread: 55,
                    startVelocity: 60,
                    origin: { x: 1, y: 0.5 },
                    colors: colors,
                });

                requestAnimationFrame(frame);
            };

            frame();
        }
    }, [activeStep]);

    const handleGoogleLogin = async () => {
        setIsGoogleLoading(true);
        try {
            await supabase.auth.signInWithOAuth({
                provider: "google",
                options: {
                    redirectTo: `${window.location.origin}/login`,
                },
            });
        } catch {
            toast.error("Failed to sign in with Google");
            setIsGoogleLoading(false);
        }
    };

    const handleGithubLogin = async () => {
        setIsGithubLoading(true);
        try {
            await supabase.auth.signInWithOAuth({
                provider: "github",
                options: {
                    redirectTo: `${window.location.origin}/login`,
                },
            });
        } catch {
            toast.error("Failed to sign in with GitHub");
            setIsGithubLoading(false);
        }
    };

    const handleComplete = async () => {
        if (!isUsernameAvailable || selectedSubjects.length === 0) return;

        setIsSubmitting(true);
        try {
            const res = await fetch("/api/onboarding/complete", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    username,
                    subjects: selectedSubjects,
                }),
            });

            if (!res.ok) throw new Error("Failed");

            setActiveStep(4);
        } catch {
            toast.error("Something went wrong");
        } finally {
            setIsSubmitting(false);
        }
    };

    const handleGetStarted = () => {
        router.push("/dashboard");
        router.refresh();
    };

    return (
        <AuthLayout step={activeStep}>
            <div className="hidden md:flex w-full mb-16 justify-center pt-24">
                <Stepper
                    value={activeStep}
                    onValueChange={() => {}}
                    className="bg-transparent border-none p-0 shadow-none w-auto"
                >
                    <div className="flex items-center gap-4">
                        <StepperItem
                            step={1}
                            completed={activeStep > 1}
                            className="flex-col gap-2"
                        >
                            <StepperTrigger className="bg-muted data-[state=active]:bg-orange-500 data-[state=completed]:bg-orange-500 text-muted-foreground data-[state=active]:text-white data-[state=completed]:text-white w-10 h-10 p-0 flex items-center justify-center rounded-full transition-colors duration-300">
                                <User className="w-5 h-5" />
                            </StepperTrigger>
                        </StepperItem>
                        <div
                            className={cn(
                                "w-16 h-0.5 rounded-full transition-colors duration-500",
                                activeStep > 1 ? "bg-orange-500" : "bg-muted",
                            )}
                        />

                        <StepperItem
                            step={2}
                            completed={activeStep > 2}
                            className="flex-col gap-2"
                        >
                            <StepperTrigger className="bg-muted data-[state=active]:bg-orange-500 data-[state=completed]:bg-orange-500 text-muted-foreground data-[state=active]:text-white data-[state=completed]:text-white w-10 h-10 p-0 flex items-center justify-center rounded-full transition-colors duration-300">
                                <Sparkles className="w-5 h-5" />
                            </StepperTrigger>
                        </StepperItem>
                        <div
                            className={cn(
                                "w-16 h-0.5 rounded-full transition-colors duration-500",
                                activeStep > 2 ? "bg-orange-500" : "bg-muted",
                            )}
                        />

                        <StepperItem
                            step={3}
                            completed={activeStep > 3}
                            className="flex-col gap-2"
                        >
                            <StepperTrigger className="bg-muted data-[state=active]:bg-orange-500 data-[state=completed]:bg-orange-500 text-muted-foreground data-[state=active]:text-white data-[state=completed]:text-white w-10 h-10 p-0 flex items-center justify-center rounded-full transition-colors duration-300">
                                <BookOpen className="w-5 h-5" />
                            </StepperTrigger>
                        </StepperItem>
                        <div
                            className={cn(
                                "w-16 h-0.5 rounded-full transition-colors duration-500",
                                activeStep > 3 ? "bg-orange-500" : "bg-muted",
                            )}
                        />

                        <StepperItem
                            step={4}
                            completed={activeStep >= 4}
                            className="flex-col gap-2"
                        >
                            <StepperTrigger className="bg-muted data-[state=active]:bg-orange-500 data-[state=completed]:bg-orange-500 text-muted-foreground data-[state=active]:text-white data-[state=completed]:text-white w-10 h-10 p-0 flex items-center justify-center rounded-full transition-colors duration-300">
                                <Check className="w-5 h-5" />
                            </StepperTrigger>
                        </StepperItem>
                    </div>
                </Stepper>
            </div>

            <div className="flex-1 flex flex-col justify-center h-full">
                <motion.div
                    initial={{ opacity: 0, x: 20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ duration: 0.5, ease: "easeOut" }}
                    className={cn(
                        "w-full max-w-xl mx-auto p-4 md:p-0 flex flex-col",
                        activeStep === 4
                            ? "h-full justify-between"
                            : "space-y-10 md:space-y-24",
                    )}
                >
                    <AnimatePresence mode="wait">
                        {activeStep === 1 && (
                            <motion.div
                                key="step1"
                                initial={{ opacity: 0, y: 10 }}
                                animate={{ opacity: 1, y: 0 }}
                                exit={{ opacity: 0, y: -10 }}
                                className="space-y-10 md:space-y-20"
                            >
                                <div className="space-y-4 text-center md:text-left">
                                    <h1 className="text-4xl md:text-6xl font-extrabold tracking-tight leading-tight">
                                        Sign In or{" "}
                                        <span className="text-orange-500">
                                            Join Now!
                                        </span>
                                    </h1>
                                    <p className="text-muted-foreground text-base md:text-xl">
                                        Login or create your Quesify account.
                                    </p>
                                </div>

                                <div className="space-y-4 md:space-y-8">
                                    <Button
                                        size="lg"
                                        className="w-full h-14 md:h-16 rounded-full bg-white text-black hover:bg-gray-100 border-none text-base md:text-lg font-semibold transition-all shadow-md"
                                        onClick={handleGoogleLogin}
                                        disabled={isGoogleLoading}
                                    >
                                        {isGoogleLoading ? (
                                            <Loader2 className="mr-3 h-5 w-5 md:h-6 md:w-6 animate-spin" />
                                        ) : (
                                            <svg
                                                className="mr-3 h-5 w-5 md:h-6 md:w-6"
                                                aria-hidden="true"
                                                focusable="false"
                                                data-prefix="fab"
                                                data-icon="google"
                                                role="img"
                                                xmlns="http://www.w3.org/2000/svg"
                                                viewBox="0 0 488 512"
                                            >
                                                <path
                                                    fill="currentColor"
                                                    d="M488 261.8C488 403.3 391.1 504 248 504 110.8 504 0 393.2 0 256S110.8 8 248 8c66.8 0 123 24.5 166.3 64.9l-67.5 64.9C258.5 52.6 94.3 116.6 94.3 256c0 86.5 69.1 156.6 153.7 156.6 98.2 0 135-70.4 140.8-106.9H248v-85.3h236.1c2.3 12.7 3.9 24.9 3.9 41.4z"
                                                ></path>
                                            </svg>
                                        )}
                                        {isGoogleLoading ? "Connecting..." : "Continue with Google"}
                                    </Button>

                                    <Button
                                        onClick={handleGithubLogin}
                                        className="w-full h-14 md:h-16 rounded-full bg-[#24292F] text-white hover:bg-[#24292F]/90 border border-white/10 text-base md:text-lg font-semibold transition-all shadow-md"
                                        disabled={isGithubLoading}
                                    >
                                        {isGithubLoading ? (
                                            <Loader2 className="mr-3 h-5 w-5 md:h-6 md:w-6 animate-spin" />
                                        ) : (
                                            <Github className="mr-3 h-5 w-5 md:h-6 md:w-6" />
                                        )}
                                        {isGithubLoading ? "Connecting..." : "Continue with GitHub"}
                                    </Button>
                                </div>

                                {/*<p className="text-xs md:text-sm text-center text-muted-foreground pt-0">
                                    By clicking continue, you agree to our Terms
                                    of Service and Privacy Policy.
                                </p>*/}
                            </motion.div>
                        )}

                        {activeStep === 2 && (
                            <motion.div
                                key="step2"
                                initial={{ opacity: 0, y: 10 }}
                                animate={{ opacity: 1, y: 0 }}
                                exit={{ opacity: 0, y: -10 }}
                                className="space-y-6 md:space-y-16"
                            >
                                <div className="space-y-2 md:space-y-4">
                                    <h1 className="text-2xl md:text-5xl font-bold tracking-tight">
                                        Claim your handle
                                    </h1>
                                    <p className="text-muted-foreground text-sm md:text-xl">
                                        Choose a unique username for your
                                        profile.
                                    </p>
                                </div>

                                <div className="space-y-6 md:space-y-8">
                                    <div className="relative group">
                                        <span className="absolute left-4 md:left-6 top-1/2 -translate-y-1/2 text-muted-foreground text-lg md:text-2xl font-medium group-focus-within:text-orange-500 transition-colors">
                                            @
                                        </span>
                                        <Input
                                            value={username}
                                            onChange={(e) =>
                                                setUsername(
                                                    e.target.value.toLowerCase(),
                                                )
                                            }
                                            className={cn(
                                                "pl-10 md:pl-14 h-12 md:h-20 rounded-2xl text-base md:text-2xl font-medium bg-muted/30 border-2 transition-all focus-visible:ring-0 focus-visible:border-orange-500/50",
                                                usernameError
                                                    ? "border-red-500/50 focus-visible:border-red-500"
                                                    : isUsernameAvailable
                                                      ? "border-green-500/50 focus-visible:border-green-500"
                                                      : "border-transparent hover:border-muted-foreground/20",
                                            )}
                                            placeholder="username"
                                            autoFocus
                                        />
                                        <div className="absolute right-4 md:right-6 top-1/2 -translate-y-1/2">
                                            {isCheckingUsername ? (
                                                <Loader2 className="w-5 h-5 md:w-6 md:h-6 animate-spin text-muted-foreground" />
                                            ) : isUsernameAvailable ? (
                                                <div className="bg-green-500/10 p-1 md:p-2 rounded-full">
                                                    <Check className="w-4 h-4 md:w-5 md:h-5 text-green-500" />
                                                </div>
                                            ) : null}
                                        </div>
                                    </div>

                                    {usernameError && (
                                        <motion.p
                                            initial={{ opacity: 0, height: 0 }}
                                            animate={{
                                                opacity: 1,
                                                height: "auto",
                                            }}
                                            className="text-xs md:text-base text-red-500 font-medium pl-2"
                                        >
                                            {usernameError}
                                        </motion.p>
                                    )}

                                    <Button
                                        size="lg"
                                        className="w-full h-12 md:h-16 rounded-2xl bg-orange-600 hover:bg-orange-700 text-base md:text-xl font-medium shadow-lg shadow-orange-500/20 text-white"
                                        disabled={
                                            !isUsernameAvailable ||
                                            isCheckingUsername
                                        }
                                        onClick={() => setActiveStep(3)}
                                    >
                                        Continue{" "}
                                        <ArrowRight className="ml-2 w-5 h-5 md:w-6 md:h-6" />
                                    </Button>
                                </div>
                            </motion.div>
                        )}

                        {activeStep === 3 && (
                            <motion.div
                                key="step3"
                                initial={{ opacity: 0, y: 10 }}
                                animate={{ opacity: 1, y: 0 }}
                                exit={{ opacity: 0, y: -10 }}
                                className="space-y-6 md:space-y-12"
                            >
                                <div className="space-y-2 md:space-y-4">
                                    <div className="flex items-center justify-between">
                                        <h1 className="text-2xl md:text-5xl font-bold tracking-tight">
                                            Your Focus
                                        </h1>
                                        <span className="text-xs md:text-base font-medium text-orange-500 bg-orange-500/10 px-3 md:px-4 py-1 md:py-2 rounded-full">
                                            {selectedSubjects.length} Selected
                                        </span>
                                    </div>
                                    <p className="text-muted-foreground text-sm md:text-xl">
                                        Select the subjects you&apos;re
                                        studying.
                                    </p>
                                </div>

                                {isLoadingSubjects ? (
                                    <div className="flex justify-center py-20 md:py-24">
                                        <Loader2 className="w-8 h-8 md:w-10 md:h-10 animate-spin text-orange-500" />
                                    </div>
                                ) : (
                                    <div className="grid grid-cols-2 gap-3 md:gap-4 max-h-[40vh] overflow-y-auto pr-2 custom-scrollbar">
                                        {availableSubjects.map((subject) => {
                                            const isSelected =
                                                selectedSubjects.includes(
                                                    subject,
                                                );
                                            return (
                                                <motion.button
                                                    key={subject}
                                                    whileTap={{ scale: 0.98 }}
                                                    onClick={() => {
                                                        if (isSelected) {
                                                            setSelectedSubjects(
                                                                (prev) =>
                                                                    prev.filter(
                                                                        (s) =>
                                                                            s !==
                                                                            subject,
                                                                    ),
                                                            );
                                                        } else {
                                                            setSelectedSubjects(
                                                                (prev) => [
                                                                    ...prev,
                                                                    subject,
                                                                ],
                                                            );
                                                        }
                                                    }}
                                                    className={cn(
                                                        "relative p-3 md:p-6 rounded-2xl md:rounded-3xl border-2 text-left transition-all duration-200 group overflow-hidden",
                                                        isSelected
                                                            ? "border-orange-500/50 bg-orange-500/5 shadow-sm shadow-orange-500/10"
                                                            : "border-muted/40 hover:border-orange-500/30 hover:bg-muted/30",
                                                    )}
                                                >
                                                    <div className="flex flex-col gap-2 md:gap-4 relative z-10">
                                                        <div
                                                            className={cn(
                                                                "w-8 h-8 md:w-12 md:h-12 rounded-lg md:rounded-2xl flex items-center justify-center transition-colors",
                                                                isSelected
                                                                    ? "bg-orange-500 text-white shadow-lg shadow-orange-500/30"
                                                                    : "bg-muted text-muted-foreground group-hover:bg-muted/80",
                                                            )}
                                                        >
                                                            {getSubjectIcon(
                                                                subject,
                                                                true,
                                                            )}
                                                        </div>
                                                        <span
                                                            className={cn(
                                                                "font-medium truncate text-xs md:text-lg",
                                                                isSelected
                                                                    ? "text-orange-500"
                                                                    : "text-foreground group-hover:text-foreground/80",
                                                            )}
                                                        >
                                                            {subject}
                                                        </span>
                                                    </div>
                                                    {isSelected && (
                                                        <div className="absolute top-2 right-2 md:top-4 md:right-4 text-orange-500">
                                                            <div className="bg-orange-500/10 rounded-full p-0.5 md:p-1">
                                                                <Check className="w-3 h-3 md:w-4 md:h-4" />
                                                            </div>
                                                        </div>
                                                    )}
                                                </motion.button>
                                            );
                                        })}
                                    </div>
                                )}

                                <Button
                                    size="lg"
                                    className="w-full h-12 md:h-16 rounded-2xl bg-orange-600 hover:bg-orange-700 text-base md:text-xl font-medium shadow-lg shadow-orange-500/20 text-white"
                                    disabled={
                                        selectedSubjects.length === 0 ||
                                        isSubmitting
                                    }
                                    onClick={handleComplete}
                                >
                                    {isSubmitting ? (
                                        <Loader2 className="w-5 h-5 md:w-6 md:h-6 animate-spin" />
                                    ) : (
                                        "Complete Setup"
                                    )}
                                </Button>
                            </motion.div>
                        )}

                        {activeStep === 4 && (
                            <motion.div
                                key="step4"
                                initial={{ opacity: 0, scale: 0.95 }}
                                animate={{ opacity: 1, scale: 1 }}
                                className="flex flex-col h-full py-4 md:py-12"
                            >
                                <div className="flex-1 flex flex-col items-center justify-center text-center space-y-4 md:space-y-8">
                                    <div className="relative">
                                        <div className="absolute inset-0 bg-orange-500/20 blur-3xl rounded-full" />
                                        <div className="relative bg-orange-100 dark:bg-orange-900/30 p-4 md:p-8 rounded-full text-orange-600 dark:text-orange-400">
                                            <Sparkles className="w-8 h-8 md:w-16 md:h-16" />
                                        </div>
                                    </div>

                                    <div className="space-y-2 md:space-y-4 mb-8">
                                        <h1 className="text-2xl md:text-5xl font-bold tracking-tight">
                                            You&apos;re all set!
                                        </h1>
                                        <p className="text-muted-foreground text-sm md:text-xl max-w-sm mx-auto">
                                            Let&apos;s start your learning
                                            journey.
                                        </p>
                                    </div>
                                </div>

                                <div className="mt-auto pt-4 md:pt-8 w-full flex justify-center">
                                    <div className="hidden md:block w-full max-w-sm">
                                        <Button
                                            size="lg"
                                            className="w-full h-16 rounded-2xl bg-orange-600 hover:bg-orange-700 text-xl font-medium shadow-lg shadow-orange-500/20 mx-auto block text-white"
                                            onClick={handleGetStarted}
                                        >
                                            Get Started
                                        </Button>
                                    </div>

                                    <div className="block md:hidden w-full max-w-[20rem] pb-4">
                                        <SlideButton
                                            onSuccess={handleGetStarted}
                                        />
                                    </div>
                                </div>
                            </motion.div>
                        )}
                    </AnimatePresence>
                </motion.div>
            </div>
        </AuthLayout>
    );
}
