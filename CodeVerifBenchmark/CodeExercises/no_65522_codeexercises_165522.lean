import Mathlib

namespace no_65522_codeexercises_165522


-- Precondition definitions
@[reducible, simp]
def calculate_balance_precond (account_balance : Float) (deductions : List Float) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def total_deductions : List Float → Float :=
  List.foldl (λ acc x => acc + x) 0.0

-- Main function definitions
def calculate_balance (account_balance : Float) (deductions : List Float) (h_precond : calculate_balance_precond (account_balance) (deductions)) : Float :=
  -- !benchmark @start code
  let rec helper (balance : Float) (deductions : List Float) : Float :=
    match deductions with
    | [] => balance
    | d :: ds => helper (balance - d) ds
  helper account_balance deductions
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def total_deductions_post : List Float → Float :=
  List.foldl (λ acc x => acc + x) 0.0

-- Postcondition definitions
@[reducible, simp]
def calculate_balance_postcond (account_balance : Float) (deductions : List Float) (result: Float) (h_precond : calculate_balance_precond (account_balance) (deductions)) : Prop :=
  -- !benchmark @start postcond
  result = account_balance - total_deductions_post deductions
  -- !benchmark @end postcond


-- Proof content
theorem calculate_balance_postcond_satisfied (account_balance: Float) (deductions: List Float) (h_precond : calculate_balance_precond (account_balance) (deductions)) :
    calculate_balance_postcond (account_balance) (deductions) (calculate_balance (account_balance) (deductions) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_65522_codeexercises_165522