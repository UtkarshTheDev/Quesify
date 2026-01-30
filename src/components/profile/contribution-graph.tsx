"use client";

import { useMemo, useEffect, useRef } from "react";
import { cn } from "@/lib/utils";
import {
    format,
    subDays,
    eachDayOfInterval,
    startOfWeek,
    getDay,
} from "date-fns";

interface ContributionGraphProps {
    data: { date: string; count: number }[];
    totalContributions: number;
}

export function ContributionGraph({
    data,
    totalContributions,
}: ContributionGraphProps) {
    const scrollContainerRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
        if (scrollContainerRef.current) {
            scrollContainerRef.current.scrollLeft = scrollContainerRef.current.scrollWidth;
        }
    }, []);

    const { weeks, monthLabels } = useMemo(() => {
        const today = new Date();
        const startDate = subDays(today, 364);
        const alignedStartDate = startOfWeek(startDate);

        const days = eachDayOfInterval({
            start: alignedStartDate,
            end: today,
        });

        const contributionMap = new Map(
            data.map((item) => [item.date, item.count]),
        );

        const weeks: { date: Date; count: number }[][] = [];
        let currentWeek: { date: Date; count: number }[] = [];

        days.forEach((day) => {
            if (getDay(day) === 0 && currentWeek.length > 0) {
                weeks.push(currentWeek);
                currentWeek = [];
            }
            const dateStr = format(day, "yyyy-MM-dd");
            currentWeek.push({
                date: day,
                count: contributionMap.get(dateStr) || 0,
            });
        });
        if (currentWeek.length > 0) weeks.push(currentWeek);

        const monthLabels: { label: string; index: number }[] = [];
        let lastMonth = -1;
        weeks.forEach((week, index) => {
            const firstDayOfWeek = week[0].date;
            const month = firstDayOfWeek.getMonth();
            if (month !== lastMonth) {
                monthLabels.push({
                    label: format(firstDayOfWeek, "MMM"),
                    index,
                });
                lastMonth = month;
            }
        });

        return { weeks, monthLabels };
    }, [data]);

    const getLevel = (count: number) => {
        if (count === 0) return 0;
        if (count <= 2) return 1;
        if (count <= 5) return 2;
        if (count <= 9) return 3;
        return 4;
    };

    const getLevelColor = (level: number) => {
        switch (level) {
            case 0:
                return "bg-muted/40";
            case 1:
                return "bg-orange-200 dark:bg-orange-950/40";
            case 2:
                return "bg-orange-300 dark:bg-orange-900/60";
            case 3:
                return "bg-orange-500 dark:bg-orange-700";
            case 4:
                return "bg-orange-600 dark:bg-orange-500";
            default:
                return "bg-muted/40";
        }
    };

    return (
        <div ref={scrollContainerRef} className="w-full overflow-x-auto pb-4 custom-scrollbar">
            <div className="min-w-[800px] flex flex-col gap-6">
                <div className="flex justify-between items-center">
                    <h3 className="text-sm font-bold text-foreground/70">
                        {totalContributions} contributions in the last year
                    </h3>
                    <div className="flex items-center gap-3 text-[11px] font-medium text-muted-foreground bg-muted/20 px-3 py-1.5 rounded-full border">
                        <span>Less</span>
                        <div className="flex gap-[3.9px]">
                            {[0, 1, 2, 3, 4].map((level) => (
                                <div
                                    key={level}
                                    className={cn(
                                        "w-3 h-3 rounded-[3px]",
                                        getLevelColor(level),
                                    )}
                                />
                            ))}
                        </div>
                        <span>More</span>
                    </div>
                </div>

                <div className="relative pt-6">
                    <div className="absolute top-0 left-0 right-0 flex text-[11px] font-bold text-muted-foreground/60 h-4">
                        {monthLabels.map((item, i) => (
                            <span
                                key={i}
                                style={{
                                    left: `${(item.index / weeks.length) * 100}%`,
                                    transform: "translateX(0%)",
                                }}
                                className="absolute"
                            >
                                {item.label}
                            </span>
                        ))}
                    </div>

                    <div className="flex gap-[3.9px]">
                        {weeks.map((week, weekIndex) => (
                            <div
                                key={weekIndex}
                                className="flex flex-col gap-[3.9px]"
                            >
                                {week.map((day, dayIndex) => {
                                    const level = getLevel(day.count);
                                    const dateStr = format(
                                        day.date,
                                        "MMM d, yyyy",
                                    );
                                    const countStr =
                                        day.count === 0 ? "No" : day.count;
                                    return (
                                        <div
                                            key={dayIndex}
                                            title={`${countStr} contributions on ${dateStr}`}
                                            className={cn(
                                                "w-[12px] h-3 rounded-[3px] transition-all duration-300 cursor-pointer hover:ring-2 hover:ring-orange-500/50 hover:scale-110 shadow-sm",
                                                getLevelColor(level),
                                            )}
                                        />
                                    );
                                })}
                            </div>
                        ))}
                    </div>
                </div>
            </div>
        </div>
    );
}
