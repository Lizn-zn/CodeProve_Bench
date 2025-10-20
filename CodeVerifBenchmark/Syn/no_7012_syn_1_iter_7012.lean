import Mathlib

namespace no_7012_syn_1_iter_7012


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def repeat_chars_precond (pairs : List (Char × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def repeat_char (c : Char) (n : Nat) : List Char :=
  match n with
  | 0 => []
  | n+1 => c :: repeat_char c n

-- Main function definitions
def repeat_chars (pairs : List (Char × Nat)) (h_precond : repeat_chars_precond (pairs)) : List Char :=
  -- !benchmark @start code
  match pairs with
  | [] => []
  | (c, n) :: rest => repeat_char c n ++ repeat_chars rest h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def expected_result (pairs : List (Char × Nat)) : List Char :=
  match pairs with
  | [] => []
  | (c, n) :: rest => repeat_char c n ++ expected_result rest

-- Postcondition definitions
@[reducible, simp]
def repeat_chars_postcond (pairs : List (Char × Nat)) (result: List Char) (h_precond : repeat_chars_precond (pairs)) : Prop :=
  -- !benchmark @start postcond
  result = expected_result pairs
  -- !benchmark @end postcond


-- Proof content
theorem repeat_chars_postcond_satisfied (pairs: List (Char × Nat)) (h_precond : repeat_chars_precond (pairs)) :
    repeat_chars_postcond (pairs) (repeat_chars (pairs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_7012_syn_1_iter_7012