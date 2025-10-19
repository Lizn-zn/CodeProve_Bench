import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def natToChar_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def natToChar (n : Nat) (h_precond : natToChar_precond (n)) : Char :=
  -- !benchmark @start code
  if h : n ≤ 0x10FFFF then
    have : n < 0x110000 := by omega
    Char.ofNat n
  else
    Char.ofNat 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- No auxiliary definitions needed for postcondition

-- Postcondition definitions
@[reducible, simp]
def natToChar_postcond (n : Nat) (result: Char) (h_precond : natToChar_precond (n)) : Prop :=
  -- !benchmark @start postcond
  if n ≤ 0x10FFFF then
    result.toNat = n
  else
    result.toNat = 0
  -- !benchmark @end postcond


-- Proof content
theorem natToChar_postcond_satisfied (n: Nat) (h_precond : natToChar_precond (n)) :
    natToChar_postcond (n) (natToChar (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof