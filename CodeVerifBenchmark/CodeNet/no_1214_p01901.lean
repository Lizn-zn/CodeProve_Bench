import Mathlib

namespace no_1214_p01901


-- Precondition definitions
@[reducible, simp]
def maxSuntanProtection_precond (T : Nat) (N : Nat) (concerts : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  T ≥ 1 ∧ N ≥ 1 ∧ concerts.length = N ∧
    -- Each concert has valid start and end times
    (∀ c ∈ concerts, c.1 < c.2) ∧
    -- Concerts are non-overlapping and ordered
    (∀ i : Fin (concerts.length - 1), concerts[i.val]!.2 ≤ concerts[i.val + 1]!.1)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to calculate coverage for a given application time
def calculateCoverage (concerts : List (Nat × Nat)) (T : Nat) (applyTime : Nat) : Nat :=
  let endTime := applyTime + T
  concerts.foldl (fun acc concert =>
    let start := concert.1
    let endConcert := concert.2
    if endTime ≤ start || applyTime ≥ endConcert then
      acc
    else
      let overlapStart := max applyTime start
      let overlapEnd := min endTime endConcert
      acc + (overlapEnd - overlapStart)
  ) 0

-- Helper function to find the maximum coverage across all possible application times
def findMaxCoverage (concerts : List (Nat × Nat)) (T : Nat) : Nat :=
  let applicationTimes := 0 :: concerts.map (fun c => c.1)
  applicationTimes.foldl (fun maxCov applyTime =>
    max maxCov (calculateCoverage concerts T applyTime)
  ) 0

-- Main function definitions
def maxSuntanProtection (T : Nat) (N : Nat) (concerts : List (Nat × Nat)) (h_precond : maxSuntanProtection_precond (T) (N) (concerts)) : Nat :=
  -- !benchmark @start code
  findMaxCoverage concerts T
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Calculate the total outdoor time covered by sunscreen when applied at time `applyTime`
def coverageFromTime (concerts : List (Nat × Nat)) (T : Nat) (applyTime : Nat) : Nat :=
  let endTime := applyTime + T
  concerts.foldl (fun acc concert =>
    let start := concert.1
    let endConcert := concert.2
    -- Calculate overlap between [applyTime, endTime) and [start, endConcert)
    if endTime ≤ start || applyTime ≥ endConcert then
      acc  -- No overlap
    else
      let overlapStart := max applyTime start
      let overlapEnd := min endTime endConcert
      acc + (overlapEnd - overlapStart)
  ) 0

-- Get all possible application times (start of each concert)
def getPossibleApplicationTimes (concerts : List (Nat × Nat)) : List Nat :=
  concerts.map (fun c => c.1)

-- Postcondition definitions
@[reducible, simp]
def maxSuntanProtection_postcond (T : Nat) (N : Nat) (concerts : List (Nat × Nat)) (result: Nat) (h_precond : maxSuntanProtection_precond (T) (N) (concerts)) : Prop :=
  -- !benchmark @start postcond
  -- The result is at most T (the duration of sunscreen protection)
  result ≤ T ∧
    -- The result is at most the total outdoor time
    result ≤ (concerts.foldl (fun acc c => acc + (c.2 - c.1)) 0) ∧
    -- The result is the maximum coverage achievable by applying sunscreen at any valid time
    (∃ applyTime : Nat, 
      -- We can apply at the start of any concert or at time 0
      (applyTime = 0 ∨ applyTime ∈ getPossibleApplicationTimes concerts) ∧
      result = coverageFromTime concerts T applyTime) ∧
    -- No other application time gives better coverage
    (∀ applyTime : Nat, 
      (applyTime = 0 ∨ applyTime ∈ getPossibleApplicationTimes concerts) →
      coverageFromTime concerts T applyTime ≤ result)
  -- !benchmark @end postcond


-- Proof content
theorem maxSuntanProtection_postcond_satisfied (T: Nat) (N: Nat) (concerts: List (Nat × Nat)) (h_precond : maxSuntanProtection_precond (T) (N) (concerts)) :
    maxSuntanProtection_postcond (T) (N) (concerts) (maxSuntanProtection (T) (N) (concerts) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1214_p01901