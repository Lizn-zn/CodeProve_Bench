import Mathlib

namespace no_73331_codeexercises_173331


-- Precondition definitions
@[reducible, simp]
def find_common_elements_precond (lst1 : List α) (lst2 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple function

-- Main function definitions
def find_common_elements [BEq α] (lst1 : List α) (lst2 : List α) (h_precond : find_common_elements_precond (lst1) (lst2)) : List α :=
  -- !benchmark @start code
  let filtered := lst1.filter (λ x => lst2.contains x)
  filtered
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def CommonElements (lst1 lst2 result : List α) : Prop :=
  ∀ x, x ∈ result ↔ x ∈ lst1 ∧ x ∈ lst2

-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond (lst1 : List α) (lst2 : List α) (result: List α) (h_precond : find_common_elements_precond (lst1) (lst2)) : Prop :=
  -- !benchmark @start postcond
  CommonElements lst1 lst2 result
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied [BEq α] (lst1: List α) (lst2: List α) (h_precond : find_common_elements_precond (lst1) (lst2)) :
    find_common_elements_postcond (lst1) (lst2) (find_common_elements (lst1) (lst2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_73331_codeexercises_173331