import Mathlib

-- Precondition definitions
@[reducible, simp]
def max_char_value_precond (pairs : List (Char × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def max_nat_in_pairs (pairs : List (Char × Nat)) : Nat :=
  match pairs with
  | [] => 0
  | (_, n) :: rest => max n (max_nat_in_pairs rest)

def clamp_to_uint8 (n : Nat) : UInt8 :=
  if n > 255 then 255 else n.toUInt8

-- Main function definitions
def max_char_value (pairs : List (Char × Nat)) (h_precond : max_char_value_precond (pairs)) : UInt8 :=
  -- !benchmark @start code
  let max_nat := max_nat_in_pairs pairs
  clamp_to_uint8 max_nat
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def max_nat_in_pairs_post (pairs : List (Char × Nat)) : Nat :=
  match pairs with
  | [] => 0
  | (_, n) :: rest => max n (max_nat_in_pairs_post rest)

def clamp_to_uint8_post (n : Nat) : UInt8 :=
  if n > 255 then 255 else n.toUInt8

-- Postcondition definitions
@[reducible, simp]
def max_char_value_postcond (pairs : List (Char × Nat)) (result: UInt8) (h_precond : max_char_value_precond (pairs)) : Prop :=
  -- !benchmark @start postcond
  result = clamp_to_uint8_post (max_nat_in_pairs_post pairs)
  -- !benchmark @end postcond


-- Proof content
theorem max_char_value_postcond_satisfied (pairs: List (Char × Nat)) (h_precond : max_char_value_precond (pairs)) :
    max_char_value_postcond (pairs) (max_char_value (pairs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof