import Mathlib

-- Precondition definitions
@[reducible, simp]
def check_electrical_issues_precond (reading : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def check_electrical_issues (reading : List Nat) (h_precond : check_electrical_issues_precond (reading)) : List Nat :=
  -- !benchmark @start code
  reading.filter (λ v => v < 110 ∨ v > 130)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_problematic_voltage (v : Nat) : Bool :=
  v < 110 ∨ v > 130

-- Postcondition definitions
@[reducible, simp]
def check_electrical_issues_postcond (reading : List Nat) (result: List Nat) (h_precond : check_electrical_issues_precond (reading)) : Prop :=
  -- !benchmark @start postcond
  result = reading.filter is_problematic_voltage
  -- !benchmark @end postcond


-- Proof content
theorem check_electrical_issues_postcond_satisfied (reading: List Nat) (h_precond : check_electrical_issues_precond (reading)) :
    check_electrical_issues_postcond (reading) (check_electrical_issues (reading) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

