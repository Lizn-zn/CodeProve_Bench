import Mathlib

-- Precondition definitions
@[reducible, simp]
def f_precond (n : UInt8) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function to extract bits from a UInt8 value -/
def extractBits (n : UInt8) : List Nat :=
  let rec aux (val : Nat) (count : Nat) : List Nat :=
    match count with
    | 0 => []
    | count + 1 => 
      let bit := val % 2
      let rest := val / 2
      bit :: aux rest count
  aux n.toNat 8

-- Main function definitions
def f (n : UInt8) (h_precond : f_precond (n)) : List Nat :=
  -- !benchmark @start code
  extractBits n
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def bitAt (n : UInt8) (i : Nat) : Nat :=
  if (n.toNat / 2^i) % 2 = 1 then 1 else 0

-- Postcondition definitions
@[reducible, simp]
def f_postcond (n : UInt8) (result: List Nat) (h_precond : f_precond (n)) : Prop :=
  -- !benchmark @start postcond
  result.length = 8 ∧
  ∀ (i : Nat), i < 8 → result[i]! = bitAt n i
  -- !benchmark @end postcond


-- Proof content
theorem f_postcond_satisfied (n: UInt8) (h_precond : f_precond (n)) :
    f_postcond (n) (f (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

