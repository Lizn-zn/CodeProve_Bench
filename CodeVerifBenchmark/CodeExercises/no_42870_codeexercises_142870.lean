import Mathlib

namespace no_42870_codeexercises_142870


-- Precondition definitions
@[reducible, simp]
def check_distance_precond (age : Nat) (endurance : Nat) (speed : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed for this implementation

-- Main function definitions
def check_distance (age : Nat) (endurance : Nat) (speed : Nat) (h_precond : check_distance_precond (age) (endurance) (speed)) : Bool :=
  -- !benchmark @start code
  if age < 18 then
    speed ≥ 8 ∧ endurance ≥ 5
  else if age < 40 then
    (speed ≥ 7 ∧ endurance ≥ 6) ∨ (speed ≥ 8 ∧ endurance ≥ 4)
  else
    (speed ≥ 6 ∧ endurance ≥ 8) ∨ (speed ≥ 7 ∧ endurance ≥ 5)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
inductive RaceCategory : Type
  | short : RaceCategory
  | medium : RaceCategory
  | long : RaceCategory
  | marathon : RaceCategory
  | ineligible : RaceCategory

def categorize_athlete (age : Nat) (endurance : Nat) (speed : Nat) : RaceCategory :=
  if age < 18 then
    if speed ≥ 8 ∧ endurance ≥ 5 then RaceCategory.short
    else RaceCategory.ineligible
  else if age < 40 then
    if speed ≥ 7 ∧ endurance ≥ 6 then RaceCategory.medium
    else if speed ≥ 8 ∧ endurance ≥ 4 then RaceCategory.short
    else RaceCategory.ineligible
  else
    if speed ≥ 6 ∧ endurance ≥ 8 then RaceCategory.long
    else if speed ≥ 7 ∧ endurance ≥ 5 then RaceCategory.medium
    else RaceCategory.ineligible

-- Postcondition definitions
@[reducible, simp]
def check_distance_postcond (age : Nat) (endurance : Nat) (speed : Nat) (result: Bool) (h_precond : check_distance_precond (age) (endurance) (speed)) : Prop :=
  -- !benchmark @start postcond
  result = (categorize_athlete age endurance speed ≠ RaceCategory.ineligible)
  -- !benchmark @end postcond


-- Proof content
theorem check_distance_postcond_satisfied (age: Nat) (endurance: Nat) (speed: Nat) (h_precond : check_distance_precond (age) (endurance) (speed)) :
    check_distance_postcond (age) (endurance) (speed) (check_distance (age) (endurance) (speed) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_42870_codeexercises_142870