import Mathlib

-- Precondition definitions
@[reducible, simp]
def minBlockDifference_precond (A : Nat) (B : Nat) (C : Nat) : Prop :=
  -- !benchmark @start precond
  2 ≤ A ∧ 2 ≤ B ∧ 2 ≤ C ∧ A ≤ 10^9 ∧ B ≤ 10^9 ∧ C ≤ 10^9
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def minBlockDifference (A : Nat) (B : Nat) (C : Nat) (h_precond : minBlockDifference_precond (A) (B) (C)) : Nat :=
  -- !benchmark @start code
  -- Check if at least one dimension is even
    if A % 2 = 0 || B % 2 = 0 || C % 2 = 0 then
      0
    else
      -- All dimensions are odd, return the minimum face area
      min (A * B) (min (B * C) (C * A))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if at least one dimension is even
def hasEvenDimension (A B C : Nat) : Prop :=
  A % 2 = 0 ∨ B % 2 = 0 ∨ C % 2 = 0

-- Make hasEvenDimension decidable
instance : Decidable (hasEvenDimension A B C) :=
  inferInstanceAs (Decidable (A % 2 = 0 ∨ B % 2 = 0 ∨ C % 2 = 0))

-- Helper function to compute the minimum face area
def minFaceArea (A B C : Nat) : Nat :=
  min (A * B) (min (B * C) (C * A))

-- Postcondition definitions
@[reducible, simp]
def minBlockDifference_postcond (A : Nat) (B : Nat) (C : Nat) (result: Nat) (h_precond : minBlockDifference_precond (A) (B) (C)) : Prop :=
  -- !benchmark @start postcond
  -- If at least one dimension is even, we can split the parallelepiped
    -- into two equal halves, so the difference is 0
    -- Otherwise, all dimensions are odd, and the minimum difference
    -- is the smallest face area (removing one layer from one side)
    if hasEvenDimension A B C then
      result = 0
    else
      result = minFaceArea A B C
  -- !benchmark @end postcond


-- Proof content
theorem minBlockDifference_postcond_satisfied (A: Nat) (B: Nat) (C: Nat) (h_precond : minBlockDifference_precond (A) (B) (C)) :
    minBlockDifference_postcond (A) (B) (C) (minBlockDifference (A) (B) (C) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof