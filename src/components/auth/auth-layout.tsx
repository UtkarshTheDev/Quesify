"use client";

import { SceneSlider } from "./scene-slider";
import { cn } from "@/lib/utils";

interface AuthLayoutProps {
  step: number;
  children: React.ReactNode;
}

export function AuthLayout({ step, children }: AuthLayoutProps) {
  const isStep3 = step === 3;
  const isStep4 = step === 4;
  
  const mobileSliderHeight = isStep3 ? "h-[50vh]" : "h-[60vh]";
  const mobileContentHeight = isStep3 ? "h-[50vh]" : "h-[40vh]";

  return (
    <main className="min-h-screen w-full bg-background flex flex-col md:grid md:grid-cols-[40%_60%] overflow-hidden">
      <section 
        className={cn(
          "w-full relative order-first transition-all duration-500 ease-in-out",
          mobileSliderHeight,
          "md:h-full"
        )}
      >
        <SceneSlider step={step} />
      </section>

      <section 
        className={cn(
          "flex-1 bg-background relative flex flex-col transition-all duration-500 ease-in-out",
          mobileContentHeight,
          "md:h-full",
          isStep4 ? "overflow-hidden" : "overflow-y-auto"
        )}
      >
        {children}
      </section>
    </main>
  );
}
