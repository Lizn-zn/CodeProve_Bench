import Mathlib

namespace no_40801_codeexercises_140801


-- Precondition definitions
@[reducible, simp]
def calculate_eligibility_precond (income : Float) (assets : Float) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def calculate_eligibility (income : Float) (assets : Float) (h_precond : calculate_eligibility_precond (income) (assets)) : String :=
  -- !benchmark @start code
  if income ≤ 500.0 ∧ assets < 1000.0 then
    "Eligible"
  else
    "Not Eligible"
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def calculate_eligibility_postcond (income : Float) (assets : Float) (result: String) (h_precond : calculate_eligibility_precond (income) (assets)) : Prop :=
  -- !benchmark @start postcond
  (result = "Eligible" ∧ income ≤ 500.0 ∧ assets < 1000.0) ∨ (result = "Not Eligible" ∧ ¬(income ≤ 500.0 ∧ assets < 1000.0))
  -- !benchmark @end postcond


-- Proof content
theorem calculate_eligibility_postcond_satisfied (income: Float) (assets: Float) (h_precond : calculate_eligibility_precond (income) (assets)) :
    calculate_eligibility_postcond (income) (assets) (calculate_eligibility (income) (assets) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_40801_codeexercises_140801