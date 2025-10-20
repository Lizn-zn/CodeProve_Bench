import Mathlib

namespace no_49486_codeexercises_149486


-- Precondition definitions
@[reducible, simp]
def modify_elements_precond (musician : List α) (index : Nat) (new_element : α) : Prop :=
  -- !benchmark @start precond
  index < musician.length
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple list modification

-- Main function definitions
def modify_elements (musician : List α) (index : Nat) (new_element : α) (h_precond : modify_elements_precond (musician) (index) (new_element)) : List α :=
  -- !benchmark @start code
  match musician, index, new_element, h_precond with
  | l, i, e, h => 
    let rec helper : Nat → List α → List α := λ idx lst =>
      match lst with
      | [] => []
      | x :: xs => 
        if idx = 0 then
          e :: xs
        else
          x :: helper (idx - 1) xs
    helper i l
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def modify_elements_postcond (musician : List α) (index : Nat) (new_element : α) (result: List α) (h_precond : modify_elements_precond (musician) (index) (new_element)) : Prop :=
  -- !benchmark @start postcond
  result = musician.set index new_element
  -- !benchmark @end postcond


-- Proof content
theorem modify_elements_postcond_satisfied (musician: List α) (index: Nat) (new_element: α) (h_precond : modify_elements_precond (musician) (index) (new_element)) :
    modify_elements_postcond (musician) (index) (new_element) (modify_elements (musician) (index) (new_element) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_49486_codeexercises_149486