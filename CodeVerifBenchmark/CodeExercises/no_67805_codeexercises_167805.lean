import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_common_elements_precond (list1 : List α) (list2 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_common_elements [BEq α] (list1 : List α) (list2 : List α) (h_precond : find_common_elements_precond (list1) (list2)) : List α :=
  -- !benchmark @start code
  -- Filter elements from list1 that are also in list2
  list1.filter (λ x => list2.contains x)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_common_element (x : α) (list1 list2 : List α) : Prop :=
  x ∈ list1 ∧ x ∈ list2

def all_common_elements (result : List α) (list1 list2 : List α) : Prop :=
  ∀ x, x ∈ result ↔ is_common_element x list1 list2

-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond (list1 : List α) (list2 : List α) (result: List α) (h_precond : find_common_elements_precond (list1) (list2)) : Prop :=
  -- !benchmark @start postcond
  all_common_elements result list1 list2
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied [BEq α] (list1: List α) (list2: List α) (h_precond : find_common_elements_precond (list1) (list2)) :
    find_common_elements_postcond (list1) (list2) (find_common_elements (list1) (list2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof