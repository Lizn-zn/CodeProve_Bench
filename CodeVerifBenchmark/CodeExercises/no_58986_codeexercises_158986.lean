import Mathlib

namespace no_58986_codeexercises_158986


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def check_temperature_precond (temperature_list : List Float) (threshold : Float) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Define epsilon for floating-point comparisons
def epsilon : Float := 0.000001

-- Helper function to check if a temperature is above threshold considering epsilon
def is_above_threshold (temp : Float) (threshold : Float) : Bool :=
  temp > threshold + epsilon

-- Main function definitions
def check_temperature : (temperature_list : List Float) → (threshold : Float) → (h_precond : check_temperature_precond temperature_list threshold) → Bool
  | [], _, _ => false
  | h::t, threshold, h_precond => 
    if is_above_threshold h threshold then
      true
    else
      check_temperature t threshold (by simp [check_temperature_precond])


-- Postcondition auxiliary definitions
-- No additional auxiliary definitions needed beyond what's already defined

-- Postcondition definitions
@[reducible, simp]
def check_temperature_postcond (temperature_list : List Float) (threshold : Float) (result: Bool) (h_precond : check_temperature_precond (temperature_list) (threshold)) : Prop :=
  -- !benchmark @start postcond
  result = (∃ t ∈ temperature_list, is_above_threshold t threshold)
  -- !benchmark @end postcond


-- Proof content
theorem check_temperature_postcond_satisfied (temperature_list: List Float) (threshold: Float) (h_precond : check_temperature_precond (temperature_list) (threshold)) :
    check_temperature_postcond (temperature_list) (threshold) (check_temperature (temperature_list) (threshold) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_58986_codeexercises_158986