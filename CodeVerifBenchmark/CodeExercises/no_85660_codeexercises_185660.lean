import Mathlib

namespace no_85660_codeexercises_185660


-- Precondition definitions
@[reducible, simp]
def find_not_in_not_equal_precond (lst1 : List α) (lst2 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def not_in_list_code (x : α) (lst : List α) : Prop := ∀ y ∈ lst, x ≠ y

-- Main function definitions
def find_not_in_not_equal [DecidableEq α] (lst1 : List α) (lst2 : List α) (h_precond : find_not_in_not_equal_precond (lst1) (lst2)) : List α :=
  -- !benchmark @start code
  lst1.filter (λ x => ¬ lst2.contains x)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def not_in_list_post (x : α) (lst : List α) : Prop := ∀ y ∈ lst, x ≠ y

-- Postcondition definitions
@[reducible, simp]
def find_not_in_not_equal_postcond (lst1 : List α) (lst2 : List α) (result: List α) (h_precond : find_not_in_not_equal_precond (lst1) (lst2)) : Prop :=
  -- !benchmark @start postcond
  ∀ x, x ∈ result ↔ x ∈ lst1 ∧ not_in_list_post x lst2
  -- !benchmark @end postcond


-- Proof content
theorem find_not_in_not_equal_postcond_satisfied [DecidableEq α] (lst1: List α) (lst2: List α) (h_precond : find_not_in_not_equal_precond (lst1) (lst2)) :
    find_not_in_not_equal_postcond (lst1) (lst2) (find_not_in_not_equal (lst1) (lst2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_85660_codeexercises_185660