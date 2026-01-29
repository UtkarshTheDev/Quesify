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
  usageCount?: number | null
}

export function QuestionDeleteDialog({ show, onOpenChange, onDelete, isDeleting, usageCount }: QuestionDeleteDialogProps) {
  const hasOtherUsers = usageCount !== undefined && usageCount !== null && usageCount > 0
  
  return (
    <AlertDialog open={show} onOpenChange={onOpenChange}>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>
            {hasOtherUsers ? 'Unlink from Bank?' : 'Permanently Delete?'}
          </AlertDialogTitle>
          <AlertDialogDescription>
            {hasOtherUsers 
              ? `This question is being practiced by ${usageCount} other student${usageCount !== 1 ? 's' : ''}. Unlinking it will remove it from your bank, but it will remain on the platform for others.`
              : "No other students are currently practicing this question. This action cannot be undone and will permanently delete the question and all its solutions from our servers."
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
            {isDeleting ? (
              <Loader2 className="mr-2 h-4 w-4 animate-spin" />
            ) : (
              hasOtherUsers ? 'Unlink' : 'Delete'
            )}
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  )
}
