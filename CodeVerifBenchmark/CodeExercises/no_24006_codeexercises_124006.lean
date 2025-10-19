import Mathlib

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
  match list1 with
  | [] => []
  | x :: xs =>
    if x ∈ list2 then
      x :: find_common_elements xs list2 h_precond
    else
      find_common_elements xs list2 h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def CommonElements (list1 list2 result : List α) : Prop :=
  ∀ x, x ∈ result ↔ x ∈ list1 ∧ x ∈ list2

-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond (list1 : List α) (list2 : List α) (result: List α) (h_precond : find_common_elements_precond (list1) (list2)) : Prop :=
  -- !benchmark @start postcond
  CommonElements list1 list2 result
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied [DecidableEq α] (list1: List α) (list2: List α) (h_precond : find_common_elements_precond (list1) (list2)) :
    find_common_elements_postcond (list1) (list2) (find_common_elements (list1) (list2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof