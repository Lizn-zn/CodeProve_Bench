import Mathlib

namespace no_26003_codeexercises_126003


-- Precondition definitions
@[reducible, simp]
def delete_element_precond (lst : List α) (element : α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def delete_element [DecidableEq α] (lst : List α) (element : α) (h_precond : delete_element_precond (lst) (element)) : List α :=
  -- !benchmark @start code
  match lst with
  | [] => []
  | h :: t => 
    if h = element then
      delete_element t element h_precond
    else
      h :: delete_element t element h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_occurrences {α : Type} [DecidableEq α] (lst : List α) (element : α) : Nat :=
  lst.filter (λ x => x = element) |>.length

-- Postcondition definitions
@[reducible, simp]
def delete_element_postcond [DecidableEq α] (lst : List α) (element : α) (result: List α) (h_precond : delete_element_precond (lst) (element)) : Prop :=
  -- !benchmark @start postcond
  ∀ (x : α), 
    (x = element → x ∉ result) ∧ 
    (x ≠ element → 
      (count_occurrences lst x = count_occurrences result x) ∧ 
      (∀ i j, i < j → result.indexOf? x = some i → lst.indexOf? x = some j → False) → 
      (∀ i j, i < j → lst.indexOf? x = some i → result.indexOf? x = some j → False))
  -- !benchmark @end postcond


-- Proof content
theorem delete_element_postcond_satisfied [DecidableEq α] (lst: List α) (element: α) (h_precond : delete_element_precond (lst) (element)) :
    delete_element_postcond (lst) (element) (delete_element (lst) (element) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_26003_codeexercises_126003