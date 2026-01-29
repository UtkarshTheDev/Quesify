import { Card, CardHeader, CardContent } from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import { Skeleton } from "./skeleton";
import { SectionFade } from "./section-fade";
import { Latex } from "@/components/ui/latex";

interface StrategyHintProps {
    status: {
        solving: boolean;
    };
    data: {
        hint: string;
    };
    delay?: number;
}

export function StrategyHint({ status, data, delay = 0 }: StrategyHintProps) {
    const isLoaded = !!data.hint && !status.solving;

    return (
        <SectionFade isLoaded={isLoaded} delay={delay}>
            <Card className="border-none shadow-lg bg-yellow-500/[0.03] ring-1 ring-yellow-500/10">
                <CardHeader className="pb-2 border-b border-yellow-500/10">
                    <Label className="uppercase tracking-widest text-[10px] font-bold text-yellow-600/70">
                        Expert Hint / Strategy
                    </Label>
                </CardHeader>
                <CardContent className="p-6 py-0">
                    {status.solving ? (
                        <Skeleton className="h-20 w-full" statusText="Developing strategy..." />
                    ) : (
                        <div className="text-sm italic text-muted-foreground leading-relaxed border-l-4 border-yellow-500/20 pl-4 py-1 font-charter">
                            <Latex>
                                {data.hint || "Developing strategy..."}
                            </Latex>
                        </div>
                    )}
                </CardContent>
            </Card>
        </SectionFade>
    );
}
