import Mathlib

namespace no_2825_syn_1_iter_2825


-- Precondition definitions
@[reducible, simp]
def interleave_lists_precond (nums : List Nat) (chars : List Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def interleave_aux (nums : List Nat) (chars : List Char) : String :=
  match nums, chars with
  | [], [] => ""
  | n :: ns, [] => toString n ++ interleave_aux ns []
  | [], c :: cs => String.singleton c ++ interleave_aux [] cs
  | n :: ns, c :: cs => toString n ++ String.singleton c ++ interleave_aux ns cs

-- Main function definitions
def interleave_lists (nums : List Nat) (chars : List Char) (h_precond : interleave_lists_precond (nums) (chars)) : String :=
  -- !benchmark @start code
  match nums, chars with
  | [], [] => ""
  | n :: ns, [] => toString n ++ interleave_lists ns [] h_precond
  | [], c :: cs => String.singleton c ++ interleave_lists [] cs h_precond
  | n :: ns, c :: cs => toString n ++ String.singleton c ++ interleave_lists ns cs h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def interleave_aux_post (nums : List Nat) (chars : List Char) : String :=
  match nums, chars with
  | [], [] => ""
  | n :: ns, [] => toString n ++ interleave_aux_post ns []
  | [], c :: cs => String.singleton c ++ interleave_aux_post [] cs
  | n :: ns, c :: cs => toString n ++ String.singleton c ++ interleave_aux_post ns cs

-- Postcondition definitions
@[reducible, simp]
def interleave_lists_postcond (nums : List Nat) (chars : List Char) (result: String) (h_precond : interleave_lists_precond (nums) (chars)) : Prop :=
  -- !benchmark @start postcond
  result = interleave_aux_post nums chars
  -- !benchmark @end postcond


-- Proof content
theorem interleave_lists_postcond_satisfied (nums: List Nat) (chars: List Char) (h_precond : interleave_lists_precond (nums) (chars)) :
    interleave_lists_postcond (nums) (chars) (interleave_lists (nums) (chars) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2825_syn_1_iter_2825