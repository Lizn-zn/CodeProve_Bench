import Mathlib

namespace no_1901_p02846


-- Precondition definitions
@[reducible, simp]
def countMeetings_precond (T1 : Nat) (T2 : Nat) (A1 : Nat) (A2 : Nat) (B1 : Nat) (B2 : Nat) : Prop :=
  -- !benchmark @start precond
  -- T1, T2 must be positive (within bounds)
  1 ≤ T1 ∧ T1 ≤ 100000 ∧
  1 ≤ T2 ∧ T2 ≤ 100000 ∧
  -- A1, A2, B1, B2 must be positive (within bounds)
  1 ≤ A1 ∧ A1 ≤ 10^10 ∧
  1 ≤ A2 ∧ A2 ≤ 10^10 ∧
  1 ≤ B1 ∧ B1 ≤ 10^10 ∧
  1 ≤ B2 ∧ B2 ≤ 10^10 ∧
  -- A1 ≠ B1 and A2 ≠ B2
  A1 ≠ B1 ∧ A2 ≠ B2
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def countMeetings (T1 : Nat) (T2 : Nat) (A1 : Nat) (A2 : Nat) (B1 : Nat) (B2 : Nat) (h_precond : countMeetings_precond (T1) (T2) (A1) (A2) (B1) (B2)) : Option Nat :=
  -- !benchmark @start code
  let c0 := (max A1 B1 - min A1 B1) * T1
  let c1 := (max A2 B2 - min A2 B2) * T2
  if (A1 > B1 && A2 > B2) || (A1 < B1 && A2 < B2) then
    some 0
  else if c0 == c1 then
    none
  else if c0 > c1 then
    some 0
  else
    let sa := c1 - c0
    let tmp := if c1 % sa == 0 then 0 else 1
    some ((c1 - 1) / (c1 - c0) * 2 - tmp)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to compute position at time t
def position (speed1 speed2 : Nat) (time1 time2 : Nat) (t : Nat) : Nat :=
  let fullCycles := t / (time1 + time2)
  let remainder := t % (time1 + time2)
  let distPerCycle := speed1 * time1 + speed2 * time2
  let distInRemainder := if remainder ≤ time1 then speed1 * remainder else speed1 * time1 + speed2 * (remainder - time1)
  fullCycles * distPerCycle + distInRemainder

-- Helper function to check if they meet at time t (t > 0)
def meetAtTime (T1 T2 A1 A2 B1 B2 : Nat) (t : Nat) : Prop :=
  t > 0 ∧ position A1 A2 T1 T2 t = position B1 B2 T1 T2 t

-- Helper function to count meetings up to time T
def countMeetingsUpTo (T1 T2 A1 A2 B1 B2 : Nat) (maxTime : Nat) : Nat :=
  (List.range maxTime).filter (fun t => t > 0 ∧ position A1 A2 T1 T2 t = position B1 B2 T1 T2 t) |>.length

-- Postcondition definitions
@[reducible, simp]
def countMeetings_postcond (T1 : Nat) (T2 : Nat) (A1 : Nat) (A2 : Nat) (B1 : Nat) (B2 : Nat) (result: Option Nat) (h_precond : countMeetings_precond (T1) (T2) (A1) (A2) (B1) (B2)) : Prop :=
  -- !benchmark @start postcond
  let c0 := (max A1 B1 - min A1 B1) * T1
  let c1 := (max A2 B2 - min A2 B2) * T2
  -- If they meet infinitely many times
  if c0 = c1 then
    result = none
  -- If one is always ahead or always behind in both phases
  else if (A1 > B1 ∧ A2 > B2) ∨ (A1 < B1 ∧ A2 < B2) then
    result = some 0
  -- If the gap after one full cycle favors the initially slower runner
  else if c0 > c1 then
    result = some 0
  else
    -- They meet a finite number of times
    -- The number of meetings is determined by when the position differences align
    ∃ n : Nat, result = some n ∧
    -- n is the actual count of times they meet (excluding the start)
    (∀ t : Nat, meetAtTime T1 T2 A1 A2 B1 B2 t → 
      ∃ k : Nat, k < n ∧ t ≤ (c1 - 1) / (c1 - c0) * (T1 + T2)) ∧
    -- The formula from the informal code
    (let sa := c1 - c0
     let tmp := if c1 % sa = 0 then 0 else 1
     n = (c1 - 1) / (c1 - c0) * 2 - tmp)
  -- !benchmark @end postcond


-- Proof content
theorem countMeetings_postcond_satisfied (T1: Nat) (T2: Nat) (A1: Nat) (A2: Nat) (B1: Nat) (B2: Nat) (h_precond : countMeetings_precond (T1) (T2) (A1) (A2) (B1) (B2)) :
    countMeetings_postcond (T1) (T2) (A1) (A2) (B1) (B2) (countMeetings (T1) (T2) (A1) (A2) (B1) (B2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1901_p02846