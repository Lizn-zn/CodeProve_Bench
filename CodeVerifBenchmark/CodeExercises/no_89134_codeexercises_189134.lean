import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_common_elements_precond (t1 : List α) (t2 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
noncomputable def find_common_elements [DecidableEq α] (t1 : List α) (t2 : List α) (h_precond : find_common_elements_precond t1 t2) : List α :=
  -- !benchmark @start code
  -- Convert lists to sets, find intersection, then convert back to list
  let common_set := t1.toFinset ∩ t2.toFinset
  common_set.toList
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond [DecidableEq α] (t1 : List α) (t2 : List α) (result: List α) (h_precond : find_common_elements_precond t1 t2) : Prop :=
  -- !benchmark @start postcond
  let common_set := t1.toFinset ∩ t2.toFinset
  result.toFinset = common_set ∧ result.Nodup
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied [DecidableEq α] (t1: List α) (t2: List α) (h_precond : find_common_elements_precond t1 t2) :
    find_common_elements_postcond t1 t2 (find_common_elements t1 t2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof