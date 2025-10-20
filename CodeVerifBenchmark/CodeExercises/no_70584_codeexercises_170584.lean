import Mathlib

namespace no_70584_codeexercises_170584


-- Precondition definitions
@[reducible, simp]
def calculate_workout_intensity_precond (age : Nat) (injury : Bool) (experience : String) : Prop :=
  -- !benchmark @start precond
  age ≥ 0 ∧ (experience = "beginner" ∨ experience = "advanced")
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No additional auxiliary definitions needed

-- Main function definitions
def calculate_workout_intensity (age : Nat) (injury : Bool) (experience : String) (h_precond : calculate_workout_intensity_precond (age) (injury) (experience)) : String :=
  -- !benchmark @start code
  if injury then
    "low"
  else if age > 60 then
    "low"
  else if experience = "beginner" then
    "medium"
  else
    "high"
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_valid_intensity_level (level : String) : Prop :=
  level = "low" ∨ level = "medium" ∨ level = "high"

def determine_intensity (age : Nat) (injury : Bool) (experience : String) : String :=
  if injury then
    "low"
  else if age > 60 then
    "low"
  else if experience = "beginner" then
    "medium"
  else
    "high"

-- Postcondition definitions
@[reducible, simp]
def calculate_workout_intensity_postcond (age : Nat) (injury : Bool) (experience : String) (result: String) (h_precond : calculate_workout_intensity_precond (age) (injury) (experience)) : Prop :=
  -- !benchmark @start postcond
  is_valid_intensity_level result ∧ result = determine_intensity age injury experience
  -- !benchmark @end postcond


-- Proof content
theorem calculate_workout_intensity_postcond_satisfied (age: Nat) (injury: Bool) (experience: String) (h_precond : calculate_workout_intensity_precond (age) (injury) (experience)) :
    calculate_workout_intensity_postcond (age) (injury) (experience) (calculate_workout_intensity (age) (injury) (experience) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_70584_codeexercises_170584