"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import {
    Edit2,
    HelpCircle,
    Loader2,
    Sparkles,
    BookOpen,
    CheckCircle2,
} from "lucide-react";

import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Textarea } from "@/components/ui/textarea";
import { Latex } from "@/components/ui/latex";
import type { Question, Solution } from "@/lib/types";
import { SolutionCard } from "@/components/questions/solution-card";
import { AIContentAssistant } from "@/components/ai/content-assistant";
import { RevealSolutionPlaceholder } from "@/components/questions/reveal-solution-placeholder";
import { SolutionCardList } from "@/components/questions/solution-card-list";
import { cn } from "@/lib/utils";
import { AIChatTab } from "@/components/questions/question-detail/ai-chat-tab";

interface QuestionTabsProps {
    question: Question & { solutions: Solution[] };
    userId: string | null;
    isGenerating: boolean;
    isSaving: boolean;
    editForm: { hint: string };
    setEditForm: (form: { hint: string }) => void;
    handleGenerateSolution: () => void;
    handleSolutionDelete: (solutionId: string) => void;
    handleSave: (section: "hint" | "tags") => void;
    totalSolutionsCount: number;
    isRevealed: boolean;
    setIsRevealed: (show: boolean) => void;
    selectedSolutionId: string | null;
    setSelectedSolutionId: (id: string | null) => void;
    moreSolutions: Solution[];
    isLoadingMore: boolean;
    loadMoreSolutions: () => void;
    isEditingHint: boolean;
    setIsEditingHint: (editing: boolean) => void;
}

