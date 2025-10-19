import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def filter_and_repeat_chars_precond (char_nat_pairs : List (Char × Nat)) (nm_pair : Nat × Nat) (k : UInt8) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def filtered_chars (char_nat_pairs : List (Char × Nat)) (k : UInt8) : List Char :=
  char_nat_pairs.filterMap (λ (c, n) => if (n : Nat) % (k.val : Nat) = 0 then some c else none)

def repeat_chars (chars : List Char) (count : Nat) : Array Char :=
  match count with
  | 0 => #[]
  | n + 1 => repeat_chars chars n ++ chars.toArray

-- Main function definitions
def filter_and_repeat_chars (char_nat_pairs : List (Char × Nat)) (nm_pair : Nat × Nat) (k : UInt8) (h_precond : filter_and_repeat_chars_precond (char_nat_pairs) (nm_pair) (k)) : Array Char :=
  -- !benchmark @start code
  let (n, m) := nm_pair
  let filtered := filtered_chars char_nat_pairs k
  repeat_chars filtered (n * m)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def filtered_chars_post (char_nat_pairs : List (Char × Nat)) (k : UInt8) : List Char :=
  char_nat_pairs.filterMap (λ (c, n) => if (n : Nat) % (k.val : Nat) = 0 then some c else none)

def repeat_chars_post (chars : List Char) (count : Nat) : Array Char :=
  match count with
  | 0 => #[]
  | n + 1 => repeat_chars_post chars n ++ chars.toArray

-- Postcondition definitions
@[reducible, simp]
def filter_and_repeat_chars_postcond (char_nat_pairs : List (Char × Nat)) (nm_pair : Nat × Nat) (k : UInt8) (result: Array Char) (h_precond : filter_and_repeat_chars_precond (char_nat_pairs) (nm_pair) (k)) : Prop :=
  -- !benchmark @start postcond
  let (n, m) := nm_pair
  let expected := repeat_chars_post (filtered_chars_post char_nat_pairs k) (n * m)
  result = expected
  -- !benchmark @end postcond


-- Proof content
theorem filter_and_repeat_chars_postcond_satisfied (char_nat_pairs: List (Char × Nat)) (nm_pair: Nat × Nat) (k: UInt8) (h_precond : filter_and_repeat_chars_precond (char_nat_pairs) (nm_pair) (k)) :
    filter_and_repeat_chars_postcond (char_nat_pairs) (nm_pair) (k) (filter_and_repeat_chars (char_nat_pairs) (nm_pair) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof