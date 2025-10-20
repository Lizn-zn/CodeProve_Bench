import Mathlib

namespace no_34374_codeexercises_52989


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def intersection_elements_precond (data_set1 : List α) (data_set2 : List α) (data_set3 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the implementation

-- Main function definitions
def intersection_elements [DecidableEq α] (data_set1 : List α) (data_set2 : List α) (data_set3 : List α) (h_precond : intersection_elements_precond (data_set1) (data_set2) (data_set3)) : List α :=
  -- !benchmark @start code
  let common12 := data_set1.filter (λ x => data_set2.contains x)
  let common123 := common12.filter (λ x => data_set3.contains x)
  common123.dedup
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Auxiliary definition to check if an element is in all three lists
def elem_in_all_three (x : α) (data_set1 data_set2 data_set3 : List α) : Prop :=
  x ∈ data_set1 ∧ x ∈ data_set2 ∧ x ∈ data_set3

-- Postcondition definitions
@[reducible, simp]
def intersection_elements_postcond (data_set1 : List α) (data_set2 : List α) (data_set3 : List α) (result: List α) (h_precond : intersection_elements_precond (data_set1) (data_set2) (data_set3)) : Prop :=
  -- !benchmark @start postcond
  ∀ x : α, x ∈ result ↔ elem_in_all_three x data_set1 data_set2 data_set3 ∧
    (∀ i : Nat, i < result.length → result.get? i = some x → 
      ∀ j < i, result.get? j ≠ some x)
  -- !benchmark @end postcond


-- Proof content
theorem intersection_elements_postcond_satisfied [DecidableEq α] (data_set1: List α) (data_set2: List α) (data_set3: List α) (h_precond : intersection_elements_precond (data_set1) (data_set2) (data_set3)) :
    intersection_elements_postcond (data_set1) (data_set2) (data_set3) (intersection_elements (data_set1) (data_set2) (data_set3) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_34374_codeexercises_52989