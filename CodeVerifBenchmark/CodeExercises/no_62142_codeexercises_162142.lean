import Mathlib

namespace no_62142_codeexercises_162142


-- Precondition definitions
@[reducible, simp]
def intersection_tuples_precond (t1 : List α) (t2 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No additional auxiliary definitions needed beyond what's provided in postcond_aux

-- Main function definitions
def intersection_tuples [DecidableEq α] (t1 : List α) (t2 : List α) (h_precond : intersection_tuples_precond (t1) (t2)) : List α :=
  -- !benchmark @start code
  List.inter t1 t2
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def List.mem_inter {α : Type} [DecidableEq α] (x : α) (l1 l2 : List α) : Prop :=
  x ∈ l1 ∧ x ∈ l2

-- Postcondition definitions
@[reducible, simp]
def intersection_tuples_postcond [DecidableEq α] (t1 : List α) (t2 : List α) (result: List α) (h_precond : intersection_tuples_precond (t1) (t2)) : Prop :=
  -- !benchmark @start postcond
  ∀ x, x ∈ result ↔ List.mem_inter x t1 t2 ∧
  result = List.inter t1 t2 ∧
  result.Nodup
  -- !benchmark @end postcond


-- Proof content
theorem intersection_tuples_postcond_satisfied [DecidableEq α] (t1: List α) (t2: List α) (h_precond : intersection_tuples_precond (t1) (t2)) :
    intersection_tuples_postcond (t1) (t2) (intersection_tuples (t1) (t2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_62142_codeexercises_162142