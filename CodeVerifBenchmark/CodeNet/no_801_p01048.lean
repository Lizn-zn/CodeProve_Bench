import Mathlib

namespace no_801_p01048


-- Precondition definitions
@[reducible, simp]
def minNumberWithNDivisors_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ n ∧ n ≤ 12
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Precomputed lookup table for the minimum number with exactly n divisors
-- for n from 1 to 12
def minNumberWithNDivisorsTable : Array Nat :=
  #[0, 1, 2, 4, 6, 16, 12, 64, 24, 36, 48, 1024, 60]

-- Main function definitions
def minNumberWithNDivisors (n : Nat) (h_precond : minNumberWithNDivisors_precond (n)) : Nat :=
  -- !benchmark @start code
  -- Since n is between 1 and 12 (from precondition), we can use a lookup table
    -- The table contains precomputed values for the minimum number with exactly k divisors
    -- for k = 1 to 12
    minNumberWithNDivisorsTable[n]!
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Count the number of divisors of a natural number
def countDivisors (m : Nat) : Nat :=
  (List.range m).filter (fun d => d > 0 && m % d == 0) |>.length

-- Check if a number has exactly k divisors
def hasExactlyKDivisors (m k : Nat) : Prop :=
  countDivisors m = k

-- Postcondition definitions
@[reducible, simp]
def minNumberWithNDivisors_postcond (n : Nat) (result: Nat) (h_precond : minNumberWithNDivisors_precond (n)) : Prop :=
  -- !benchmark @start postcond
  -- result has exactly n divisors
    hasExactlyKDivisors result n ∧
    -- result is positive
    result > 0 ∧
    -- result is the minimum such number (no smaller positive number has exactly n divisors)
    ∀ m : Nat, 0 < m → m < result → ¬(hasExactlyKDivisors m n)
  -- !benchmark @end postcond


-- Proof content
theorem minNumberWithNDivisors_postcond_satisfied (n: Nat) (h_precond : minNumberWithNDivisors_precond (n)) :
    minNumberWithNDivisors_postcond (n) (minNumberWithNDivisors (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_801_p01048