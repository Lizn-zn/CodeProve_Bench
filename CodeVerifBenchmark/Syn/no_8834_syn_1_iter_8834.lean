import Mathlib

-- Precondition definitions
@[reducible, simp]
def distinct_integers_precond (arr : Array Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def distinct_integers (arr : Array Int) (h_precond : distinct_integers_precond (arr)) : Set Int :=
  -- !benchmark @start code
  let rec loop (i : Nat) (seen : Set Int) : Set Int :=
    if h : i < arr.size then
      loop (i + 1) (seen.insert arr[i])
    else
      seen
  loop 0 ∅
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def distinct_elements (arr : Array Int) : Set Int :=
  { x | ∃ i : Fin arr.size, arr[i] = x }

-- Postcondition definitions
@[reducible, simp]
def distinct_integers_postcond (arr : Array Int) (result: Set Int) (h_precond : distinct_integers_precond (arr)) : Prop :=
  -- !benchmark @start postcond
  result = distinct_elements arr
  -- !benchmark @end postcond


-- Proof content
theorem distinct_integers_postcond_satisfied (arr: Array Int) (h_precond : distinct_integers_precond (arr)) :
    distinct_integers_postcond (arr) (distinct_integers (arr) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof