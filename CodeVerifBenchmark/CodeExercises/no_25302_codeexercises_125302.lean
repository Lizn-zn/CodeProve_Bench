import Mathlib

namespace no_25302_codeexercises_125302


-- Precondition definitions
@[reducible, simp]
def find_common_elements_precond (chef_dish1 : List α) (chef_dish2 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def all_common_elements [BEq α] (l1 l2 : List α) : List α :=
  l1.filter (λ x => l2.contains x)

-- Main function definitions
def find_common_elements [BEq α] (chef_dish1 : List α) (chef_dish2 : List α) (h_precond : find_common_elements_precond (chef_dish1) (chef_dish2)) : List α :=
  -- !benchmark @start code
  all_common_elements chef_dish1 chef_dish2
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_common_element (x : α) (l1 l2 : List α) : Prop :=
  x ∈ l1 ∧ x ∈ l2

-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond (chef_dish1 : List α) (chef_dish2 : List α) (result: List α) (h_precond : find_common_elements_precond (chef_dish1) (chef_dish2)) : Prop :=
  -- !benchmark @start postcond
  ∀ x, x ∈ result ↔ is_common_element x chef_dish1 chef_dish2
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied [BEq α] (chef_dish1: List α) (chef_dish2: List α) (h_precond : find_common_elements_precond (chef_dish1) (chef_dish2)) :
    find_common_elements_postcond (chef_dish1) (chef_dish2) (find_common_elements (chef_dish1) (chef_dish2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_25302_codeexercises_125302