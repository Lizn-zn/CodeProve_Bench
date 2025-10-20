import Mathlib

namespace no_535_p00613


-- Postcondition auxiliary definitions
-- Helper function to compute the sum of all elements in a list
def sumList (lst : List Nat) : Nat :=
  lst.foldl (· + ·) 0

-- Precondition definitions
@[reducible, simp]
def pieceOfCake_precond (K : Nat) (sums : List Nat) : Prop :=
  -- !benchmark @start precond
  K ≥ 2 ∧ sums.length = K * (K - 1) / 2
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def pieceOfCake (K : Nat) (sums : List Nat) (h_precond : pieceOfCake_precond (K) (sums)) : Nat :=
  -- !benchmark @start code
  sumList sums / (K - 1)
  -- !benchmark @end code


-- If we have K kinds of cakes with sales quantities a₁, a₂, ..., aₖ,
-- then the sum of all pairwise sums is:
-- Σᵢ<ⱼ (aᵢ + aⱼ) = (K-1) * (a₁ + a₂ + ... + aₖ)
-- This is because each aᵢ appears exactly (K-1) times in the pairwise sums

-- Postcondition definitions
@[reducible, simp]
def pieceOfCake_postcond (K : Nat) (sums : List Nat) (result: Nat) (h_precond : pieceOfCake_precond (K) (sums)) : Prop :=
  -- !benchmark @start postcond
  result * (K - 1) = sumList sums
  -- !benchmark @end postcond


-- Proof content
theorem pieceOfCake_postcond_satisfied (K: Nat) (sums: List Nat) (h_precond : pieceOfCake_precond (K) (sums)) :
    pieceOfCake_postcond (K) (sums) (pieceOfCake (K) (sums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_535_p00613