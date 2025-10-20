import Mathlib

namespace no_3701_syn_1_iter_3701


-- Precondition definitions
@[reducible, simp]
def first_char_ascii_and_list_precond (chars : List Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def first_char_ascii_and_list (chars : List Char) (h_precond : first_char_ascii_and_list_precond (chars)) : UInt8 × List Char :=
  -- !benchmark @start code
  match chars with
    | [] => (0, [])
    | h::t => (h.toNat.toUInt8, chars)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def first_char_ascii_and_list_postcond (chars : List Char) (result: UInt8 × List Char) (h_precond : first_char_ascii_and_list_precond (chars)) : Prop :=
  -- !benchmark @start postcond
  match chars with
  | [] => result = (0, [])
  | h::t => result = (h.toNat.toUInt8, chars)
  -- !benchmark @end postcond


-- Proof content
theorem first_char_ascii_and_list_postcond_satisfied (chars: List Char) (h_precond : first_char_ascii_and_list_precond (chars)) :
    first_char_ascii_and_list_postcond (chars) (first_char_ascii_and_list (chars) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_3701_syn_1_iter_3701