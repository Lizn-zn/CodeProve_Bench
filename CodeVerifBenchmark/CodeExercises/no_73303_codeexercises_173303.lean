import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def calculate_pace_precond (distance : Float) (time : Float) (pace : Option Float) : Prop :=
  -- !benchmark @start precond
  distance > 0 ∧ time > 0 ∧ (pace.isSome → pace.get! > 0)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def calculate_pace (distance : Float) (time : Float) (pace : Option Float) (h_precond : calculate_pace_precond (distance) (time) (pace)) : Float :=
  -- !benchmark @start code
  match pace with
  | none => time / distance
  | some p => (time + p * distance) / (2 * distance)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- No auxiliary definitions needed for postcondition

-- Postcondition definitions
@[reducible, simp]
def calculate_pace_postcond (distance : Float) (time : Float) (pace : Option Float) (result: Float) (h_precond : calculate_pace_precond (distance) (time) (pace)) : Prop :=
  -- !benchmark @start postcond
  match pace with
  | none => result = time / distance
  | some p => result = (time + p * distance) / (2 * distance)
  -- !benchmark @end postcond


-- Proof content
theorem calculate_pace_postcond_satisfied (distance: Float) (time: Float) (pace: Option Float) (h_precond : calculate_pace_precond (distance) (time) (pace)) :
    calculate_pace_postcond (distance) (time) (pace) (calculate_pace (distance) (time) (pace) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

