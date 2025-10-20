import Mathlib

namespace no_2389_p03387


-- Precondition definitions
@[reducible, simp]
def minOperationsToEqualize_precond (A : Nat) (B : Nat) (C : Nat) : Prop :=
  -- !benchmark @start precond
  A ≤ 50 ∧ B ≤ 50 ∧ C ≤ 50
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute the minimum operations
-- The strategy is to find the maximum value and try to make all values equal to some target ≥ max
-- We need to find the minimum number of operations
-- Key insight: total sum increases by 2 per operation, so final sum = A + B + C + 2*ops
-- If all three equal to target T, then 3*T = A + B + C + 2*ops
-- So we need 3*T - (A+B+C) to be even, and T ≥ max(A,B,C)

-- Main function definitions
def minOperationsToEqualize (A : Nat) (B : Nat) (C : Nat) (h_precond : minOperationsToEqualize_precond (A) (B) (C)) : Nat :=
  -- !benchmark @start code
  let maxVal := max A (max B C)
    let sum := A + B + C
    -- Try targets starting from maxVal
    -- We want 3*T = sum + 2*ops, so ops = (3*T - sum) / 2
    -- We need 3*T - sum to be even and non-negative
    let target := if (3 * maxVal - sum) % 2 == 0 then maxVal else maxVal + 1
    let ops := (3 * target - sum) / 2
    ops
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Check if values can be made equal with a given number of operations
def canMakeEqual (A B C : Nat) (ops : Nat) : Prop :=
  ∃ (a b c : Nat), 
    -- Final values are all equal
    a = b ∧ b = c ∧
    -- We can reach these values from A, B, C with the given operations
    -- The total increase is 2 * ops (each operation adds 2 to the total)
    a + b + c = A + B + C + 2 * ops ∧
    -- Each value must increase by a non-negative amount
    a ≥ A ∧ b ≥ B ∧ c ≥ C

-- Postcondition definitions
@[reducible, simp]
def minOperationsToEqualize_postcond (A : Nat) (B : Nat) (C : Nat) (result: Nat) (h_precond : minOperationsToEqualize_precond (A) (B) (C)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the minimum number of operations
  canMakeEqual A B C result ∧ 
    ∀ k : Nat, k < result → ¬canMakeEqual A B C k
  -- !benchmark @end postcond


-- Proof content
theorem minOperationsToEqualize_postcond_satisfied (A: Nat) (B: Nat) (C: Nat) (h_precond : minOperationsToEqualize_precond (A) (B) (C)) :
    minOperationsToEqualize_postcond (A) (B) (C) (minOperationsToEqualize (A) (B) (C) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2389_p03387