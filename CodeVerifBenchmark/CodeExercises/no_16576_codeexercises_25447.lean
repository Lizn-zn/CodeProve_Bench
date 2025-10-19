import Mathlib

-- Precondition definitions
@[reducible, simp]
def unique_notes_precond (notes : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple function

-- Main function definitions
def unique_notes (notes : List String) (h_precond : unique_notes_precond (notes)) : List String :=
  -- !benchmark @start code
  notes.eraseDup
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def unique_notes_postcond (notes : List String) (result: List String) (h_precond : unique_notes_precond (notes)) : Prop :=
  -- !benchmark @start postcond
  result = notes.eraseDup ∧ result.Nodup
  -- !benchmark @end postcond


-- Proof content
theorem unique_notes_postcond_satisfied (notes: List String) (h_precond : unique_notes_precond (notes)) :
    unique_notes_postcond (notes) (unique_notes (notes) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

