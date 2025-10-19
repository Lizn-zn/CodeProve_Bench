import Mathlib

-- Precondition definitions
@[reducible, simp]
def compare_tuples_precond (t1 : List α) (t2 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def compare_tuples [BEq α] (t1 : List α) (t2 : List α) (h_precond : compare_tuples_precond (t1) (t2)) : Bool :=
  -- !benchmark @start code
  match t1 with
  | [] => false
  | head :: tail =>
      if ¬(t2.contains head) then
        true
      else
        compare_tuples tail t2 h_precond
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def compare_tuples_postcond (t1 : List α) (t2 : List α) (result: Bool) (h_precond : compare_tuples_precond (t1) (t2)) : Prop :=
  -- !benchmark @start postcond
  result = (∃ x, x ∈ t1 ∧ x ∉ t2)
  -- !benchmark @end postcond


-- Proof content
theorem compare_tuples_postcond_satisfied [BEq α] (t1: List α) (t2: List α) (h_precond : compare_tuples_precond (t1) (t2)) :
    compare_tuples_postcond (t1) (t2) (compare_tuples (t1) (t2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof