import Mathlib

namespace no_98133_codeexercises_198133


-- Precondition definitions
@[reducible, simp]
def check_if_empty_list_precond (list_1 : List α) (list_2 : List β) (list_3 : List γ) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple function

-- Main function definitions
def check_if_empty_list (list_1 : List α) (list_2 : List β) (list_3 : List γ) (h_precond : check_if_empty_list_precond (list_1) (list_2) (list_3)) : Bool :=
  -- !benchmark @start code
  list_1.isEmpty && list_2.isEmpty && list_3.isEmpty
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def check_if_empty_list_postcond (list_1 : List α) (list_2 : List β) (list_3 : List γ) (result: Bool) (h_precond : check_if_empty_list_precond (list_1) (list_2) (list_3)) : Prop :=
  -- !benchmark @start postcond
  result = (list_1.isEmpty ∧ list_2.isEmpty ∧ list_3.isEmpty)
  -- !benchmark @end postcond


-- Proof content
theorem check_if_empty_list_postcond_satisfied (list_1: List α) (list_2: List β) (list_3: List γ) (h_precond : check_if_empty_list_precond (list_1) (list_2) (list_3)) :
    check_if_empty_list_postcond (list_1) (list_2) (list_3) (check_if_empty_list (list_1) (list_2) (list_3) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_98133_codeexercises_198133