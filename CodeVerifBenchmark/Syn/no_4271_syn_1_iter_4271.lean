import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_pairs_sum_k_precond (pairs : List (Int × Int)) (k : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def find_pairs_sum_k (pairs : List (Int × Int)) (k : Int) (h_precond : find_pairs_sum_k_precond (pairs) (k)) : Set Int :=
  -- !benchmark @start code
  pairs.foldl (λ result pair => 
    if pair.1 + pair.2 = k then
      result ∪ {pair.1, pair.2}
    else
      result
  ) ∅
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def find_pairs_sum_k_postcond (pairs : List (Int × Int)) (k : Int) (result: Set Int) (h_precond : find_pairs_sum_k_precond (pairs) (k)) : Prop :=
  -- !benchmark @start postcond
  ∀ x, x ∈ result ↔ (∃ (pair : Int × Int), pair ∈ pairs ∧ (pair.1 + pair.2 = k) ∧ (x = pair.1 ∨ x = pair.2))
  -- !benchmark @end postcond


-- Proof content
theorem find_pairs_sum_k_postcond_satisfied (pairs: List (Int × Int)) (k: Int) (h_precond : find_pairs_sum_k_precond (pairs) (k)) :
    find_pairs_sum_k_postcond (pairs) (k) (find_pairs_sum_k (pairs) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof