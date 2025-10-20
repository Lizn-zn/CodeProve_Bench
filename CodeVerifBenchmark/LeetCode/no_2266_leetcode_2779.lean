import Mathlib

namespace no_2266_leetcode_2779


-- Precondition auxiliary definitions
/-- An interval [l, r] represented as a pair of natural numbers. -/
structure MyInterval where
  l : Int
  r : Int
deriving Repr, DecidableEq

/-- Check if two intervals overlap. -/
def MyInterval.overlap (i j : MyInterval) : Prop :=
  max i.l j.l ≤ min i.r j.r

/-- Convert a number `n` and radius `k` into an interval `[n - k, n + k]`. -/
def numToInterval (n : Nat) (k : Nat) : MyInterval :=
  { l := (Int.ofNat n) - (Int.ofNat k), r := (Int.ofNat n) + (Int.ofNat k) }

/-- A list of intervals derived from `nums` and `k`. -/
def numsToIntervals (nums : List Nat) (k : Nat) : List MyInterval :=
  nums.map (fun n => numToInterval n k)

/-- Check if there exists a value common to all intervals in the list. -/
def intervalsHaveCommonValue (intervals : List MyInterval) : Prop :=
  match intervals with
  | [] => True
  | head :: tail =>
    let commonL := tail.foldl (fun acc i => max acc i.l) head.l
    let commonR := tail.foldl (fun acc i => min acc i.r) head.r
    commonL ≤ commonR

/-- Count how many intervals contain a specific value `x`. -/
def countContaining (intervals : List MyInterval) (x : Int) : Nat :=
  intervals.foldl (fun count i => if i.l ≤ x ∧ x ≤ i.r then count + 1 else count) 0

/-- Compute the maximum number of overlapping intervals at any point. -/
def maxOverlapCount (intervals : List MyInterval) : Nat :=
  match intervals with
  | [] => 0
  | _ =>
    -- We evaluate overlaps at critical points: left and right endpoints
    let points := intervals.flatMap (fun i => [i.l, i.r])
    let counts := points.map (countContaining intervals)
    counts.foldl Nat.max 0

-- Precondition definitions
@[reducible, simp]
def maximumBeauty_precond (nums : List Nat) (k : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Sort a list of integers in ascending order. -/
def sortIntList : List Int → List Int
  | [] => []
  | x :: xs =>
    let smaller := xs.filter (fun y => y < x)
    let larger := xs.filter (fun y => y ≥ x)
    let _ : smaller.length < (x :: xs).length := Nat.lt_succ_of_le (List.length_filter_le _ _)
    let _ : larger.length < (x :: xs).length := Nat.lt_succ_of_le (List.length_filter_le _ _)
    sortIntList smaller ++ [x] ++ sortIntList larger
  termination_by xs => xs.length

/-- Compute the maximum overlap of intervals using a sweep-line algorithm. -/
def maxOverlapCountEfficient (intervals : List MyInterval) : Nat :=
  match intervals with
  | [] => 0
  | _ =>
    -- Create events: (point, delta)
    let startEvents := intervals.map (fun i => (i.l, 1))
    let endEvents := intervals.map (fun i => (i.r + 1, (·-·) 0 1))  -- Use Int subtraction to get -1
    let events := startEvents ++ endEvents
    -- Sort events by point
    let sortedPoints := sortIntList (events.map Prod.fst)
    let sortedPointsDedup := sortedPoints.eraseDup
    let counts := sortedPointsDedup.map fun p =>
      events.foldl (fun acc (ep, delta) => if ep ≤ p then acc + delta else acc) 0
    counts.foldl Nat.max 0

-- Main function definitions
def maximumBeauty (nums : List Nat) (k : Nat) (h_precond : maximumBeauty_precond (nums) (k)) : Nat :=
  -- !benchmark @start code
  let intervals := numsToIntervals nums k
  maxOverlapCountEfficient intervals
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def maximumBeauty_postcond (nums : List Nat) (k : Nat) (result: Nat) (h_precond : maximumBeauty_precond (nums) (k)) : Prop :=
  -- !benchmark @start postcond
  let intervals := numsToIntervals nums k
  maxOverlapCount intervals = result
  -- !benchmark @end postcond


-- Proof content
theorem maximumBeauty_postcond_satisfied (nums: List Nat) (k: Nat) (h_precond : maximumBeauty_precond (nums) (k)) :
    maximumBeauty_postcond (nums) (k) (maximumBeauty (nums) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2266_leetcode_2779