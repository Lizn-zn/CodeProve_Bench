import Mathlib

namespace no_11348_codeexercises_17391


-- Precondition definitions
@[reducible, simp]
def find_common_elements_precond (list_1 : List Int) (list_2 : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
noncomputable def find_common_elements (list_1 : List Int) (list_2 : List Int) (h_precond : find_common_elements_precond list_1 list_2) : List Int :=
  -- !benchmark @start code
  let common_set := list_1.toFinset ∩ list_2.toFinset
  common_set.toList
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_common_element (x : Int) (list_1 list_2 : List Int) : Prop :=
  x ∈ list_1 ∧ x ∈ list_2

def all_common_elements (list_1 list_2 result : List Int) : Prop :=
  (∀ x, x ∈ result → is_common_element x list_1 list_2) ∧
  (∀ x, is_common_element x list_1 list_2 → x ∈ result)

-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond (list_1 : List Int) (list_2 : List Int) (result: List Int) (h_precond : find_common_elements_precond list_1 list_2) : Prop :=
  -- !benchmark @start postcond
  all_common_elements list_1 list_2 result
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied (list_1: List Int) (list_2: List Int) (h_precond : find_common_elements_precond list_1 list_2) :
    find_common_elements_postcond list_1 list_2 (find_common_elements list_1 list_2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_11348_codeexercises_17391