export function QuestionTabs({
    question,
    userId,
    isGenerating,
    isSaving,
    editForm,
    setEditForm,
    handleGenerateSolution,
    handleSolutionDelete,
    handleSave,
    totalSolutionsCount,
    isRevealed,
    setIsRevealed,
    selectedSolutionId,
    setSelectedSolutionId,
    moreSolutions,
    isLoadingMore,
    loadMoreSolutions,
    isEditingHint,
    setIsEditingHint,
}: QuestionTabsProps) {
    const router = useRouter();
    const [activeSolutionTab, setActiveSolutionTab] = useState<"best" | "more">(
        "best",
    );

    const bestSolution = question.solutions[0] || null;

    useEffect(() => {
        if (
            isRevealed &&
            totalSolutionsCount > 1 &&
            moreSolutions.length === 0
        ) {
            loadMoreSolutions();
        }
    }, [
        isRevealed,
        totalSolutionsCount,
        moreSolutions.length,
        loadMoreSolutions,
    ]);

    const handleSelectSolution = (id: string) => {
        setSelectedSolutionId(id);
    };

    return (
        <div className="space-y-6">
            <Tabs defaultValue="solutions" className="w-full">
                <div className="flex items-center justify-between pb-1 overflow-x-auto no-scrollbar">
                    <TabsList className="w-full justify-start !h-auto p-1 bg-muted/60 rounded-xl min-w-max">
                        <TabsTrigger
                            value="solutions"
                            className="flex-1 rounded-lg h-12 px-4 gap-2 text-sm font-semibold transition-all data-[state=active]:bg-background data-[state=active]:text-foreground data-[state=active]:shadow-sm"
                        >
                            <BookOpen className="h-4 w-4" />
                            Solutions{" "}
                            {totalSolutionsCount > 0 && (
                                <span className="opacity-60 font-normal text-xs ml-1">
                                    ({totalSolutionsCount})
                                </span>
                            )}
                        </TabsTrigger>
                        <TabsTrigger
                            value="hint"
                            className="flex-1 rounded-lg h-12 px-4 gap-2 text-sm font-semibold transition-all data-[state=active]:bg-background data-[state=active]:text-foreground data-[state=active]:shadow-sm"
                        >
                            <HelpCircle className="h-4 w-4" />
                            Hint
                        </TabsTrigger>
                        <TabsTrigger
                            value="chat"
                            className="flex-1 rounded-lg h-12 px-4 gap-2 text-sm font-semibold transition-all data-[state=active]:bg-gradient-to-r data-[state=active]:from-orange-500/10 data-[state=active]:to-orange-600/10 data-[state=active]:text-orange-600 data-[state=active]:border-orange-200/50 data-[state=active]:shadow-sm border border-transparent data-[state=inactive]:bg-gradient-to-r data-[state=inactive]:from-orange-500/5 data-[state=inactive]:to-orange-600/5 data-[state=inactive]:text-orange-600/90 data-[state=inactive]:border-orange-500/10"
                        >
                            <Sparkles className="h-4 w-4" />
                            Ask with AI
                        </TabsTrigger>
                    </TabsList>
                </div>

                <TabsContent value="solutions" className="mt-4 outline-none">
                    {!isRevealed ? (
                        <RevealSolutionPlaceholder
                            onReveal={() => setIsRevealed(true)}
                            solutionCount={totalSolutionsCount}
                        />
                    ) : totalSolutionsCount === 0 ? (
                        <Card className="border-dashed bg-muted/5">
                            <CardContent className="flex flex-col items-center justify-center py-12 text-center">
                                <div className="h-12 w-12 rounded-full bg-muted flex items-center justify-center mb-4">
                                    <HelpCircle className="h-6 w-6 text-muted-foreground" />
                                </div>
                                <p className="font-medium">No solutions yet</p>
                                <p className="text-sm text-muted-foreground mb-6 max-w-[250px]">
                                    Be the first to provide a solution or
                                    generate one using AI.
                                </p>
                                <Button
                                    onClick={
                                        userId
                                            ? handleGenerateSolution
                                            : () => router.push("/login")
                                    }
                                    disabled={isGenerating}
                                    variant="outline"
                                    className="gap-2"
                                >
                                    {isGenerating ? (
                                        <>
                                            <Loader2 className="h-4 w-4 animate-spin" />
                                            Generating...
                                        </>
                                    ) : (
                                        <>
                                            <Sparkles className="h-4 w-4" />
                                            {userId
                                                ? "Generate AI Solution"
                                                : "Login to Generate"}
                                        </>
                                    )}
                                </Button>
                            </CardContent>
                        </Card>
                    ) : (
                        <div className="space-y-4">
                            <div className="animate-in fade-in slide-in-from-top-2 duration-500">
                                <div className="bg-card rounded-2xl border shadow-sm overflow-hidden">
                                    {totalSolutionsCount > 1 && (
                                        <div className="flex items-center justify-between px-4 py-2.5 bg-muted/30 border-b">
                                            <div className="flex p-0.5 bg-muted/50 rounded-lg border w-fit">
                                                <button
                                                    onClick={() => {
                                                        setActiveSolutionTab(
                                                            "best",
                                                        );
                                                        setSelectedSolutionId(
                                                            null,
                                                        );
                                                    }}
                                                    className={cn(
                                                        "px-4 py-2 text-[11px] font-bold uppercase tracking-wider rounded-md transition-all flex-1 md:flex-none text-center",
                                                        activeSolutionTab ===
                                                            "best" &&
                                                            !selectedSolutionId
                                                            ? "bg-primary text-primary-foreground shadow-sm"
                                                            : "text-muted-foreground hover:text-foreground hover:bg-muted",
                                                    )}
                                                >
                                                    Top Pick
                                                </button>
                                                <button
                                                    onClick={() =>
                                                        setActiveSolutionTab(
                                                            "more",
                                                        )
                                                    }
                                                    className={cn(
                                                        "px-4 py-2 text-[11px] font-bold uppercase tracking-wider rounded-md transition-all flex-1 md:flex-none text-center",
                                                        activeSolutionTab ===
                                                            "more"
                                                            ? "bg-primary text-primary-foreground shadow-sm"
                                                            : "text-muted-foreground hover:text-foreground hover:bg-muted",
                                                    )}
                                                >
                                                    Community (
                                                    {totalSolutionsCount - 1})
                                                </button>
                                            </div>

                                            {selectedSolutionId &&
                                                activeSolutionTab ===
                                                    "more" && (
                                                    <Button
                                                        variant="ghost"
                                                        size="sm"
                                                        className="h-7 text-[10px] uppercase font-bold tracking-widest text-primary hover:bg-primary/5 px-2"
                                                        onClick={() =>
                                                            setSelectedSolutionId(
                                                                null,
                                                            )
                                                        }
                                                    >
                                                        Back to List
                                                    </Button>
                                                )}
                                        </div>
                                    )}

                                    <div className="p-0.5">
                                        {activeSolutionTab === "best" ? (
                                            <div className="animate-in fade-in duration-300">
                                                <SolutionCard
                                                    solution={bestSolution!}
                                                    currentUserId={userId}
                                                    onDelete={
                                                        handleSolutionDelete
                                                    }
                                                    onUpdate={() =>
                                                        router.refresh()
                                                    }
                                                    isHighlighted={true}
                                                />
                                            </div>
                                        ) : (
                                            <div className="p-3 md:p-4 animate-in fade-in slide-in-from-bottom-2 duration-400">
                                                {selectedSolutionId ? (
                                                    <div className="animate-in fade-in duration-300">
                                                        <SolutionCard
                                                            solution={
                                                                moreSolutions.find(
                                                                    (s) =>
                                                                        s.id ===
                                                                        selectedSolutionId,
                                                                )!
                                                            }
                                                            currentUserId={
                                                                userId
                                                            }
                                                            onDelete={(id) => {
                                                                handleSolutionDelete(
                                                                    id,
                                                                );
                                                                setSelectedSolutionId(
                                                                    null,
                                                                );
                                                            }}
                                                            onUpdate={() => {
                                                                router.refresh();
                                                                loadMoreSolutions();
                                                            }}
                                                            isHighlighted={true}
                                                        />
                                                    </div>
                                                ) : isLoadingMore ? (
                                                    <div className="flex flex-col items-center justify-center py-12 space-y-4">
                                                        <Loader2 className="h-8 w-8 animate-spin text-primary/50" />
                                                        <p className="text-sm text-muted-foreground font-medium">
                                                            Fetching
                                                            solutions...
                                                        </p>
                                                    </div>
                                                ) : (
                                                    <SolutionCardList
                                                        solutions={
                                                            moreSolutions
                                                        }
                                                        onSelect={
                                                            handleSelectSolution
                                                        }
                                                        activeSolutionId={
                                                            selectedSolutionId
                                                        }
                                                        currentUserId={userId}
                                                    />
                                                )}
                                            </div>
                                        )}
                                    </div>
                                </div>
                            </div>
                        </div>
                    )}
                </TabsContent>

                <TabsContent value="hint" className="mt-6 outline-none">
                    <Card
                        className={cn(
                            "transition-all duration-300 border bg-muted/5 py-0 pb-6",
                            isEditingHint
                                ? "ring-2 ring-primary/20 border-primary/30"
                                : "",
                        )}
                    >
                        <CardHeader className="border-b bg-muted/10 pt-5 !pb-3 ">
                            <div className="flex items-center justify-between">
                                <CardTitle className="text-sm font-medium flex items-center gap-2 text-primary">
                                    <Sparkles className="h-4 w-4 text-yellow-500" />
                                    Strategic Hint
                                </CardTitle>
                                {!isEditingHint &&
                                    userId === question.owner_id && (
                                        <Button
                                            variant="ghost"
                                            size="sm"
                                            className="h-8 w-8 p-0 hover:bg-primary/5 rounded-full"
                                            onClick={() =>
                                                setIsEditingHint(true)
                                            }
                                        >
                                            <Edit2 className="h-4 w-4 text-muted-foreground hover:text-primary transition-colors" />
                                        </Button>
                                    )}
                            </div>
                        </CardHeader>
                        <CardContent className="pt-0">
                            {isEditingHint ? (
                                <div className="space-y-6 animate-in fade-in zoom-in-95 duration-200">
                                    <Tabs
                                        defaultValue="preview"
                                        className="w-full"
                                    >
                                        <div className="flex items-center justify-between mb-4">
                                            <TabsList className="bg-muted/50 p-1 h-9">
                                                <TabsTrigger
                                                    value="preview"
                                                    className="px-4 text-[10px] font-bold uppercase tracking-widest"
                                                >
                                                    Preview
                                                </TabsTrigger>
                                                <TabsTrigger
                                                    value="edit"
                                                    className="px-4 text-[10px] font-bold uppercase tracking-widest"
                                                >
                                                    Write
                                                </TabsTrigger>
                                            </TabsList>

                                            <div className="flex items-center gap-2">
                                                <Button
                                                    variant="ghost"
                                                    size="sm"
                                                    className="h-8 text-xs rounded-full"
                                                    onClick={() =>
                                                        setIsEditingHint(false)
                                                    }
                                                >
                                                    Cancel
                                                </Button>
                                                <Button
                                                    size="sm"
                                                    onClick={() =>
                                                        handleSave("hint")
                                                    }
                                                    disabled={isSaving}
                                                    className="h-8 text-xs rounded-full px-4"
                                                >
                                                    {isSaving ? (
                                                        <Loader2 className="h-3 w-3 animate-spin mr-2" />
                                                    ) : (
                                                        <CheckCircle2 className="h-3 w-3 mr-2" />
                                                    )}
                                                    Save
                                                </Button>
                                            </div>
                                        </div>

                                        <TabsContent
                                            value="edit"
                                            className="mt-0 focus-visible:outline-none"
                                        >
                                            <Textarea
                                                value={editForm.hint}
                                                onChange={(e) =>
                                                    setEditForm({
                                                        ...editForm,
                                                        hint: e.target.value,
                                                    })
                                                }
                                                className="min-h-[150px] font-mono resize-y bg-background border-border/50 focus:border-primary/50 rounded-xl"
                                                placeholder="Add a strategic hint..."
                                            />
                                        </TabsContent>

                                         <TabsContent
                                             value="preview"
                                             className="mt-0 focus-visible:outline-none space-y-6"
                                         >
                                             <div className="rounded-2xl border-2 border-dashed border-border/50 bg-muted/10 p-6 min-h-[120px]">
                                                 <p className="text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/50 mb-4">
                                                     Rendered Hint Preview
                                                 </p>
                                                 <div className="prose dark:prose-invert max-w-none text-sm leading-relaxed font-charter">
                                                     <Latex>
                                                         {editForm.hint ||
                                                             "Start writing to see preview..."}
                                                     </Latex>
                                                 </div>
                                             </div>

                                            <AIContentAssistant
                                                content={editForm.hint}
                                                contentType="hint"
                                                onContentChange={(val) =>
                                                    setEditForm({
                                                        ...editForm,
                                                        hint: val,
                                                    })
                                                }
                                            />
                                        </TabsContent>
                                    </Tabs>
                                </div>
                            ) : (
                                <div className="flex gap-4">
                                     <div className="h-10 w-10 rounded-full bg-yellow-500/10 flex-shrink-0 flex items-center justify-center border border-yellow-500/20">
                                         <HelpCircle className="h-5 w-5 text-yellow-500" />
                                     </div>
                                     <div className="prose dark:prose-invert flex-1 pt-1 font-medium leading-relaxed font-charter">
                                         {question.hint ? (
                                             <Latex>{question.hint}</Latex>
                                         ) : (
                                            <p className="text-muted-foreground italic text-sm">
                                                No strategic hint provided for
                                                this question.
                                            </p>
                                        )}
                                    </div>
                                </div>
                            )}
                        </CardContent>
                    </Card>
                </TabsContent>

                <TabsContent value="chat" className="mt-6 outline-none">
                    <AIChatTab question={question} />
                </TabsContent>
            </Tabs>
        </div>
    );
}
