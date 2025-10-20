import Mathlib

namespace no_13550_codeexercises_20832


-- Precondition definitions
@[reducible, simp]
def concatenate_repeat_tuples_precond (tuples : List (α × β)) (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def concatenate_repeat_tuples (tuples : List (α × β)) (n : Nat) (h_precond : concatenate_repeat_tuples_precond (tuples) (n)) : List (α × β) :=
  -- !benchmark @start code
  match n with
  | 0 => []
  | Nat.succ k => tuples ++ concatenate_repeat_tuples tuples k h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def repeat_list (l : List (α × β)) (n : Nat) : List (α × β) :=
  match n with
  | 0 => []
  | Nat.succ k => l ++ repeat_list l k

-- Postcondition definitions
@[reducible, simp]
def concatenate_repeat_tuples_postcond (tuples : List (α × β)) (n : Nat) (result: List (α × β)) (h_precond : concatenate_repeat_tuples_precond (tuples) (n)) : Prop :=
  -- !benchmark @start postcond
  result = repeat_list tuples n
  -- !benchmark @end postcond


-- Proof content
theorem concatenate_repeat_tuples_postcond_satisfied (tuples: List (α × β)) (n: Nat) (h_precond : concatenate_repeat_tuples_precond (tuples) (n)) :
    concatenate_repeat_tuples_postcond (tuples) (n) (concatenate_repeat_tuples (tuples) (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_13550_codeexercises_20832