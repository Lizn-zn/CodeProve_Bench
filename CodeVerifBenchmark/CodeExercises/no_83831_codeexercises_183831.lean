import Mathlib

-- Precondition definitions
@[reducible, simp]
def calculate_total_salary_precond (salaries_list : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def calculate_total_salary (salaries_list : List Nat) (h_precond : calculate_total_salary_precond (salaries_list)) : Nat :=
  -- !benchmark @start code
  match salaries_list with
    | [] => 0
    | hd :: tl => hd + calculate_total_salary tl h_precond
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def calculate_total_salary_postcond (salaries_list : List Nat) (result: Nat) (h_precond : calculate_total_salary_precond (salaries_list)) : Prop :=
  -- !benchmark @start postcond
  result = salaries_list.foldl (· + ·) 0
  -- !benchmark @end postcond


-- Proof content
theorem calculate_total_salary_postcond_satisfied (salaries_list: List Nat) (h_precond : calculate_total_salary_precond (salaries_list)) :
    calculate_total_salary_postcond (salaries_list) (calculate_total_salary (salaries_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

