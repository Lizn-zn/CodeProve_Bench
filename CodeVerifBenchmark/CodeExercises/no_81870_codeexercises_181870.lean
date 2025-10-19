import Mathlib

-- Precondition definitions
@[reducible, simp]
def check_age_precond (age : Option Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this function

-- Main function definitions
def check_age (age : Option Nat) (h_precond : check_age_precond (age)) : String :=
  -- !benchmark @start code
  match age with
  | none => "Unknown"
  | some a =>
    if a < 18 then "Minor"
    else if a ≤ 65 then "Adult"
    else "Senior"
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def check_age_postcond (age : Option Nat) (result: String) (h_precond : check_age_precond (age)) : Prop :=
  -- !benchmark @start postcond
  match age with
  | none => result = "Unknown"
  | some a => 
    if a < 18 then result = "Minor"
    else if a ≤ 65 then result = "Adult"
    else result = "Senior"
  -- !benchmark @end postcond


-- Proof content
theorem check_age_postcond_satisfied (age: Option Nat) (h_precond : check_age_precond (age)) :
    check_age_postcond (age) (check_age (age) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

