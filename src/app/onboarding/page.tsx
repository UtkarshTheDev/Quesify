import { OnboardingFlow } from "@/components/onboarding/onboarding-flow"
import { Metadata } from "next"

export const metadata: Metadata = {
  title: "Setup Profile - Quesify",
  description: "Complete your profile setup",
}

export default function OnboardingPage() {
  return <OnboardingFlow />
}
