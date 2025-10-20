import Mathlib

namespace no_4844_syn_1_iter_4844


-- Precondition definitions
@[reducible, simp]
def repeat_chars_from_byte_precond (byte_val : UInt8) (float_list : List Float) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to convert Float to Nat (floor) and filter non-positive values
def get_positive_counts : List Float → List Nat
  | [] => []
  | f :: fs => 
    let count := Float.floor f |>.toUInt64.toNat
    if count > 0 then count :: get_positive_counts fs
    else get_positive_counts fs

-- Helper function to replicate a character based on counts
def replicate_chars (c : Char) : List Nat → List Char
  | [] => []
  | n :: ns => List.replicate n c ++ replicate_chars c ns

-- Main function definitions
def repeat_chars_from_byte (byte_val : UInt8) (float_list : List Float) (h_precond : repeat_chars_from_byte_precond (byte_val) (float_list)) : List Char :=
  -- !benchmark @start code
  let char_val : Char := Char.ofNat (byte_val.toNat)
  let counts := get_positive_counts float_list
  replicate_chars char_val counts
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_repetitions (byte_val : UInt8) (float_list : List Float) : Nat :=
  float_list.foldl (λ acc f => 
    let count := Float.floor f |>.toUInt64.toNat
    if count > 0 then acc + count else acc) 0

def expected_result (byte_val : UInt8) (float_list : List Float) : List Char :=
  let char_val : Char := Char.ofNat (byte_val.toNat)
  float_list.foldl (λ acc f => 
    let count := Float.floor f |>.toUInt64.toNat
    if count > 0 then acc ++ List.replicate count char_val else acc) []

-- Postcondition definitions
@[reducible, simp]
def repeat_chars_from_byte_postcond (byte_val : UInt8) (float_list : List Float) (result: List Char) (h_precond : repeat_chars_from_byte_precond (byte_val) (float_list)) : Prop :=
  -- !benchmark @start postcond
  result.length = count_repetitions byte_val float_list ∧
  result = expected_result byte_val float_list
  -- !benchmark @end postcond


-- Proof content
theorem repeat_chars_from_byte_postcond_satisfied (byte_val: UInt8) (float_list: List Float) (h_precond : repeat_chars_from_byte_precond (byte_val) (float_list)) :
    repeat_chars_from_byte_postcond (byte_val) (float_list) (repeat_chars_from_byte (byte_val) (float_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_4844_syn_1_iter_4844