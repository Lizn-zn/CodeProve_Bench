import Mathlib

namespace no_1091_leetcode_2188


-- Precondition auxiliary definitions
/-- The time for the `x`-th successive lap for tire `(f, r)` -/
def tireTime' (f r : Nat) (x : Nat) : Nat :=
  f * r ^ (x - 1)

/-- Check if using a single tire for `k` laps is beneficial compared to changing tires -/
def isSingleTireBeneficial (tires : List (Nat × Nat)) (changeTime : Nat) (k : Nat) : Bool :=
  let maxLaps := 18 -- As per problem analysis, no tire is used for more than ~18 laps consecutively due to exponential growth
  if k > maxLaps then false else
    let minTimeUsingSingleTire := tires.foldl (fun acc (f, r) => 
      let totalTime := List.range k |>.foldl (fun sum i => sum + tireTime' f r (i+1)) 0
      min acc totalTime
    ) (2^60)
    let timeWithChange := changeTime + (tires.head!.1 * k) -- Simplified estimation
    minTimeUsingSingleTire < timeWithChange

/-- Precompute the minimum time to do exactly `k` laps using a single tire -/
def precomputeSingleTireTimes' (tires : List (Nat × Nat)) (changeTime : Nat) (maxK : Nat) : List Nat :=
  List.range (maxK + 1) |>.map fun k =>
    if k = 0 then 0 else
    let minTime := tires.foldl (fun acc (f, r) =>
      let totalTime := List.range k |>.foldl (fun sum i => sum + tireTime' f r (i+1)) 0
      min acc totalTime
    ) (2^60)
    minTime

-- Precondition definitions
@[reducible, simp]
def min_race_time_precond (tires : List (Nat × Nat)) (changeTime : Nat) (numLaps : Nat) : Prop :=
  -- !benchmark @start precond
  tires ≠ [] ∧
  ∀ (t : Nat × Nat), t ∈ tires → t.1 ≥ 1 ∧ t.2 ≥ 2 ∧ t.1 ≤ 10^5 ∧ t.2 ≤ 10^5 ∧
  changeTime ≥ 1 ∧ changeTime ≤ 10^5 ∧
  numLaps ≥ 1 ∧ numLaps ≤ 1000
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- The time for the `x`-th successive lap for tire `(f, r)` -/
def tireTime (f r : Nat) (x : Nat) : Nat :=
  f * r ^ (x - 1)

/-- Precompute the minimum time to do exactly `k` laps using a single tire -/
def precomputeSingleTireTimes (tires : List (Nat × Nat)) (changeTime : Nat) (maxK : Nat) : Array Nat :=
  let minTimes := Array.mkArray (maxK + 1) (2^60)
  let minTimes := minTimes.set! 0 0
  let minTimes := tires.foldl (fun minTimes (f, r) =>
    let totalTime := List.range (min maxK 17 + 1) |>.foldl (fun state x =>
      let (totalTime, currentMinTimes) := state
      let newTotal := totalTime + tireTime f r (x+1)
      let updatedMinTimes := if newTotal < currentMinTimes[(x+1)]! then currentMinTimes.set! (x+1) newTotal else currentMinTimes
      (newTotal, updatedMinTimes)
    ) (0, minTimes)
    minTimes
  ) minTimes
  minTimes

/-- Dynamic programming approach to compute the minimum time for `n` laps -/
def minRaceTimeDP (tires : List (Nat × Nat)) (changeTime : Nat) (numLaps : Nat) : Nat :=
  let maxConsecutive := 18
  let singleTireMinTimes := precomputeSingleTireTimes tires changeTime maxConsecutive
  let dp := Array.mkArray (numLaps + 1) (2^60)
  let dp := dp.set! 0 0
  let dp := List.range numLaps |>.foldl (fun dp_acc i =>
    let i := i + 1
    let dp_acc := if i ≤ maxConsecutive ∧ singleTireMinTimes[i]! < dp_acc[i]! then dp_acc.set! i singleTireMinTimes[i]! else dp_acc
    let dp_acc := List.range (min (i-1) maxConsecutive) |>.foldl (fun dp_inner j =>
      let j := j + 1
      let left := dp_inner[j]!
      let right := dp_inner[i - j]!
      let total := left + changeTime + right
      if total < dp_inner[i]! then dp_inner.set! i total else dp_inner
    ) dp_acc
    dp_acc
  ) dp
  dp[numLaps]!


-- Main function definitions
def min_race_time (tires : List (Nat × Nat)) (changeTime : Nat) (numLaps : Nat) (h_precond : min_race_time_precond (tires) (changeTime) (numLaps)) : Nat :=
  -- !benchmark @start code
  minRaceTimeDP tires changeTime numLaps
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Dynamic programming approach to compute the minimum time for `n` laps -/
def minRaceTimeDP' (tires : List (Nat × Nat)) (changeTime : Nat) (numLaps : Nat) : Nat :=
  let maxConsecutive := 18
  let singleTireMinTimes := precomputeSingleTireTimes' tires changeTime maxConsecutive
  -- Build dp array iteratively to avoid forward references
  let dpList := List.range (numLaps + 1) |>.foldl (fun dpAcc n =>
    if n = 0 then
      [0] ++ dpAcc.tail!
    else
      let minFromSingleTire := if n ≤ maxConsecutive then singleTireMinTimes[n]! else 2^60
      let minFromSplit := (List.range (min n maxConsecutive)).foldl (fun acc k =>
        if k = 0 then acc else
        let left := dpAcc[k]!
        let right := dpAcc[n - k]!
        let total := left + changeTime + right
        min acc total
      ) minFromSingleTire
      dpAcc ++ [minFromSplit]
    ) [0]
  dpList.getLast!

-- Postcondition definitions
@[reducible, simp]
def min_race_time_postcond (tires : List (Nat × Nat)) (changeTime : Nat) (numLaps : Nat) (result: Nat) (h_precond : min_race_time_precond (tires) (changeTime) (numLaps)) : Prop :=
  -- !benchmark @start postcond
  result = minRaceTimeDP' tires changeTime numLaps
  -- !benchmark @end postcond


-- Proof content
theorem min_race_time_postcond_satisfied (tires: List (Nat × Nat)) (changeTime: Nat) (numLaps: Nat) (h_precond : min_race_time_precond (tires) (changeTime) (numLaps)) :
    min_race_time_postcond (tires) (changeTime) (numLaps) (min_race_time (tires) (changeTime) (numLaps) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1091_leetcode_2188