import Mathlib

namespace no_2022_leetcode_2450


-- Precondition auxiliary definitions
def isValidBinaryString (s : String) : Prop :=
  ∀ (c : Char), c ∈ s.data → (c = '0' ∨ c = '1')

def modVal : Nat := 1000000007

-- Precondition definitions
@[reducible, simp]
def countDistinctStrings_precond (s : String) (k : Nat) : Prop :=
  -- !benchmark @start precond
  k > 0 ∧ k ≤ s.length ∧ isValidBinaryString s
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute (2 ^ n) % modVal efficiently
def powMod (base exp modulus : Nat) : Nat :=
  if modulus = 0 then
    0
  else
    let rec loop (b e acc : Nat) : Nat :=
      if e = 0 then
        acc % modulus
      else if e % 2 = 1 then
        loop ((b * b) % modulus) (e / 2) ((acc * b) % modulus)
      else
        loop ((b * b) % modulus) (e / 2) acc
    loop (base % modulus) exp 1

-- Prove that for any valid input, k ≤ s.length
theorem k_le_length (s : String) (k : Nat) (h : countDistinctStrings_precond s k) : k ≤ s.length := by
  simp [countDistinctStrings_precond] at h
  exact h.2.1

-- Main function definitions
def countDistinctStrings (s : String) (k : Nat) (h_precond : countDistinctStrings_precond (s) (k)) : Nat :=
  -- !benchmark @start code
  let n := s.length
  have h_k_le_n : k ≤ n := k_le_length s k h_precond
  let exponent := n - k + 1
  powMod 2 exponent modVal
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- The key insight here is that each of the first (n - k + 1) positions can be chosen or not to flip,
-- leading to 2^(n - k + 1) distinct outcomes.
def countDistinctStrings_formula (s : String) (k : Nat) : Nat :=
  let n := s.length
  if h : k ≤ n then
    (2 ^ (n - k + 1)) % modVal
  else
    1 -- This case shouldn't happen due to precondition but included for completeness

-- Postcondition definitions
@[reducible, simp]
def countDistinctStrings_postcond (s : String) (k : Nat) (result: Nat) (h_precond : countDistinctStrings_precond (s) (k)) : Prop :=
  -- !benchmark @start postcond
  result = countDistinctStrings_formula s k
  -- !benchmark @end postcond


-- Proof content
theorem countDistinctStrings_postcond_satisfied (s: String) (k: Nat) (h_precond : countDistinctStrings_precond (s) (k)) :
    countDistinctStrings_postcond (s) (k) (countDistinctStrings (s) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2022_leetcode_2450