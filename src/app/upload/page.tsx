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
    extractError: null as string | null,
    solving: false,
    solveError: null as string | null,
    classifying: false,
    classifyError: null as string | null,
    finalizing: false,
    finalizeError: null as string | null,
  })

  // Phase 1: Extraction
  const runExtract = async (file: File) => {
    const start = performance.now()
    setAnalysisStatus(prev => ({ ...prev, extracting: true, extractError: null }))
    try {
      const formData = new FormData()
      formData.append('file', file)

      const res = await fetch('/api/upload/extract', {
        method: 'POST',
        body: formData,
      })
      const result = await res.json()

      if (!res.ok) throw new Error(result.error || 'Extraction failed')

      console.log(`[Frontend] Extraction phase took ${(performance.now() - start).toFixed(2)}ms`)

      const initialData: ExtractedData = {
        ...result.data,
        embedding: [],
        solution: '',
        hint: '',
        numerical_answer: '',
        subject: 'Pending...',
        chapter: 'Pending...',
        topics: []
      }
      setExtractedData(initialData)
      setAnalysisStatus(prev => ({ ...prev, extracting: false }))

      // Kick off background tasks automatically after extraction
      runSolve(result.data.question_text, result.data.type, result.data.subject, result.data.options)
      runClassify(result.data.question_text, result.data.subject)
    } catch (error) {
      setAnalysisStatus(prev => ({
        ...prev,
        extracting: false,
        extractError: error instanceof Error ? error.message : 'Extraction failed'
      }))
      toast.error('Extraction failed')
    }
  }

  // Phase 2: Solving
  const runSolve = async (text: string, type: string, subject: string, options: string[] = []) => {
    const start = performance.now()
    setAnalysisStatus(prev => ({ ...prev, solving: true, solveError: null }))
    try {
      const res = await fetch('/api/upload/solve', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ question_text: text, type, subject, options })
      })
      const result = await res.json()
      if (!res.ok) throw new Error(result.error || 'Solving failed')

      console.log(`[Frontend] Solving phase took ${(performance.now() - start).toFixed(2)}ms`)

      setExtractedData(prev => prev ? ({
        ...prev,
        solution: result.data.solution,
        hint: result.data.hint,
        numerical_answer: result.data.numerical_answer,
        avg_solve_time: result.data.avg_solve_time
      }) : null)
      setAnalysisStatus(prev => ({ ...prev, solving: false }))
      checkAllDone(text)
    } catch (error) {
      setAnalysisStatus(prev => ({
        ...prev,
        solving: false,
        solveError: error instanceof Error ? error.message : 'Solving failed'
      }))
    }
  }

  // Phase 3: Classification
  const runClassify = async (text: string, subject: string) => {
    const start = performance.now()
    setAnalysisStatus(prev => ({ ...prev, classifying: true, classifyError: null }))
    try {
      const res = await fetch('/api/upload/classify', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ question_text: text, subject })
      })
      const result = await res.json()
      if (!res.ok) throw new Error(result.error || 'Classification failed')

      console.log(`[Frontend] Classification phase took ${(performance.now() - start).toFixed(2)}ms`)

      setExtractedData(prev => prev ? ({
        ...prev,
        subject: result.data.subject,
        chapter: result.data.chapter,
        topics: result.data.topics,
        difficulty: result.data.difficulty,
        importance: result.data.importance
      }) : null)
      setAnalysisStatus(prev => ({ ...prev, classifying: false }))
      checkAllDone(text)
    } catch (error) {
      setAnalysisStatus(prev => ({
        ...prev,
        classifying: false,
        classifyError: error instanceof Error ? error.message : 'Classification failed'
      }))
    }
  }

  // Check if we should run finalization
  const checkAllDone = (text: string) => {
    setAnalysisStatus(prev => {
      if (!prev.solving && !prev.classifying && !prev.solveError && !prev.classifyError) {
        runFinalize(text)
      }
      return prev
    })
  }

  // Phase 4: Finalize (Embeddings/Duplicates)
  const runFinalize = async (text: string) => {
    const start = performance.now()
    setAnalysisStatus(prev => ({ ...prev, finalizing: true, finalizeError: null }))
    try {
      const res = await fetch('/api/upload/finalize', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ question_text: text })
      })
      const result = await res.json()
      if (result.success) {
        console.log(`[Frontend] Finalization phase took ${(performance.now() - start).toFixed(2)}ms`)
        setExtractedData(prev => prev ? ({
          ...prev,
          embedding: result.data.embedding,
          duplicate_check: result.data.duplicate_check
        }) : null)
      }
      setAnalysisStatus(prev => ({ ...prev, finalizing: false }))
    } catch (error) {
      setAnalysisStatus(prev => ({ ...prev, finalizing: false, finalizeError: 'Deduplication check failed' }))
    }
  }

  const handleFileSelect = async (file: File) => {
    setSelectedFile(file)
    setIsProcessing(true)
    setExtractedData(null)
    await runExtract(file)
    setIsProcessing(false)
  }

  const handleClear = () => {
    setSelectedFile(null)
    setExtractedData(null)
    setAnalysisStatus({
      extracting: false, extractError: null,
      solving: false, solveError: null,
      classifying: false, classifyError: null,
      finalizing: false, finalizeError: null
    })
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
          onRetryExtract={() => selectedFile && runExtract(selectedFile)}
          onRetrySolve={() => runSolve(extractedData.question_text, extractedData.type, extractedData.subject, extractedData.options)}
          onRetryClassify={() => runClassify(extractedData.question_text, extractedData.subject)}
        />
      )}
    </div>
  )
}
