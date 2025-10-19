import Mathlib

-- Precondition definitions
@[reducible, simp]
def is_element_present_precond (element : α) (lst : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple function

-- Main function definitions
def is_element_present [BEq α] (element : α) (lst : List α) (h_precond : is_element_present_precond (element) (lst)) : Bool :=
  -- !benchmark @start code
  match lst with
  | [] => false
  | x :: xs => if x == element then true else is_element_present element xs h_precond
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def is_element_present_postcond (element : α) (lst : List α) (result: Bool) (h_precond : is_element_present_precond (element) (lst)) : Prop :=
  -- !benchmark @start postcond
  result = (element ∈ lst)
  -- !benchmark @end postcond


-- Proof content
theorem is_element_present_postcond_satisfied [BEq α] (element: α) (lst: List α) (h_precond : is_element_present_precond (element) (lst)) :
    is_element_present_postcond (element) (lst) (is_element_present (element) (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof