import { Card, CardHeader, CardContent } from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Skeleton } from "./skeleton";
import { SectionFade } from "./section-fade";
import { RefreshCw, AlertTriangle, Clock, AlertCircle } from "lucide-react";

interface ClassificationSummaryProps {
    status: {
        classifying: boolean;
        classifyError: string | null;
    };
    data: {
        subject: string;
        chapter: string;
        isMCQ: boolean;
        difficulty: string;
        avg_solve_time?: number;
        topics: string[];
    };
    difficultyColors: Record<string, string>;
    onRetryClassify?: (regenerate?: boolean) => void;
    formatTime: (seconds?: number) => string;
    delay?: number;
}

export function ClassificationSummary({
    status,
    data,
    difficultyColors,
    onRetryClassify,
    formatTime,
    delay = 0,
}: ClassificationSummaryProps) {
    const isLoaded = data.subject !== "Pending..." && !status.classifying;

    return (
        <SectionFade isLoaded={isLoaded} delay={delay}>
            <Card className="border-none shadow-lg bg-card/40 backdrop-blur-sm ring-1 ring-white/5">
                <CardHeader className="pb-3 border-b border-border/40 flex flex-row items-center justify-between">
                    <Label className="uppercase tracking-widest text-[10px] font-bold text-muted-foreground opacity-70">
                        Classification
                    </Label>
                    {status.classifyError && (
                        <Button
                            variant="ghost"
                            size="icon"
                            className="h-5 w-5 text-destructive"
                            onClick={() => onRetryClassify?.(false)}
                        >
                            <AlertTriangle className="h-3 w-3" />
                        </Button>
                    )}
                </CardHeader>
                <CardContent className="px-6 pb-3 space-y-6">
                    {status.classifyError ? (
                        <div className="text-center py-4 space-y-2">
                            <p className="text-[10px] text-destructive leading-tight px-4 font-medium">
                                {status.classifyError}
                            </p>
                            <Button
                                variant="link"
                                className="h-auto p-0 text-[10px] text-primary"
                                onClick={() => onRetryClassify?.(true)}
                            >
                                Retry Classification
                            </Button>
                        </div>
                    ) : status.classifying ? (
                        <div className="space-y-4">
                            <Skeleton className="h-5 w-3/4" statusText="Syllabus mapping..." />
                            <Skeleton className="h-4 w-1/2" />
                            <div className="flex gap-2">
                                <Skeleton className="h-6 w-12" />
                                <Skeleton className="h-6 w-16" />
                            </div>
                        </div>
                    ) : (
                        <div className="space-y-6">
                            <div className="space-y-1.5">
                                <h3 className="text-lg font-bold text-primary/90 leading-tight">
                                    {data.subject || "Detecting..."}
                                </h3>
                                <p className="text-xs text-muted-foreground font-medium leading-relaxed">
                                    {data.chapter}
                                </p>
                            </div>
                            
                            <div className="flex flex-wrap gap-2">
                                <Badge
                                    variant="outline"
                                    className="text-[10px] px-3 py-1 border-primary/20 bg-primary/5 uppercase"
                                >
                                    {data.isMCQ ? "MCQ" : "Subjective"}
                                </Badge>
                                <Badge
                                    className={`text-[10px] px-3 py-1 border uppercase ${difficultyColors[data.difficulty || "medium"]}`}
                                >
                                    {data.difficulty || "medium"}
                                </Badge>
                                {data.avg_solve_time ? (
                                    <Badge
                                        variant="outline"
                                        className="text-[10px] px-3 py-1 border-blue-500/20 bg-blue-500/5 text-blue-500 flex items-center gap-1.5"
                                    >
                                        <Clock className="h-3 w-3" />
                                        {formatTime(data.avg_solve_time)}
                                    </Badge>
                                ) : null}
                            </div>
                            
                            <div className="space-y-3">
                                <Label className="text-[10px] font-bold text-muted-foreground uppercase opacity-50">
                                    Related Topics
                                </Label>
                                <div className="flex flex-wrap gap-1.5">
                                    {(data.topics || []).map((topic) => (
                                        <Badge
                                            key={topic}
                                            variant="secondary"
                                            className="text-[10px] bg-white/5 border-none font-normal px-2.5 py-1"
                                        >
                                            {topic}
                                        </Badge>
                                    ))}
                                </div>
                            </div>
                            
                            <div className="flex items-center justify-between px-2 pt-3 border-t border-border/40 mt-4">
                                <p className="text-[10px] sm:text-xs text-muted-foreground/60 font-medium flex items-center gap-2">
                                    <AlertCircle className="h-3.5 w-3.5 opacity-70 text-orange-500" />
                                    AI may be inaccurate with classifications.
                                </p>
                                <Button
                                    variant="outline"
                                    size="sm"
                                    onClick={() => onRetryClassify?.(true)}
                                    className="h-9 text-xs font-bold text-muted-foreground hover:text-orange-600 hover:bg-orange-500/5 px-4 rounded-xl border-border/40 hover:border-orange-500/50 transition-all gap-2"
                                >
                                    <RefreshCw className="h-3.5 w-3.5" />
                                    Regenerate
                                </Button>
                            </div>
                        </div>
                    )}
                </CardContent>
            </Card>
        </SectionFade>
    );
}
