import Mathlib

-- Precondition definitions
@[reducible, simp]
def intersection_of_lists_precond (list1 : List α) (list2 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple list intersection

-- Main function definitions
def intersection_of_lists [DecidableEq α] (list1 : List α) (list2 : List α) (h_precond : intersection_of_lists_precond (list1) (list2)) : List α :=
  -- !benchmark @start code
  match list1 with
  | [] => []
  | x :: xs => 
    if list2.contains x then
      x :: intersection_of_lists xs list2 h_precond
    else
      intersection_of_lists xs list2 h_precond
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def intersection_of_lists_postcond (list1 : List α) (list2 : List α) (result: List α) (h_precond : intersection_of_lists_precond (list1) (list2)) : Prop :=
  -- !benchmark @start postcond
  ∀ x, x ∈ result ↔ x ∈ list1 ∧ x ∈ list2
  -- !benchmark @end postcond


-- Proof content
theorem intersection_of_lists_postcond_satisfied [DecidableEq α] (list1: List α) (list2: List α) (h_precond : intersection_of_lists_precond (list1) (list2)) :
    intersection_of_lists_postcond (list1) (list2) (intersection_of_lists (list1) (list2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof