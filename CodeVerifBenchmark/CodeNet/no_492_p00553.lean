import Mathlib

-- Precondition definitions
@[reducible, simp]
def calculateMicrowaveTime_precond (a : Int) (b : Int) (c : Int) (d : Int) (e : Int) : Prop :=
  -- !benchmark @start precond
  -- Initial temperature A is between -100 and 100
    -100 ≤ a ∧ a ≤ 100 ∧
    -- Target temperature B is between 1 and 100
    1 ≤ b ∧ b ≤ 100 ∧
    -- A ≠ 0 and A < B
    a ≠ 0 ∧ a < b ∧
    -- Heating times C, D, E are all between 1 and 100
    1 ≤ c ∧ c ≤ 100 ∧
    1 ≤ d ∧ d ≤ 100 ∧
    1 ≤ e ∧ e ≤ 100
  -- !benchmark @end precond


-- Main function definitions
def calculateMicrowaveTime (a : Int) (b : Int) (c : Int) (d : Int) (e : Int) (h_precond : calculateMicrowaveTime_precond (a) (b) (c) (d) (e)) : Int :=
  -- !benchmark @start code
  if a < 0 then
      (-a) * c + d + b * e
    else
      (b - a) * e
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def calculateMicrowaveTime_postcond (a : Int) (b : Int) (c : Int) (d : Int) (e : Int) (result: Int) (h_precond : calculateMicrowaveTime_precond (a) (b) (c) (d) (e)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the total time to heat the meat from A°C to B°C
    -- Case 1: If the meat starts frozen (A < 0)
    -- Time = (heating from A to 0) + (defrosting at 0) + (heating from 0 to B)
    -- Time = (-A) * C + D + B * E
    (a < 0 → result = (-a) * c + d + b * e) ∧
    -- Case 2: If the meat starts not frozen (A > 0)
    -- Time = (heating from A to B)
    -- Time = (B - A) * E
    (a > 0 → result = (b - a) * e)
  -- !benchmark @end postcond


-- Proof content
theorem calculateMicrowaveTime_postcond_satisfied (a: Int) (b: Int) (c: Int) (d: Int) (e: Int) (h_precond : calculateMicrowaveTime_precond (a) (b) (c) (d) (e)) :
    calculateMicrowaveTime_postcond (a) (b) (c) (d) (e) (calculateMicrowaveTime (a) (b) (c) (d) (e) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

