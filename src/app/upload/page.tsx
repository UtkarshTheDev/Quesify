'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { Dropzone } from '@/components/upload/dropzone'
import { PreviewCard } from '@/components/upload/preview-card'
import { toast } from 'sonner'
import type { GeminiExtractionResult, DuplicateCheckResult } from '@/lib/types'

type ExtractedData = GeminiExtractionResult & {
  image_url: string;
  embedding: number[];
  duplicate_check?: DuplicateCheckResult | null;
  existing_question_id?: string;
}

export default function UploadPage() {
  const router = useRouter()
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const [isProcessing, setIsProcessing] = useState(false)
  const [extractedData, setExtractedData] = useState<ExtractedData | null>(null)
  const [isSaving, setIsSaving] = useState(false)

  // Analysis states for progressive feedback
  const [analysisStatus, setAnalysisStatus] = useState({
    extracting: false,
    solving: false,
    classifying: false,
    finalizing: false
  })

  const handleFileSelect = async (file: File) => {
    setSelectedFile(file)
    setIsProcessing(true)
    setExtractedData(null)
    setAnalysisStatus({ extracting: true, solving: false, classifying: false, finalizing: false })

    try {
      // PHASE 1: Extraction
      const formData = new FormData()
      formData.append('file', file)

      const extractRes = await fetch('/api/upload/extract', {
        method: 'POST',
        body: formData,
      })
      const extractResult = await extractRes.json()

      if (!extractRes.ok) throw new Error(extractResult.error || 'Extraction failed')

      // Show base data immediately
      const initialData: ExtractedData = {
        ...extractResult.data,
        embedding: [],
        solution: '',
        hint: '',
        numerical_answer: '',
        subject: 'Pending...',
        chapter: 'Pending...',
        topics: []
      }
      setExtractedData(initialData)
      setAnalysisStatus(prev => ({ ...prev, extracting: false, solving: true, classifying: true }))
      setIsProcessing(false) // Base processing done, card is visible

      // PHASE 2 & 3: Parallel Background Tasks
      const solvePromise = fetch('/api/upload/solve', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          question_text: extractResult.data.question_text,
          type: extractResult.data.type,
          subject: extractResult.data.subject
        })
      }).then(r => r.json())

      const classifyPromise = fetch('/api/upload/classify', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ question_text: extractResult.data.question_text })
      }).then(r => r.json())

      // Await them separately to update UI as they arrive
      solvePromise.then(res => {
        if (res.success) {
          setExtractedData(prev => prev ? ({
            ...prev,
            solution: res.data.solution,
            hint: res.data.hint,
            numerical_answer: res.data.numerical_answer
          }) : null)
        }
        setAnalysisStatus(prev => ({ ...prev, solving: false }))
      })

      classifyPromise.then(res => {
        if (res.success) {
          setExtractedData(prev => prev ? ({
            ...prev,
            subject: res.data.subject,
            chapter: res.data.chapter,
            topics: res.data.topics,
            difficulty: res.data.difficulty,
            importance: res.data.importance
          }) : null)
        }
        setAnalysisStatus(prev => ({ ...prev, classifying: false }))
      })

      // Wait for both to trigger finalization (duplicate check/embeddings)
      await Promise.allSettled([solvePromise, classifyPromise])

      setAnalysisStatus(prev => ({ ...prev, finalizing: true }))
      const finalizeRes = await fetch('/api/upload/finalize', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ question_text: extractResult.data.question_text })
      })
      const finalizeResult = await finalizeRes.json()

      if (finalizeResult.success) {
        setExtractedData(prev => prev ? ({
          ...prev,
          embedding: finalizeResult.data.embedding,
          duplicate_check: finalizeResult.data.duplicate_check
        }) : null)
      }
      setAnalysisStatus(prev => ({ ...prev, finalizing: false }))

      toast.success('Analysis complete! Review and save.')
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Processing failed. Please try again.')
      setSelectedFile(null)
      setIsProcessing(false)
      setAnalysisStatus({ extracting: false, solving: false, classifying: false, finalizing: false })
    }
  }

  const handleClear = () => {
    setSelectedFile(null)
    setExtractedData(null)
    setAnalysisStatus({ extracting: false, solving: false, classifying: false, finalizing: false })
  }

  const handleSave = async (data: ExtractedData) => {
    setIsSaving(true)
    try {
      const response = await fetch('/api/questions', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
      })

      const result = await response.json()

      if (!response.ok) {
        throw new Error(result.error || 'Save failed')
      }

      toast.success('Question saved! Your question has been added to your bank.')
      router.push('/dashboard')
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Save failed. Please try again.')
    } finally {
      setIsSaving(false)
    }
  }

  return (
    <div className="max-w-7xl mx-auto space-y-12 pb-20 px-4 lg:px-0 pt-16">
      <div className="flex flex-col items-center text-center">
        <h1 className="text-3xl font-bold tracking-tight">Upload Question</h1>
        <p className="text-muted-foreground mt-2 max-w-md">
          Upload a screenshot and let AI extract and save it
        </p>
      </div>

      <Dropzone
        onFileSelect={handleFileSelect}
        isProcessing={isProcessing}
        selectedFile={selectedFile}
        onClear={handleClear}
      />

      {extractedData && (
        <PreviewCard
          data={extractedData}
          status={analysisStatus}
          onSave={handleSave}
          isSaving={isSaving}
        />
      )}
    </div>
  )
}
