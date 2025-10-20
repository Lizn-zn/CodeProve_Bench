import Mathlib

namespace no_46486_codeexercises_146486


-- Precondition definitions
@[reducible, simp]
def find_common_elements_precond (arr1 : List α) (arr2 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def find_common_elements_aux [DecidableEq α] (arr1 : List α) (arr2 : List α) : List α :=
  arr1.filter (λ x => x ∈ arr2)

-- Main function definitions
def find_common_elements [DecidableEq α] (arr1 : List α) (arr2 : List α) (h_precond : find_common_elements_precond (arr1) (arr2)) : List α :=
  -- !benchmark @start code
  find_common_elements_aux arr1 arr2
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def find_common_elements_postcond_aux [DecidableEq α] (arr1 : List α) (arr2 : List α) (result : List α) : Prop :=
  (∀ x, x ∈ result → x ∈ arr1 ∧ x ∈ arr2) ∧
  (∀ x, x ∈ arr1 → x ∈ arr2 → x ∈ result) ∧
  (∀ x, x ∈ result → result.count x = min (arr1.count x) (arr2.count x))

-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond [DecidableEq α] (arr1 : List α) (arr2 : List α) (result: List α) (h_precond : find_common_elements_precond (arr1) (arr2)) : Prop :=
  -- !benchmark @start postcond
  find_common_elements_postcond_aux arr1 arr2 result
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied [DecidableEq α] (arr1: List α) (arr2: List α) (h_precond : find_common_elements_precond (arr1) (arr2)) :
    find_common_elements_postcond (arr1) (arr2) (find_common_elements (arr1) (arr2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_46486_codeexercises_146486