"use client";

import { useState, useEffect } from "react";
import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";
import {
    Loader2,
    Check,
    ArrowRight,
    User,
    BookOpen,
    Sparkles,
} from "lucide-react";
import { Button } from "@/components/ui/button-1";
import { Input } from "@/components/ui/input";
import {
    Stepper,
    StepperItem,
    StepperTrigger,
} from "@/components/ui/stepper";
import { toast } from "sonner";
import { cn } from "@/lib/utils";

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

    useEffect(() => {
        const checkUser = async () => {
            const {
                data: { user },
            } = await supabase.auth.getUser();
            if (user) {
                setUser(user);
                setActiveStep(2);
            }
        };
        checkUser();
    }, [supabase.auth]);

    useEffect(() => {
        if (activeStep === 3) {
            setIsLoadingSubjects(true);
            fetch("/api/subjects")
                .then((res) => res.json())
                .then((data) => {
                    if (data.subjects) setAvailableSubjects(data.subjects);
                })
                .catch(() => toast.error("Failed to load subjects"))
                .finally(() => setIsLoadingSubjects(false));
        }
    }, [activeStep]);

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

    const handleGoogleLogin = async () => {
        await supabase.auth.signInWithOAuth({
            provider: "google",
            options: {
                redirectTo: `${window.location.origin}/onboarding`,
            },
        });
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

            toast.success("Welcome to Quesify!");
            router.push("/");
            router.refresh();
        } catch {
            toast.error("Something went wrong");
            setIsSubmitting(false);
        }
    };

    return (
        <div className="min-h-screen bg-background flex flex-col items-center justify-center p-4">
            <div className="w-full max-w-2xl space-y-8">
                <div className="text-center space-y-2">
                    <h1 className="text-3xl font-bold tracking-tight">
                        Welcome to Quesify
                    </h1>
                    <p className="text-muted-foreground">
                        Let&apos;s set up your profile in a few steps.
                    </p>
                </div>

                <Stepper
                    value={activeStep}
                    onValueChange={setActiveStep}
                    className="bg-card border rounded-2xl p-8 shadow-sm"
                >
                    <div className="flex w-full items-center gap-2 mb-8">
                        <StepperItem step={1} className="flex-col gap-2">
                            <StepperTrigger className="bg-orange-100 data-[state=active]:bg-orange-500 data-[state=completed]:bg-orange-500 text-orange-600 data-[state=active]:text-white data-[state=completed]:text-white">
                                <User className="w-4 h-4" />
                            </StepperTrigger>
                            <div className="text-xs font-medium text-center">
                                Login
                            </div>
                        </StepperItem>
                        <div className="h-0.5 flex-1 bg-muted -mt-6" />
                        <StepperItem step={2} className="flex-col gap-2">
                            <StepperTrigger className="bg-orange-100 data-[state=active]:bg-orange-500 data-[state=completed]:bg-orange-500 text-orange-600 data-[state=active]:text-white data-[state=completed]:text-white">
                                <Sparkles className="w-4 h-4" />
                            </StepperTrigger>
                            <div className="text-xs font-medium text-center">
                                Username
                            </div>
                        </StepperItem>
                        <div className="h-0.5 flex-1 bg-muted self-center -mt-6" />
                        <StepperItem step={3} className="flex-col gap-2">
                            <StepperTrigger className="bg-orange-100 data-[state=active]:bg-orange-500 data-[state=completed]:bg-orange-500 text-orange-600 data-[state=active]:text-white data-[state=completed]:text-white">
                                <BookOpen className="w-4 h-4" />
                            </StepperTrigger>
                            <div className="text-xs font-medium text-center">
                                Subjects
                            </div>
                        </StepperItem>
                    </div>

                    <AnimatePresence mode="wait">
                        {activeStep === 1 && (
                            <motion.div
                                key="step1"
                                initial={{ opacity: 0, x: 20 }}
                                animate={{ opacity: 1, x: 0 }}
                                exit={{ opacity: 0, x: -20 }}
                                className="space-y-6 text-center py-8"
                            >
                                <div className="space-y-2">
                                 <h2 className="text-xl font-semibold">
                                         First, let&apos;s get you signed in
                                     </h2>
                                    <p className="text-sm text-muted-foreground">
                                        Join the community to track your
                                        progress and share solutions.
                                    </p>
                                </div>
                                <Button
                                    size="lg"
                                    className="w-full max-w-xs bg-orange-600 hover:bg-orange-700 text-white"
                                    onClick={handleGoogleLogin}
                                >
                                    Sign in with Google
                                </Button>
                            </motion.div>
                        )}

                        {activeStep === 2 && (
                            <motion.div
                                key="step2"
                                initial={{ opacity: 0, x: 20 }}
                                animate={{ opacity: 1, x: 0 }}
                                exit={{ opacity: 0, x: -20 }}
                                className="space-y-6 py-4"
                            >
                                <div className="space-y-2 text-center">
                                    <h2 className="text-xl font-semibold">
                                        Choose your username
                                    </h2>
                                     <p className="text-sm text-muted-foreground">
                                         This is how you&apos;ll appear to others on
                                         Quesify.
                                     </p>
                                </div>

                                <div className="max-w-xs mx-auto space-y-4">
                                    <div className="relative">
                                        <span className="absolute left-3 top-2.5 text-muted-foreground">
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
                                                "pl-8",
                                                usernameError
                                                    ? "border-red-500 focus-visible:ring-red-500"
                                                    : isUsernameAvailable
                                                      ? "border-green-500 focus-visible:ring-green-500"
                                                      : "",
                                            )}
                                            placeholder="username"
                                        />
                                        {isCheckingUsername && (
                                            <div className="absolute right-3 top-2.5">
                                                <Loader2 className="w-4 h-4 animate-spin text-muted-foreground" />
                                            </div>
                                        )}
                                        {isUsernameAvailable &&
                                            !isCheckingUsername && (
                                                <div className="absolute right-3 top-2.5">
                                                    <Check className="w-4 h-4 text-green-500" />
                                                </div>
                                            )}
                                    </div>

                                    {usernameError && (
                                        <p className="text-xs text-red-500 text-center">
                                            {usernameError}
                                        </p>
                                    )}

                                    <Button
                                        className="w-full bg-orange-600 hover:bg-orange-700"
                                        disabled={
                                            !isUsernameAvailable ||
                                            isCheckingUsername
                                        }
                                        onClick={() => setActiveStep(3)}
                                    >
                                        Continue{" "}
                                        <ArrowRight className="ml-2 w-4 h-4" />
                                    </Button>
                                </div>
                            </motion.div>
                        )}

                        {activeStep === 3 && (
                            <motion.div
                                key="step3"
                                initial={{ opacity: 0, x: 20 }}
                                animate={{ opacity: 1, x: 0 }}
                                exit={{ opacity: 0, x: -20 }}
                                className="space-y-6 py-4"
                            >
                                <div className="space-y-2 text-center">
                                     <h2 className="text-xl font-semibold">
                                         What are you studying?
                                     </h2>
                                     <p className="text-sm text-muted-foreground">
                                         Select subjects you&apos;re interested
                                         in.
                                     </p>
                                </div>

                                {isLoadingSubjects ? (
                                    <div className="flex justify-center py-12">
                                        <Loader2 className="w-8 h-8 animate-spin text-orange-500" />
                                    </div>
                                ) : (
                                    <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
                                        {availableSubjects.map((subject) => (
                                            <button
                                                type="button"
                                                key={subject}
                                                onClick={() => {
                                                    if (
                                                        selectedSubjects.includes(
                                                            subject,
                                                        )
                                                    ) {
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
                                                    "p-4 rounded-xl border text-sm font-medium transition-all hover:border-orange-500/50 hover:bg-orange-50",
                                                    selectedSubjects.includes(
                                                        subject,
                                                    )
                                                        ? "border-orange-500 bg-orange-50 text-orange-700 ring-1 ring-orange-500"
                                                        : "bg-card text-muted-foreground",
                                                )}
                                            >
                                                {subject}
                                            </button>
                                        ))}
                                    </div>
                                )}

                                <div className="flex justify-end pt-4">
                                    <Button
                                        className="w-full sm:w-auto bg-orange-600 hover:bg-orange-700"
                                        disabled={
                                            selectedSubjects.length === 0 ||
                                            isSubmitting
                                        }
                                        onClick={handleComplete}
                                    >
                                        {isSubmitting && (
                                            <Loader2 className="mr-2 w-4 h-4 animate-spin" />
                                        )}
                                        Complete Setup
                                    </Button>
                                </div>
                            </motion.div>
                        )}
                    </AnimatePresence>
                </Stepper>
            </div>
        </div>
    );
}
