import Mathlib

namespace no_29035_codeexercises_129035


-- Precondition definitions
@[reducible, simp]
def combine_math_tuples_precond (math_tuples : List (Nat × Nat)) (repeats : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def repeat_tuples_code (tuples : List (Nat × Nat)) (n : Nat) : List (Nat × Nat) :=
  match n with
  | 0 => []
  | n + 1 => tuples ++ repeat_tuples_code tuples n

-- Main function definitions
def combine_math_tuples (math_tuples : List (Nat × Nat)) (repeats : Nat) (h_precond : combine_math_tuples_precond (math_tuples) (repeats)) : List (Nat × Nat) :=
  -- !benchmark @start code
  match repeats with
  | 0 => []
  | n + 1 => math_tuples ++ combine_math_tuples math_tuples n h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def repeat_tuples_post (tuples : List (Nat × Nat)) (n : Nat) : List (Nat × Nat) :=
  match n with
  | 0 => []
  | n + 1 => tuples ++ repeat_tuples_post tuples n

-- Postcondition definitions
@[reducible, simp]
def combine_math_tuples_postcond (math_tuples : List (Nat × Nat)) (repeats : Nat) (result: List (Nat × Nat)) (h_precond : combine_math_tuples_precond (math_tuples) (repeats)) : Prop :=
  -- !benchmark @start postcond
  result = repeat_tuples_post math_tuples repeats
  -- !benchmark @end postcond


-- Proof content
theorem combine_math_tuples_postcond_satisfied (math_tuples: List (Nat × Nat)) (repeats: Nat) (h_precond : combine_math_tuples_precond (math_tuples) (repeats)) :
    combine_math_tuples_postcond (math_tuples) (repeats) (combine_math_tuples (math_tuples) (repeats) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_29035_codeexercises_129035