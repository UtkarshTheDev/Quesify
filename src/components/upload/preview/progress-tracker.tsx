import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Label } from "@/components/ui/label";
import { Loader2, Check, AlertTriangle } from "lucide-react";

interface ProgressLinkProps {
    label: string;
    isLoading: boolean;
    error: string | null;
    done: boolean;
    onRetry?: () => void;
}

const ProgressLink = ({
    label,
    isLoading,
    error,
    done,
    onRetry,
}: ProgressLinkProps) => (
    <div className="flex items-center justify-between text-xs px-2 py-1.5 rounded-lg bg-white/5">
        <span className="text-muted-foreground">{label}</span>
        {error ? (
            <Button
                variant="ghost"
                size="icon"
                className="h-5 w-5 text-destructive"
                onClick={onRetry}
            >
                <AlertTriangle className="h-3 w-3" />
            </Button>
        ) : isLoading ? (
            <Loader2 className="h-3 w-3 animate-spin" />
        ) : done ? (
            <Check className="h-3 w-3 text-green-500" />
        ) : null}
    </div>
);

interface ProgressTrackerProps {
    status: {
        extracting: boolean;
        extractError: string | null;
        solving: boolean;
        solveError: string | null;
        classifying: boolean;
        classifyError: string | null;
        finalizing: boolean;
        finalizeError: string | null;
    };
    data: {
        question_text: string;
        solution: string;
        subject: string;
    };
    onRetryExtract?: () => void;
    onRetrySolve?: () => void;
    onRetryClassify?: () => void;
}

export function ProgressTracker({
    status,
    data,
    onRetryExtract,
    onRetrySolve,
    onRetryClassify,
}: ProgressTrackerProps) {
    return (
        <div className="space-y-4">
            <div className="flex items-center justify-between">
                <Label className="uppercase tracking-widest text-[10px] font-bold text-primary/70">
                    AI Progress Tracker
                </Label>
                {status.finalizing ||
                status.solving ||
                status.classifying ? (
                    <Badge
                        variant="secondary"
                        className="animate-pulse bg-primary/20 text-primary border-none text-[10px]"
                    >
                        Processing
                    </Badge>
                ) : status.solveError ||
                  status.classifyError ||
                  status.extractError ? (
                    <Badge
                        variant="destructive"
                        className="bg-destructive/20 text-destructive border-none text-[10px]"
                    >
                        Attention Required
                    </Badge>
                ) : (
                    <Badge
                        variant="secondary"
                        className="bg-green-500/20 text-green-500 border-none text-[10px]"
                    >
                        Ready
                    </Badge>
                )}
            </div>

            <div className="grid grid-cols-1 gap-2.5">
                <ProgressLink
                    label="Reading Question Text"
                    isLoading={status.extracting}
                    error={status.extractError}
                    done={
                        !status.extracting &&
                        !status.extractError &&
                        !!data.question_text
                    }
                    onRetry={onRetryExtract}
                />
                <ProgressLink
                    label="Thinking through Solution"
                    isLoading={status.solving}
                    error={status.solveError}
                    done={
                        !status.solving &&
                        !status.solveError &&
                        !!data.solution
                    }
                    onRetry={onRetrySolve}
                />
                <ProgressLink
                    label="Organizing by Subject"
                    isLoading={status.classifying}
                    error={status.classifyError}
                    done={
                        !status.classifying &&
                        !status.classifyError &&
                        data.subject !== "Pending..."
                    }
                    onRetry={onRetryClassify}
                />
            </div>
        </div>
    );
}
