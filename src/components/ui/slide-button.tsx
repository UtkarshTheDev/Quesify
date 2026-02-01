"use client"

import React, {
  forwardRef,
  useCallback,
  useMemo,
  useRef,
  useState,
  type JSX,
} from "react"
import {
  AnimatePresence,
  motion,
  useMotionValue,
  useSpring,
  useTransform,
  type PanInfo,
} from "framer-motion"
import { Check, ChevronRight, Loader2, X } from "lucide-react"

import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"

const DRAG_CONSTRAINTS = { left: 0, right: 180 } 
const DRAG_THRESHOLD = 0.9

const BUTTON_STATES = {
  initial: { width: "16rem" },
  completed: { width: "16rem" },
}

const ANIMATION_CONFIG = {
  spring: {
    type: "spring",
    stiffness: 400,
    damping: 40,
    mass: 0.8,
  },
} as const

type StatusIconProps = {
  status: string
}

const StatusIcon: React.FC<StatusIconProps> = ({ status }) => {
  const iconMap: Record<StatusIconProps["status"], JSX.Element> = useMemo(
    () => ({
      loading: <Loader2 className="animate-spin text-white" size={24} />,
      success: <Check size={24} className="text-white" />,
      error: <X size={24} className="text-white" />,
    }),
    []
  )

  if (!iconMap[status]) return null

  return (
    <motion.div
      key={status}
      initial={{ opacity: 0, scale: 0.5 }}
      animate={{ opacity: 1, scale: 1 }}
      exit={{ opacity: 0 }}
    >
      {iconMap[status]}
    </motion.div>
  )
}

const useButtonStatus = (resolveTo: "success" | "error", onComplete?: () => void) => {
  const [status, setStatus] = useState<
    "idle" | "loading" | "success" | "error"
  >("idle")

  const handleSubmit = useCallback(() => {
    setStatus("loading")
    setTimeout(() => {
      setStatus(resolveTo)
      if (resolveTo === "success" && onComplete) {
        setTimeout(onComplete, 500)
      }
    }, 1000)
  }, [resolveTo, onComplete])

  return { status, handleSubmit }
}

interface SlideButtonProps extends React.ComponentProps<typeof Button> {
  onSuccess?: () => void;
  className?: string;
}

const SlideButton = forwardRef<HTMLDivElement, SlideButtonProps>(
  ({ className, onSuccess }, ref) => {
    const [isDragging, setIsDragging] = useState(false)
    const [completed, setCompleted] = useState(false)
    const dragHandleRef = useRef<HTMLDivElement | null>(null)
    const { status, handleSubmit } = useButtonStatus("success", onSuccess)

    const dragX = useMotionValue(0)
    const springX = useSpring(dragX, ANIMATION_CONFIG.spring)
    const dragProgress = useTransform(
      springX,
      [0, DRAG_CONSTRAINTS.right],
      [0, 1]
    )

    const handleDragStart = useCallback(() => {
      if (completed) return
      setIsDragging(true)
    }, [completed])

    const handleDragEnd = () => {
      if (completed) return
      setIsDragging(false)

      const progress = dragProgress.get()
      if (progress >= DRAG_THRESHOLD) {
        setCompleted(true)
        handleSubmit()
      } else {
        dragX.set(0)
      }
    }

    const handleDrag = (
      _event: MouseEvent | TouchEvent | PointerEvent,
      info: PanInfo
    ) => {
      if (completed) return
      const newX = Math.max(0, Math.min(info.offset.x, DRAG_CONSTRAINTS.right))
      dragX.set(newX)
    }

    const adjustedWidth = useTransform(springX, (x) => x + 56)

    return (
      <div ref={ref} className="flex items-center justify-center w-full">
        <motion.div
          animate={completed ? BUTTON_STATES.completed : BUTTON_STATES.initial}
          transition={ANIMATION_CONFIG.spring}
          className={cn(
            "relative flex h-16 items-center rounded-full bg-muted/30 border-2 border-muted/50 p-1 overflow-hidden shadow-inner",
            className
          )}
        >
          {!completed && (
            <div className="absolute inset-0 flex items-center justify-center pl-12">
              <span className="text-sm font-semibold text-muted-foreground uppercase tracking-widest opacity-50">
                Slide to Start
              </span>
            </div>
          )}

          {!completed && (
            <motion.div
              style={{
                width: adjustedWidth,
              }}
              className="absolute inset-y-1 left-1 z-0 rounded-full bg-orange-500/20"
            />
          )}

          <AnimatePresence>
            {!completed && (
              <motion.div
                ref={dragHandleRef}
                drag="x"
                dragConstraints={DRAG_CONSTRAINTS}
                dragElastic={0.05}
                dragMomentum={false}
                onDragStart={handleDragStart}
                onDragEnd={handleDragEnd}
                onDrag={handleDrag}
                style={{ x: springX }}
                className="relative z-10"
              >
                <div
                  className={cn(
                    "flex h-14 w-14 items-center justify-center rounded-full bg-orange-500 shadow-lg shadow-orange-500/30 cursor-grab active:cursor-grabbing transition-transform",
                    isDragging && "scale-105"
                  )}
                >
                  <ChevronRight className="h-6 w-6 text-white" />
                </div>
              </motion.div>
            )}
          </AnimatePresence>

          <AnimatePresence>
            {completed && (
              <motion.div
                className="absolute inset-0 flex items-center justify-center bg-orange-500 rounded-full"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
              >
                <div className="flex items-center gap-2">
                  <StatusIcon status={status} />
                  <span className="text-white font-bold text-lg">
                    {status === "loading" ? "Starting..." : "Let's Go!"}
                  </span>
                </div>
              </motion.div>
            )}
          </AnimatePresence>
        </motion.div>
      </div>
    )
  }
)

SlideButton.displayName = "SlideButton"

export { SlideButton }
