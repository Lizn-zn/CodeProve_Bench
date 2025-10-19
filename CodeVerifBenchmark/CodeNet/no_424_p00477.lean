import Mathlib

-- Precondition definitions
@[reducible, simp]
def calculateTotalTime_precond (time1 : Nat) (time2 : Nat) (time3 : Nat) (time4 : Nat) : Prop :=
  -- !benchmark @start precond
  -- Each time is a positive natural number
  -- The total time is between 60 and 3599 seconds (1 minute 0 seconds to 59 minutes 59 seconds)
  let totalSeconds := time1 + time2 + time3 + time4
  time1 > 0 ∧ time2 > 0 ∧ time3 > 0 ∧ time4 > 0 ∧
  totalSeconds ≥ 60 ∧ totalSeconds ≤ 3599
  -- !benchmark @end precond


-- Main function definitions
def calculateTotalTime (time1 : Nat) (time2 : Nat) (time3 : Nat) (time4 : Nat) (h_precond : calculateTotalTime_precond (time1) (time2) (time3) (time4)) : Nat × Nat :=
  -- !benchmark @start code
  let totalSeconds := time1 + time2 + time3 + time4
    let minutes := totalSeconds / 60
    let seconds := totalSeconds % 60
    (minutes, seconds)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def calculateTotalTime_postcond (time1 : Nat) (time2 : Nat) (time3 : Nat) (time4 : Nat) (result: Nat × Nat) (h_precond : calculateTotalTime_precond (time1) (time2) (time3) (time4)) : Prop :=
  -- !benchmark @start postcond
  -- The result is a pair (minutes, seconds) where:
  -- - minutes is the total minutes (1 to 59)
  -- - seconds is the remaining seconds (0 to 59)
  -- - The total time in seconds equals minutes * 60 + seconds
  let totalSeconds := time1 + time2 + time3 + time4
  let (minutes, seconds) := result
  totalSeconds = minutes * 60 + seconds ∧
  minutes ≥ 1 ∧ minutes ≤ 59 ∧
  seconds ≥ 0 ∧ seconds ≤ 59
  -- !benchmark @end postcond


-- Proof content
theorem calculateTotalTime_postcond_satisfied (time1: Nat) (time2: Nat) (time3: Nat) (time4: Nat) (h_precond : calculateTotalTime_precond (time1) (time2) (time3) (time4)) :
    calculateTotalTime_postcond (time1) (time2) (time3) (time4) (calculateTotalTime (time1) (time2) (time3) (time4) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

