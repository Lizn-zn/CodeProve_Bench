import Mathlib

-- Precondition definitions
@[reducible, simp]
def convertSecondsToTime_precond (s : Nat) : Prop :=
  -- !benchmark @start precond
  -- The input seconds must be within the valid range [0, 86400]
    0 ≤ s ∧ s ≤ 86400
  -- !benchmark @end precond


-- Main function definitions
def convertSecondsToTime (s : Nat) (h_precond : convertSecondsToTime_precond (s)) : Nat × Nat × Nat :=
  -- !benchmark @start code
  let h := s / 3600
    let remaining_after_hours := s - 3600 * h
    let m := remaining_after_hours / 60
    let s_out := remaining_after_hours - 60 * m
    (h, m, s_out)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def convertSecondsToTime_postcond (s : Nat) (result: Nat × Nat × Nat) (h_precond : convertSecondsToTime_precond (s)) : Prop :=
  -- !benchmark @start postcond
  -- The result is a tuple (h, m, s) where:
    -- 1. h is the number of hours (0 to 24)
    -- 2. m is the number of minutes (0 to 59)
    -- 3. s_out is the number of seconds (0 to 59)
    -- 4. The total seconds equals h*3600 + m*60 + s_out
    let (h, m, s_out) := result
    -- Minutes and seconds must be in valid ranges
    m < 60 ∧ s_out < 60 ∧
    -- The conversion must be correct
    s = h * 3600 + m * 60 + s_out ∧
    -- Hours should be in valid range (since s ≤ 86400, h ≤ 24)
    h ≤ 24
  -- !benchmark @end postcond


-- Proof content
theorem convertSecondsToTime_postcond_satisfied (s: Nat) (h_precond : convertSecondsToTime_precond (s)) :
    convertSecondsToTime_postcond (s) (convertSecondsToTime (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

