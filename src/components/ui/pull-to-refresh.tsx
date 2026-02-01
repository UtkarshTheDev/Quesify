'use client'

import { ReactNode } from 'react'
import { usePullToRefresh } from '@/hooks/use-pull-to-refresh'
import { Loader2, ArrowDown } from 'lucide-react'
import { motion } from 'framer-motion'

interface PullToRefreshProps {
  children: ReactNode
  onRefresh: () => void | Promise<void>
  className?: string
}

export function PullToRefresh({ children, onRefresh, className = '' }: PullToRefreshProps) {
  const { containerRef, pullProgress, isRefreshing } = usePullToRefresh({
    onRefresh,
    threshold: 80,
  })

  return (
    <div ref={containerRef} className={`relative overflow-y-auto ${className}`}>
      <div className="sticky top-0 z-50 flex justify-center overflow-hidden h-0">
        <motion.div
          className="flex items-center justify-center"
          style={{
            height: Math.max(0, pullProgress * 60),
            opacity: pullProgress,
          }}
        >
          {isRefreshing ? (
            <Loader2 className="h-6 w-6 animate-spin text-primary" />
          ) : (
            <motion.div
              animate={{ rotate: pullProgress >= 1 ? 180 : 0 }}
              transition={{ duration: 0.2 }}
            >
              <ArrowDown className="h-6 w-6 text-primary" />
            </motion.div>
          )}
        </motion.div>
      </div>
      {children}
    </div>
  )
}
