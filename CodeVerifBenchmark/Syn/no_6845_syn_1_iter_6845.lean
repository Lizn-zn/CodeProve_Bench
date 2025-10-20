import Mathlib

namespace no_6845_syn_1_iter_6845


-- Precondition definitions
@[reducible, simp]
def natToChar_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def natToChar (n : Nat) (h_precond : natToChar_precond (n)) : Char :=
  -- !benchmark @start code
  match n with
  | 0 => 'a'
  | 1 => 'b'
  | 2 => 'c'
  | _ => 'z'
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def natToChar_postcond (n : Nat) (result: Char) (h_precond : natToChar_precond (n)) : Prop :=
  -- !benchmark @start postcond
  match n with
  | 0 => result = 'a'
  | 1 => result = 'b'
  | 2 => result = 'c'
  | _ => result = 'z'
  -- !benchmark @end postcond


-- Proof content
theorem natToChar_postcond_satisfied (n: Nat) (h_precond : natToChar_precond (n)) :
    natToChar_postcond (n) (natToChar (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_6845_syn_1_iter_6845