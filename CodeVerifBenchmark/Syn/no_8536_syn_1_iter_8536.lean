import Mathlib

-- Precondition definitions
@[reducible, simp]
def nat_to_uint8_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this function

-- Main function definitions
def nat_to_uint8 (n : Nat) (h_precond : nat_to_uint8_precond (n)) : UInt8 :=
  -- !benchmark @start code
  if h : n < 256 then
    ⟨n, h⟩
  else
    let m := n % 256
    have h : m < 256 := by
      exact Nat.mod_lt n (by decide)
    ⟨m, h⟩
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def nat_to_uint8_postcond (n : Nat) (result: UInt8) (h_precond : nat_to_uint8_precond (n)) : Prop :=
  -- !benchmark @start postcond
  result.val = n % 256
  -- !benchmark @end postcond


-- Proof content
theorem nat_to_uint8_postcond_satisfied (n: Nat) (h_precond : nat_to_uint8_precond (n)) :
    nat_to_uint8_postcond (n) (nat_to_uint8 (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

