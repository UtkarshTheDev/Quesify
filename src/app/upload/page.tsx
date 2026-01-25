'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { Dropzone } from '@/components/upload/dropzone'
import { PreviewCard } from '@/components/upload/preview-card'
import { toast } from 'sonner'
import type { GeminiExtractionResult } from '@/lib/types'

type ExtractedData = GeminiExtractionResult & { image_url: string; embedding: number[] }

export default function UploadPage() {
  const router = useRouter()
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const [isProcessing, setIsProcessing] = useState(false)
  const [extractedData, setExtractedData] = useState<ExtractedData | null>(null)
  const [isSaving, setIsSaving] = useState(false)

  const handleFileSelect = async (file: File) => {
    setSelectedFile(file)
    setIsProcessing(true)
    setExtractedData(null)

    try {
      const formData = new FormData()
      formData.append('file', file)

      const response = await fetch('/api/upload', {
        method: 'POST',
        body: formData,
      })

      const result = await response.json()

      if (!response.ok) {
        throw new Error(result.error || 'Upload failed')
      }

      setExtractedData(result.data)
      toast.success('Question extracted! Review the details and save when ready.')
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Processing failed. Please try again.')
      setSelectedFile(null)
    } finally {
      setIsProcessing(false)
    }
  }

  const handleClear = () => {
    setSelectedFile(null)
    setExtractedData(null)
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
    <div className="max-w-2xl mx-auto space-y-6">
      <div>
        <h1 className="text-2xl font-bold">Upload Question</h1>
        <p className="text-muted-foreground">
          Upload a screenshot and let AI extract and organize it
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
          onSave={handleSave}
          isSaving={isSaving}
        />
      )}
    </div>
  )
}
