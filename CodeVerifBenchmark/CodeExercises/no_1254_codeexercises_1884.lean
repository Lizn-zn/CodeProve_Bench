import Mathlib

namespace no_1254_codeexercises_1884


-- Precondition definitions
@[reducible, simp]
def modify_even_indices_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def modify_even_indices (lst : List Int) (h_precond : modify_even_indices_precond (lst)) : List Int :=
  -- !benchmark @start code
  match lst with
  | [] => []
  | [x] => [x]
  | x::y::xs => (x + y)::y::(modify_even_indices xs (by simp [modify_even_indices_precond]))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def modify_even_indices_aux (lst : List Int) : List Int :=
  match lst with
  | [] => []
  | [x] => [x]
  | x::y::xs => (x + y)::y::(modify_even_indices_aux xs)

-- Postcondition definitions
@[reducible, simp]
def modify_even_indices_postcond (lst : List Int) (result: List Int) (h_precond : modify_even_indices_precond (lst)) : Prop :=
  -- !benchmark @start postcond
  result = modify_even_indices_aux lst
  -- !benchmark @end postcond


-- Proof content
theorem modify_even_indices_postcond_satisfied (lst: List Int) (h_precond : modify_even_indices_precond (lst)) :
    modify_even_indices_postcond (lst) (modify_even_indices (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1254_codeexercises_1884