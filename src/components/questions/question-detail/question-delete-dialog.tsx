import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog"
import { Loader2 } from "lucide-react"

interface QuestionDeleteDialogProps {
  show: boolean
  onOpenChange: (open: boolean) => void
  onDelete: () => void
  isDeleting: boolean
  isShared?: boolean
  usageCount?: number | null
}

export function QuestionDeleteDialog({ show, onOpenChange, onDelete, isDeleting, isShared, usageCount }: QuestionDeleteDialogProps) {
  // Determine if other users have this question
  const hasOtherUsers = usageCount !== undefined && usageCount !== null && usageCount > 0
  
  return (
    <AlertDialog open={show} onOpenChange={onOpenChange}>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>
            {hasOtherUsers ? 'Remove from your library?' : (isShared ? 'Remove from your library?' : 'Are you absolutely sure?')}
          </AlertDialogTitle>
          <AlertDialogDescription>
            {hasOtherUsers 
              ? `Warning: This question is being practiced by ${usageCount} other student${usageCount !== 1 ? 's' : ''}. Deleting it will remove it only from your library. It will remain on the platform.`
              : (isShared 
                ? "This question is being practiced by other students. You can only remove it from your own library, but it will remain on the platform for others to use."
                : "This action cannot be undone. This will permanently delete the question and all associated solutions from our servers.")
            }
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel disabled={isDeleting}>Cancel</AlertDialogCancel>
          <AlertDialogAction
            onClick={(e) => {
              e.preventDefault()
              onDelete()
            }}
            className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
            disabled={isDeleting}
          >
            {isDeleting ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : 'Delete'}
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  )
}
