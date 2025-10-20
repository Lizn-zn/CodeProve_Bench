import Mathlib

namespace no_24143_codeexercises_37169


-- Precondition definitions
@[reducible, simp]
def common_elements_precond (tuple1 : List α) (tuple2 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def common_elements [DecidableEq α] (tuple1 : List α) (tuple2 : List α) (h_precond : common_elements_precond (tuple1) (tuple2)) : List α :=
  -- !benchmark @start code
  let common := tuple1.filter (λ x => tuple2.contains x)
  common.dedup
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def common_elements_postcond [DecidableEq α] (tuple1 : List α) (tuple2 : List α) (result: List α) (h_precond : common_elements_precond (tuple1) (tuple2)) : Prop :=
  -- !benchmark @start postcond
  result = tuple1.filter (λ x => tuple2.contains x) ∧
  result.Nodup
  -- !benchmark @end postcond


-- Proof content
theorem common_elements_postcond_satisfied [DecidableEq α] (tuple1: List α) (tuple2: List α) (h_precond : common_elements_precond (tuple1) (tuple2)) :
    common_elements_postcond (tuple1) (tuple2) (common_elements (tuple1) (tuple2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_24143_codeexercises_37169