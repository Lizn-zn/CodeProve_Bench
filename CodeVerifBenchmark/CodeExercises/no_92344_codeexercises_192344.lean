import Mathlib

namespace no_92344_codeexercises_192344


-- Precondition definitions
@[reducible, simp]
def find_common_elements_precond (list1 : List α) (list2 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_common_elements [DecidableEq α] (list1 : List α) (list2 : List α) (h_precond : find_common_elements_precond (list1) (list2)) : List α :=
  -- !benchmark @start code
  match list1, list2 with
  | [], _ => []
  | _, [] => []
  | x::xs, ys => 
    if x ∈ ys then
      x :: find_common_elements xs ys h_precond
    else
      find_common_elements xs ys h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
@[reducible, simp]
def is_common_element {α : Type} [DecidableEq α] (x : α) (list1 list2 : List α) : Prop :=
  x ∈ list1 ∧ x ∈ list2

-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond [DecidableEq α] (list1 : List α) (list2 : List α) (result: List α) (h_precond : find_common_elements_precond (list1) (list2)) : Prop :=
  -- !benchmark @start postcond
  ∀ x, x ∈ result ↔ is_common_element x list1 list2
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied [DecidableEq α] (list1: List α) (list2: List α) (h_precond : find_common_elements_precond (list1) (list2)) :
    find_common_elements_postcond (list1) (list2) (find_common_elements (list1) (list2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_92344_codeexercises_192344