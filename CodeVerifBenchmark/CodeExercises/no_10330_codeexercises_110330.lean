import Mathlib

-- Precondition definitions
@[reducible, simp]
def count_pictures_precond (photos : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def count_pictures (photos : List (List Nat)) (h_precond : count_pictures_precond photos) : Nat :=
  -- !benchmark @start code
  photos.foldl (fun total set => total + set.length) 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def count_pictures_postcond (photos : List (List Nat)) (result: Nat) (h_precond : count_pictures_precond photos) : Prop :=
  -- !benchmark @start postcond
  result = (photos.map (λ set => set.length)).sum
  -- !benchmark @end postcond


-- Proof content
theorem count_pictures_postcond_satisfied (photos: List (List Nat)) (h_precond : count_pictures_precond photos) :
    count_pictures_postcond photos (count_pictures photos h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof