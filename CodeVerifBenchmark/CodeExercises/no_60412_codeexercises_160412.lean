import Mathlib

-- Precondition definitions
@[reducible, simp]
def calculate_budgets_precond (budgets : List Nat) (expenses : List Nat) : Prop :=
  -- !benchmark @start precond
  budgets.length = expenses.length
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def calculate_budgets (budgets : List Nat) (expenses : List Nat) (h_precond : calculate_budgets_precond (budgets) (expenses)) : List Nat :=
  -- !benchmark @start code
  let rec loop (i : Nat) (acc : List Nat) : List Nat :=
    if h : i < budgets.length then
      let budget := budgets.get! i
      let expense := expenses.get! i
      let remaining := budget - expense
      loop (i + 1) (acc ++ [remaining])
    else
      acc
  loop 0 []
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def calculate_budgets_postcond (budgets : List Nat) (expenses : List Nat) (result: List Nat) (h_precond : calculate_budgets_precond (budgets) (expenses)) : Prop :=
  -- !benchmark @start postcond
  result.length = budgets.length ∧ ∀ i, i < budgets.length → result.get! i = budgets.get! i - expenses.get! i
  -- !benchmark @end postcond


-- Proof content
theorem calculate_budgets_postcond_satisfied (budgets: List Nat) (expenses: List Nat) (h_precond : calculate_budgets_precond (budgets) (expenses)) :
    calculate_budgets_postcond (budgets) (expenses) (calculate_budgets (budgets) (expenses) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

