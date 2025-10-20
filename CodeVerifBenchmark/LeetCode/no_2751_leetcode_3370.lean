import Mathlib

namespace no_2751_leetcode_3370


-- Precondition auxiliary definitions
def IsAllSetBits : Nat → Prop
  | 0 => False
  | n => ∀ k, k < n → Nat.testBit n k

def nextPowerOfTwoMinusOne : Nat → Nat
  | 0 => 0
  | n => 2 ^ n - 1

-- Precondition definitions
@[reducible, simp]
def nextAllSetBits_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  n > 0
  -- !benchmark @end precond


-- Main function definitions
def nextAllSetBits (n : Nat) (h_precond : nextAllSetBits_precond n) : Nat :=
  -- !benchmark @start code
  let numBits := n.log2 + 1
  let candidate := nextPowerOfTwoMinusOne numBits
  if h : candidate ≥ n then
    candidate
  else
    nextPowerOfTwoMinusOne (numBits + 1)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def nextAllSetBits_postcond (n : Nat) (result : Nat) (h_precond : nextAllSetBits_precond n) : Prop :=
  -- !benchmark @start postcond
  result ≥ n ∧ IsAllSetBits result ∧
  ∀ x, n ≤ x → x < result → ¬ IsAllSetBits x
  -- !benchmark @end postcond


-- Proof content
theorem nextAllSetBits_postcond_satisfied (n : Nat) (h_precond : nextAllSetBits_precond n) :
    nextAllSetBits_postcond n (nextAllSetBits n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2751_leetcode_3370