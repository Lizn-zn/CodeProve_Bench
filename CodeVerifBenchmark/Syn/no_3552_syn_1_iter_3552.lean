import Mathlib

namespace no_3552_syn_1_iter_3552


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
  let result_set : Set Int := ∅
  Array.foldl (λ s x => s.insert x) result_set arr
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def distinct_integers_postcond (arr : Array Int) (result: Set Int) (h_precond : distinct_integers_precond (arr)) : Prop :=
  -- !benchmark @start postcond
  ∀ (x : Int), x ∈ result ↔ ∃ (i : Fin arr.size), arr[i] = x
  -- !benchmark @end postcond


-- Proof content
theorem distinct_integers_postcond_satisfied (arr: Array Int) (h_precond : distinct_integers_precond (arr)) :
    distinct_integers_postcond (arr) (distinct_integers (arr) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_3552_syn_1_iter_3552