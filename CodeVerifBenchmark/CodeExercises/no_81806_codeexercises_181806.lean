import Mathlib

namespace no_81806_codeexercises_181806


-- Precondition definitions
@[reducible, simp]
def remove_duplicate_expenses_precond (expenses : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def remove_duplicate_expenses (expenses : List String) (h_precond : remove_duplicate_expenses_precond (expenses)) : List String :=
  -- !benchmark @start code
  expenses.dedup
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def remove_duplicate_expenses_postcond_aux (l : List String) : List String :=
  l.dedup

-- Postcondition definitions
@[reducible, simp]
def remove_duplicate_expenses_postcond (expenses : List String) (result: List String) (h_precond : remove_duplicate_expenses_precond (expenses)) : Prop :=
  -- !benchmark @start postcond
  result = remove_duplicate_expenses_postcond_aux expenses ∧
  ∀ (x : String), x ∈ result → x ∈ expenses ∧
  ∀ (i j : Nat), i < j → j < result.length → result[i]! = result[j]! → False
  -- !benchmark @end postcond


-- Proof content
theorem remove_duplicate_expenses_postcond_satisfied (expenses: List String) (h_precond : remove_duplicate_expenses_precond (expenses)) :
    remove_duplicate_expenses_postcond (expenses) (remove_duplicate_expenses (expenses) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_81806_codeexercises_181806