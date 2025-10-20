import Mathlib

namespace no_64082_codeexercises_164082


-- Precondition definitions
@[reducible, simp]
def remove_elements_at_odd_indices_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def remove_elements_at_odd_indices (lst : List Int) (h_precond : remove_elements_at_odd_indices_precond (lst)) : List Int :=
  -- !benchmark @start code
  match lst with
  | [] => []
  | [x] => [x]
  | x::y::xs => x :: remove_elements_at_odd_indices xs h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def remove_elements_at_odd_indices_helper : List Int → List Int
  | [] => []
  | [x] => [x]
  | x::y::xs => x :: remove_elements_at_odd_indices_helper xs

-- Postcondition definitions
@[reducible, simp]
def remove_elements_at_odd_indices_postcond (lst : List Int) (result: List Int) (h_precond : remove_elements_at_odd_indices_precond (lst)) : Prop :=
  -- !benchmark @start postcond
  result = remove_elements_at_odd_indices_helper lst
  -- !benchmark @end postcond


-- Proof content
theorem remove_elements_at_odd_indices_postcond_satisfied (lst: List Int) (h_precond : remove_elements_at_odd_indices_precond (lst)) :
    remove_elements_at_odd_indices_postcond (lst) (remove_elements_at_odd_indices (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_64082_codeexercises_164082