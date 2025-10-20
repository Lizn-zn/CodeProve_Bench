import Mathlib

namespace no_34492_codeexercises_134492


-- Precondition definitions
@[reducible, simp]
def interchange_elements_precond (photo_list : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def interchange_elements (photo_list : List α) (h_precond : interchange_elements_precond (photo_list)) : List α :=
  -- !benchmark @start code
  match photo_list with
  | [] => []
  | [x] => [x]
  | x::y::xs => y::x::(interchange_elements xs (by simp [h_precond]))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def interchange_elements_postcond_aux (input output : List α) : Prop :=
  match input, output with
  | [], [] => True
  | [x], [x'] => x = x'
  | x::y::xs, y'::x'::ys => x = y' ∧ y = x' ∧ interchange_elements_postcond_aux xs ys
  | _, _ => False

-- Postcondition definitions
@[reducible, simp]
def interchange_elements_postcond (photo_list : List α) (result: List α) (h_precond : interchange_elements_precond (photo_list)) : Prop :=
  -- !benchmark @start postcond
  interchange_elements_postcond_aux photo_list result
  -- !benchmark @end postcond


-- Proof content
theorem interchange_elements_postcond_satisfied (photo_list: List α) (h_precond : interchange_elements_precond (photo_list)) :
    interchange_elements_postcond (photo_list) (interchange_elements (photo_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_34492_codeexercises_134492