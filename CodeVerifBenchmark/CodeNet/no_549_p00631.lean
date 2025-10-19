import Mathlib

-- Precondition definitions
@[reducible, simp]
def splitUp_precond (powers : List Nat) : Prop :=
  -- !benchmark @start precond
  powers.length > 0 ∧ powers.length ≤ 20 ∧ (∀ p ∈ powers, p ≤ 1000000)
  -- !benchmark @end precond


-- Postcondition auxiliary definitions
-- Helper function to compute the sum of a list
def listSum (powers : List Nat) : Nat :=
  powers.foldl (· + ·) 0

-- Code auxiliary definitions
-- Helper function to compute all possible subset sums using dynamic programming
def computeReachableSums (powers : List Nat) (maxSum : Nat) : Array Bool :=
  let initial := Array.mkArray (maxSum + 1) false |>.set! 0 true
  powers.foldl (fun reachable p =>
    List.range (maxSum + 1) |>.foldl (fun acc i =>
      if i >= p && reachable[i - p]! then
        acc.set! i true
      else
        acc
    ) reachable
  ) initial

-- Helper function to find the closest reachable sum to target
def findClosestSum (reachable : Array Bool) (target : Nat) : Nat :=
  let rec search (offset : Nat) : Nat :=
    if offset > target then 0
    else if target >= offset && reachable[target - offset]! then target - offset
    else if target + offset < reachable.size && reachable[target + offset]! then target + offset
    else search (offset + 1)
  termination_by (2 * target + 1 - offset)
  search 0

-- Main function definitions
def splitUp (powers : List Nat) (h_precond : splitUp_precond (powers)) : Nat :=
  -- !benchmark @start code
  let total := listSum powers
  let half := total / 2
  let reachable := computeReachableSums powers total
  let closestToHalf := findClosestSum reachable half
  let groupBSum := total - closestToHalf
  if closestToHalf >= groupBSum then
    closestToHalf - groupBSum
  else
    groupBSum - closestToHalf
  -- !benchmark @end code


-- Helper function to check if a subset sum equals a target
def canMakeSum (powers : List Nat) (target : Nat) : Prop :=
  ∃ (subset : List Bool), subset.length = powers.length ∧
    (List.zip powers subset).foldl (fun acc (p, selected) => if selected then acc + p else acc) 0 = target

-- Helper function to compute the absolute difference between two group sums
-- when one group has sum `groupASum` and the total is `total`
def groupDiff (total : Nat) (groupASum : Nat) : Nat :=
  let groupBSum := total - groupASum
  if groupASum ≥ groupBSum then groupASum - groupBSum else groupBSum - groupASum

-- Postcondition definitions
@[reducible, simp]
def splitUp_postcond (powers : List Nat) (result: Nat) (h_precond : splitUp_precond (powers)) : Prop :=
  -- !benchmark @start postcond
  let total := listSum powers
  -- result is the minimum possible difference
  ∃ (groupASum : Nat), 
    -- There exists a valid partition where group A has sum groupASum
    canMakeSum powers groupASum ∧ 
    groupASum ≤ total ∧
    -- The result equals the difference for this partition
    result = groupDiff total groupASum ∧
    -- For all other valid partitions, the difference is at least result
    (∀ (otherSum : Nat), canMakeSum powers otherSum → otherSum ≤ total → 
      groupDiff total otherSum ≥ result)
  -- !benchmark @end postcond


-- Proof content
theorem splitUp_postcond_satisfied (powers: List Nat) (h_precond : splitUp_precond (powers)) :
    splitUp_postcond (powers) (splitUp (powers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof