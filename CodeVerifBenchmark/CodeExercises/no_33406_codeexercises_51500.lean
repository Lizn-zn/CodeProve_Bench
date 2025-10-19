import Mathlib

-- Precondition definitions
@[reducible, simp]
def copy_and_check_lists_precond (list1 : List α) (list2 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def copy_and_check_lists [DecidableEq α] (list1 : List α) (list2 : List α) (h_precond : copy_and_check_lists_precond (list1) (list2)) : List α :=
  -- !benchmark @start code
  let common := list1.filter (λ x => list2.contains x)
  common.eraseDups
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def copy_and_check_lists_postcond (list1 : List α) (list2 : List α) (result: List α) (h_precond : copy_and_check_lists_precond (list1) (list2)) : Prop :=
  -- !benchmark @start postcond
  ∀ (x : α), x ∈ result ↔ (x ∈ list1 ∧ x ∈ list2) ∧ result.Nodup
  -- !benchmark @end postcond


-- Proof content
theorem copy_and_check_lists_postcond_satisfied [DecidableEq α] (list1: List α) (list2: List α) (h_precond : copy_and_check_lists_precond (list1) (list2)) :
    copy_and_check_lists_postcond (list1) (list2) (copy_and_check_lists (list1) (list2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof