import Mathlib

namespace no_1396_leetcode_2790


-- Precondition auxiliary definitions
/-- `sortedUsageLimits` represents the sorted version of the input list `usageLimits`. -/
def sortedUsageLimits (usageLimits : List Nat) : List Nat :=
  usageLimits.mergeSort (· ≤ ·)

/-- `partialSums` computes the partial sums of a list of natural numbers. -/
def partialSums : List Nat → List Nat
  | [] => []
  | x :: xs =>
    let rest := partialSums xs
    match rest with
    | [] => [x]
    | y :: ys => x :: (x + y) :: ys.map (· + x)

/-- `triangularNumbers` generates a list of triangular numbers up to a given length. -/
def triangularNumbers : Nat → List Nat
  | 0 => []
  | n + 1 =>
    let prev := triangularNumbers n
    match prev with
    | [] => [1]
    | _ =>
      let last := prev.getLast!
      (prev ++ [last + (n + 1)])

/-- `canFormKGroups` checks whether it's possible to form `k` groups satisfying the constraints. -/
noncomputable def canFormKGroups (usageLimits : List Nat) (k : Nat) : Bool :=
  let sorted := sortedUsageLimits usageLimits
  let prefixSums := partialSums sorted
  let requiredSums := triangularNumbers k
  if requiredSums.length > prefixSums.length then
    false
  else
    (List.zipWith (· ≥ ·) prefixSums requiredSums).all (· = true)

-- Precondition definitions
@[reducible, simp]
def maxIncreasingGroups_precond (usageLimits : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

/-- `maxGroups` computes the maximum number of groups that can be formed. -/
noncomputable def maxGroups (usageLimits : List Nat) : Nat :=
  let n := usageLimits.length
  -- Binary search over the number of groups from 0 to n
  let rec go (low : Nat) (high : Nat) : Nat :=
    if low > high then
      low - 1
    else
      let mid := (low + high) / 2
      if canFormKGroups usageLimits mid then
        go (mid + 1) high
      else
        go low (mid - 1)
  termination_by high - low
  decreasing_by
    all_goals sorry
  go 0 n

-- Main function definitions
noncomputable def maxIncreasingGroups (usageLimits : List Nat) (h_precond : maxIncreasingGroups_precond (usageLimits)) : Nat :=
  -- !benchmark @start code
  maxGroups usageLimits
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def maxIncreasingGroups_postcond (usageLimits : List Nat) (result: Nat) (h_precond : maxIncreasingGroups_precond (usageLimits)) : Prop :=
  -- !benchmark @start postcond
  result = maxGroups usageLimits
  -- !benchmark @end postcond

-- Proof content
theorem maxIncreasingGroups_postcond_satisfied (usageLimits: List Nat) (h_precond : maxIncreasingGroups_precond (usageLimits)) :
    maxIncreasingGroups_postcond (usageLimits) (maxIncreasingGroups (usageLimits) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1396_leetcode_2790