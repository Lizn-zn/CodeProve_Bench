import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def expand_pairs_precond (pairs : List (Int × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def expand_pairs (pairs : List (Int × Nat)) (h_precond : expand_pairs_precond (pairs)) : Array Int :=
  -- !benchmark @start code
  Id.run do
    let mut result : Array Int := #[]
    for (x, n) in pairs do
      for _ in [0:n] do
        result := result.push x
    return result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def expand_pairs_postcond_aux (pairs : List (Int × Nat)) : List Int :=
  pairs.foldl (λ acc (x, n) => acc ++ List.replicate n x) []

-- Postcondition definitions
@[reducible, simp]
def expand_pairs_postcond (pairs : List (Int × Nat)) (result : Array Int) (h_precond : expand_pairs_precond (pairs)) : Prop :=
  -- !benchmark @start postcond
  let expected := expand_pairs_postcond_aux pairs
  result.size = expected.length ∧
  ∀ (i : Fin result.size), result[i]! = expected[i]!
  -- !benchmark @end postcond


-- Proof content
theorem expand_pairs_postcond_satisfied (pairs : List (Int × Nat)) (h_precond : expand_pairs_precond (pairs)) :
    expand_pairs_postcond (pairs) (expand_pairs (pairs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof