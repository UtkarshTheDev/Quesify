import { createClient } from '@/lib/supabase/server'

export async function uploadQuestionImage(
  file: File,
  userId: string
): Promise<string> {
  const supabase = await createClient()

  const fileExt = file.name.split('.').pop()
  const fileName = `${userId}/${Date.now()}.${fileExt}`

  const { data, error } = await supabase.storage
    .from('question-images')
    .upload(fileName, file, {
      contentType: file.type,
      upsert: false,
    })

  if (error) {
    throw new Error(`Failed to upload image: ${error.message}`)
  }

  const { data: { publicUrl } } = supabase.storage
    .from('question-images')
    .getPublicUrl(data.path)

  return publicUrl
}

export async function deleteQuestionImage(imageUrl: string): Promise<void> {
  const supabase = await createClient()

  // Extract path from URL
  const path = imageUrl.split('/question-images/')[1]
  if (!path) return

  await supabase.storage
    .from('question-images')
    .remove([path])
}
