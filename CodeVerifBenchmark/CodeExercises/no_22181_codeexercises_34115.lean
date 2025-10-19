import Mathlib

-- Precondition definitions
@[reducible, simp]
def remove_duplicates_precond (list : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def remove_duplicates [DecidableEq α] (list : List α) (h_precond : remove_duplicates_precond list) : List α :=
  -- !benchmark @start code
  let rec helper (seen : List α) (remaining : List α) : List α :=
      match remaining with
      | [] => seen.reverse
      | x :: xs =>
        if x ∈ seen then
          helper seen xs
        else
          helper (x :: seen) xs
    helper [] list
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def remove_duplicates_postcond_aux (l result : List α) : Prop :=
  (∀ x, x ∈ result ↔ x ∈ l) ∧
  (∀ i j, i < j → j < result.length → result.get? i ≠ result.get? j)

-- Postcondition definitions
@[reducible, simp]
def remove_duplicates_postcond (list : List α) (result: List α) (h_precond : remove_duplicates_precond list) : Prop :=
  -- !benchmark @start postcond
  remove_duplicates_postcond_aux list result
  -- !benchmark @end postcond


-- Proof content
theorem remove_duplicates_postcond_satisfied [DecidableEq α] (list : List α) (h_precond : remove_duplicates_precond list) :
    remove_duplicates_postcond list (remove_duplicates list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof