import Mathlib

namespace no_1149_leetcode_2303


-- Precondition auxiliary definitions
/-- Checks whether a list of tax brackets is valid according to problem constraints. -/
def isValidBracketList (brackets : List (Nat × Nat)) : Prop :=
  let bounds := brackets.map (·.1)
  let rates := brackets.map (·.2)
  brackets.length > 0 ∧
  brackets.length ≤ 100 ∧
  (∀ b ∈ bounds, b > 0 ∧ b ≤ 1000) ∧
  (∀ r ∈ rates, r ≤ 100) ∧
  List.Sorted (·≤·) bounds ∧
  List.Nodup bounds

/-- Checks that the income is within allowed limits. -/
def isValidIncome (income : Nat) : Prop := income ≤ 1000

/-- Checks that the last bracket's upper bound covers the income. -/
def coversIncome (brackets : List (Nat × Nat)) (income : Nat) : Prop :=
  match brackets.getLast? with
  | some (lastUpper, _) => lastUpper ≥ income
  | none => False

-- Precondition definitions
@[reducible, simp]
def calculateTax_precond (brackets : List (Nat × Nat)) (income : Nat) : Prop :=
  -- !benchmark @start precond
  isValidBracketList brackets ∧
  isValidIncome income ∧
  coversIncome brackets income
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function to compute the tax amount recursively. -/
def computeTax (brackets : List (Nat × Nat)) (remaining_income : Nat) (prev_upper : Nat) : Float :=
  match brackets with
  | [] => 0.0
  | (upper, percent) :: rest =>
    let taxable_in_bracket := (min remaining_income (upper - prev_upper)).toFloat
    let tax_in_bracket := taxable_in_bracket * (percent.toFloat / 100.0)
    let new_remaining := remaining_income - min remaining_income (upper - prev_upper)
    if new_remaining = 0 then
      tax_in_bracket
    else
      tax_in_bracket + computeTax rest new_remaining upper

-- Main function definitions
def calculateTax (brackets : List (Nat × Nat)) (income : Nat) (h_precond : calculateTax_precond brackets income) : Float :=
  -- !benchmark @start code
  let expected_tax := computeTax brackets income 0
  expected_tax
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Lemma to ensure correctness of min calculation. -/
lemma min_property (a b : Nat) : min a b ≤ a ∧ min a b ≤ b := by
  constructor
  · exact min_le_left a b
  · exact min_le_right a b

-- Postcondition definitions
@[reducible, simp]
def calculateTax_postcond (brackets : List (Nat × Nat)) (income : Nat) (result : Float) (h_precond : calculateTax_precond brackets income) : Prop :=
  -- !benchmark @start postcond
  let expected_tax := computeTax brackets income 0
  Float.abs (result - expected_tax) < 1e-5
  -- !benchmark @end postcond


-- Proof content
theorem calculateTax_postcond_satisfied (brackets : List (Nat × Nat)) (income : Nat) (h_precond : calculateTax_precond brackets income) :
    calculateTax_postcond brackets income (calculateTax brackets income h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1149_leetcode_2303