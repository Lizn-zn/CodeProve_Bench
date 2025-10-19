import Mathlib

-- Precondition auxiliary definitions
/-- The cost for a worker with base time `w` to reduce the mountain height by `x` units. -/
def workCost (w : Nat) (x : Nat) : Nat :=
  if x = 0 then 0 else
  w * x * (x + 1) / 2

/-- Check if a given time `t` is sufficient for all workers together to reduce the mountain to height 0. -/
def isSufficientTimeProp (mountainHeight : Nat) (workerTimes : List Nat) (t : Nat) : Prop :=
  let totalReduction := workerTimes.foldl (fun acc w =>
    -- Maximum height this worker can reduce within time t
    let maxH := (List.range (mountainHeight + 1)).filter (fun h => workCost w h ≤ t) |>.getLastD 0
    acc + maxH
  ) 0
  totalReduction ≥ mountainHeight

-- Precondition definitions
@[reducible, simp]
def minTimeToReduceMountain_precond (mountainHeight : Nat) (workerTimes : List Nat) : Prop :=
  -- !benchmark @start precond
  mountainHeight > 0 ∧ workerTimes ≠ [] ∧ ∀ w ∈ workerTimes, w > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Find the maximum height a worker with base time `w` can reduce within time `t`. -/
def maxReductionForWorker (w : Nat) (t : Nat) : Nat :=
  if w = 0 then
    0
  else
    let searchMax := (t / w + 1) * 2  -- Upper bound estimate
    let rec binarySearch (low : Nat) (high : Nat) : Nat :=
      if low ≥ high then low - 1 else
      let mid := (low + high) / 2
      let cost := workCost w mid
      if cost ≤ t then
        binarySearch (mid + 1) high
      else
        binarySearch low mid
    binarySearch 0 (searchMax + 1)

/-- Check if a given time `t` is sufficient for all workers together to reduce the mountain to height 0. -/
def isSufficientTime (mountainHeight : Nat) (workerTimes : List Nat) (t : Nat) : Bool :=
  let totalReduction := workerTimes.foldl (fun acc w =>
    acc + maxReductionForWorker w t
  ) 0
  totalReduction ≥ mountainHeight

-- Main function definitions
def minTimeToReduceMountain (mountainHeight : Nat) (workerTimes : List Nat) (h_precond : minTimeToReduceMountain_precond (mountainHeight) (workerTimes)) : Nat :=
  -- !benchmark @start code
  
    let rec binarySearch (low : Nat) (high : Nat) : Nat :=
      if low ≥ high then low else
      let mid := (low + high) / 2
      if isSufficientTime mountainHeight workerTimes mid then
        binarySearch low mid
      else
        binarySearch (mid + 1) high
    
    -- Estimate upper bound: worst case when only the slowest worker does all work
    let maxWorkerTime := workerTimes.foldl (fun maxW w => if w > maxW then w else maxW) 1
    let maxTime := workCost maxWorkerTime mountainHeight
    binarySearch 0 (maxTime + 1)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def minTimeToReduceMountain_postcond (mountainHeight : Nat) (workerTimes : List Nat) (result: Nat) (h_precond : minTimeToReduceMountain_precond (mountainHeight) (workerTimes)) : Prop :=
  -- !benchmark @start postcond
  ∃ t : Nat,
    isSufficientTime mountainHeight workerTimes t ∧
    result = t ∧
    (∀ t' < t, ¬isSufficientTime mountainHeight workerTimes t')
  -- !benchmark @end postcond


-- Proof content
theorem minTimeToReduceMountain_postcond_satisfied (mountainHeight: Nat) (workerTimes: List Nat) (h_precond : minTimeToReduceMountain_precond (mountainHeight) (workerTimes)) :
    minTimeToReduceMountain_postcond (mountainHeight) (workerTimes) (minTimeToReduceMountain (mountainHeight) (workerTimes) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof