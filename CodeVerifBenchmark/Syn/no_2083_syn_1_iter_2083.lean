import Mathlib

namespace no_2083_syn_1_iter_2083


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def repeat_pairs_precond (pairs : Array (Int × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def repeat_pairs (pairs : Array (Int × Nat)) (h_precond : repeat_pairs_precond (pairs)) : List Int :=
  -- !benchmark @start code
  let rec helper (acc : List Int) (pairs : Array (Int × Nat)) (idx : Nat) : List Int :=
    if h : idx < pairs.size then
      let (i, n) := pairs[idx]'h
      helper (acc ++ List.replicate n i) pairs (idx + 1)
    else
      acc
  helper [] pairs 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def repeat_pairs_aux (pairs : Array (Int × Nat)) : List Int :=
  pairs.foldl (λ acc (i, n) => acc ++ List.replicate n i) []

-- Postcondition definitions
@[reducible, simp]
def repeat_pairs_postcond (pairs : Array (Int × Nat)) (result: List Int) (h_precond : repeat_pairs_precond (pairs)) : Prop :=
  -- !benchmark @start postcond
  result = repeat_pairs_aux pairs
  -- !benchmark @end postcond


-- Proof content
theorem repeat_pairs_postcond_satisfied (pairs: Array (Int × Nat)) (h_precond : repeat_pairs_precond (pairs)) :
    repeat_pairs_postcond (pairs) (repeat_pairs (pairs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2083_syn_1_iter_2083