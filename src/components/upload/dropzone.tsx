'use client'

import Image from 'next/image'
import { useCallback, useEffect } from 'react'
import { useDropzone } from 'react-dropzone'
import { Upload, X, Loader2, Clipboard } from 'lucide-react'
import { cn } from '@/lib/utils'

interface DropzoneProps {
  onFileSelect: (file: File) => void
  isProcessing: boolean
  selectedFile: File | null
  onClear: () => void
}

export function Dropzone({ onFileSelect, isProcessing, selectedFile, onClear }: DropzoneProps) {
  const onDrop = useCallback((acceptedFiles: File[]) => {
    if (acceptedFiles[0]) {
      onFileSelect(acceptedFiles[0])
    }
  }, [onFileSelect])

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: {
      'image/*': ['.png', '.jpg', '.jpeg', '.webp'],
    },
    maxFiles: 1,
    disabled: isProcessing,
  })

  // Handle paste event for clipboard images
  useEffect(() => {
    const handlePaste = (event: ClipboardEvent) => {
      if (isProcessing || selectedFile) return

      const items = event.clipboardData?.items
      if (!items) return

      for (const item of items) {
        if (item.type.startsWith('image/')) {
          const file = item.getAsFile()
          if (file) {
            // Create a new file with a proper name
            const namedFile = new File([file], `pasted-image-${Date.now()}.png`, {
              type: file.type,
            })
            onFileSelect(namedFile)
            event.preventDefault()
            break
          }
        }
      }
    }

    document.addEventListener('paste', handlePaste)
    return () => document.removeEventListener('paste', handlePaste)
  }, [onFileSelect, isProcessing, selectedFile])

  if (selectedFile) {
    return (
      <div className="relative rounded-lg border border-border overflow-hidden">
        <Image
          src={URL.createObjectURL(selectedFile)}
          alt="Selected question"
          width={0}
          height={0}
          sizes="100vw"
          className="w-full max-h-96 object-contain bg-muted"
        />
        {isProcessing ? (
          <div className="absolute inset-0 bg-background/80 flex items-center justify-center">
            <div className="flex flex-col items-center gap-2">
              <Loader2 className="h-8 w-8 animate-spin" />
              <span className="text-sm">Processing with AI...</span>
            </div>
          </div>
        ) : (
          <button
            onClick={onClear}
            className="absolute top-2 right-2 p-1 rounded-full bg-background/80 hover:bg-background"
          >
            <X className="h-5 w-5" />
          </button>
        )}
      </div>
    )
  }

  return (
    <div
      {...getRootProps()}
      className={cn(
        'border-2 border-dashed rounded-lg p-12 text-center cursor-pointer transition-colors',
        isDragActive ? 'border-primary bg-primary/5' : 'border-muted-foreground/25 hover:border-muted-foreground/50'
      )}
    >
      <input {...getInputProps()} />
      <Upload className="h-12 w-12 mx-auto mb-4 text-muted-foreground" />
      <p className="text-lg font-medium">
        {isDragActive ? 'Drop the image here' : 'Drag & drop a question image'}
      </p>
      <p className="text-sm text-muted-foreground mt-1">
        or click to select from your device
      </p>
      <div className="flex items-center justify-center gap-2 mt-4 text-xs text-muted-foreground">
        <Clipboard className="h-3 w-3" />
        <span>You can also paste an image with Ctrl+V / Cmd+V</span>
      </div>
      <p className="text-xs text-muted-foreground mt-2">
        Supports PNG, JPG, JPEG, WebP (max 10MB)
      </p>
    </div>
  )
}
