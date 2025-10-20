import Mathlib

namespace no_23864_codeexercises_123864


-- Precondition definitions
@[reducible, simp]
def find_common_elements_precond (arr1 : Array α) (arr2 : Array α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_common_elements [BEq α] (arr1 : Array α) (arr2 : Array α) (h_precond : find_common_elements_precond (arr1) (arr2)) : Array α :=
  -- !benchmark @start code
  let result : Array α := Array.empty
  arr1.foldl (λ acc x => 
    if arr2.contains x ∧ ¬acc.contains x then
      acc.push x
    else
      acc
  ) result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_common_element [BEq α] (x : α) (arr1 arr2 : Array α) : Prop :=
  arr1.contains x ∧ arr2.contains x

-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond [BEq α] (arr1 : Array α) (arr2 : Array α) (result: Array α) (h_precond : find_common_elements_precond (arr1) (arr2)) : Prop :=
  -- !benchmark @start postcond
  ∀ (x : α), x ∈ result ↔ is_common_element x arr1 arr2
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied [BEq α] (arr1: Array α) (arr2: Array α) (h_precond : find_common_elements_precond (arr1) (arr2)) :
    find_common_elements_postcond (arr1) (arr2) (find_common_elements (arr1) (arr2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_23864_codeexercises_123864