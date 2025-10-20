import Mathlib

namespace no_79694_codeexercises_179694


-- Precondition definitions
@[reducible, simp]
def calculate_total_expenses_precond (expenses : List Float) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def calculate_total_expenses (expenses : List Float) (h_precond : calculate_total_expenses_precond (expenses)) : Float :=
  -- !benchmark @start code
  match expenses with
    | [] => 0
    | h::t => h + calculate_total_expenses t (by simp [calculate_total_expenses_precond])
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def calculate_total_expenses_postcond (expenses : List Float) (result: Float) (h_precond : calculate_total_expenses_precond (expenses)) : Prop :=
  -- !benchmark @start postcond
  result = expenses.foldl (· + ·) 0
  -- !benchmark @end postcond


-- Proof content
theorem calculate_total_expenses_postcond_satisfied (expenses: List Float) (h_precond : calculate_total_expenses_precond (expenses)) :
    calculate_total_expenses_postcond (expenses) (calculate_total_expenses (expenses) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_79694_codeexercises_179694