import Mathlib

namespace no_2427_leetcode_2980


-- Precondition auxiliary definitions
/-- A helper function to check if a natural number has at least one trailing zero in its binary representation. -/
def hasTrailingZero (n : Nat) : Bool :=
  n % 2 == 0

-- Precondition definitions
@[reducible, simp]
def hasTrailingZeroOr_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  -- Precondition: nums must be a non-empty list of positive natural numbers with length at least 2.
  nums.length ≥ 2 ∧ ∀ (i : Fin nums.length), nums.get i > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Count the number of even elements in a list -/
def countEven (nums : List Nat) : Nat :=
  (nums.filter (fun n => n % 2 = 0)).length

-- Main function definitions
def hasTrailingZeroOr (nums : List Nat) (h_precond : hasTrailingZeroOr_precond (nums)) : Bool :=
  -- !benchmark @start code
  -- A number has trailing zeros in binary representation if and only if it's even
  -- For a bitwise OR to be even, all operands must be even
  -- So we need at least 2 even numbers to form a valid subset
  let evenCount := countEven nums
  evenCount ≥ 2
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def hasTrailingZeroOr_postcond (nums : List Nat) (result: Bool) (h_precond : hasTrailingZeroOr_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  -- Postcondition: result is true if and only if there exists a subset of nums with at least two elements whose bitwise OR has a trailing zero.
  result = 
    (∃ (s : Finset (Fin nums.length)), s.card ≥ 2 ∧ 
      hasTrailingZero (Finset.sup s (fun i => nums.get i)))
  -- !benchmark @end postcond


-- Proof content
theorem hasTrailingZeroOr_postcond_satisfied (nums: List Nat) (h_precond : hasTrailingZeroOr_precond (nums)) :
    hasTrailingZeroOr_postcond (nums) (hasTrailingZeroOr (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2427_leetcode_2980