import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def countValidThresholds_precond (n : Nat) (difficulties : List Nat) : Prop :=
  -- !benchmark @start precond
  -- N is even and at least 2
  n ≥ 2 ∧ n % 2 = 0 ∧
  -- The list has exactly n elements
  difficulties.length = n ∧
  -- All difficulties are at least 1 and at most 10^5
  (∀ d ∈ difficulties, 1 ≤ d ∧ d ≤ 100000)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's in postcond_aux

-- Main function definitions
def countValidThresholds (n : Nat) (difficulties : List Nat) (h_precond : countValidThresholds_precond (n) (difficulties)) : Nat :=
  -- !benchmark @start code
  -- Sort the difficulties
    let sorted := difficulties.toArray.qsort (· ≤ ·) |>.toList
    -- Get the middle index
    let mid := n / 2
    -- Return the difference between the mid-th and (mid-1)-th elements
    sorted[mid]! - sorted[mid - 1]!
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to count how many elements are >= K
def countGreaterOrEqual (lst : List Nat) (k : Nat) : Nat :=
  lst.filter (· ≥ k) |>.length

-- Helper function to check if K is a valid threshold
-- K is valid if exactly n/2 problems have difficulty >= K
def isValidThreshold (difficulties : List Nat) (n : Nat) (k : Nat) : Prop :=
  countGreaterOrEqual difficulties k = n / 2

-- Postcondition definitions
@[reducible, simp]
def countValidThresholds_postcond (n : Nat) (difficulties : List Nat) (result: Nat) (h_precond : countValidThresholds_precond (n) (difficulties)) : Prop :=
  -- !benchmark @start postcond
  -- The result counts the number of distinct values of K such that:
  -- - exactly n/2 problems have difficulty >= K (for ARCs)
  -- - exactly n/2 problems have difficulty < K (for ABCs)
  -- Based on the informal code: after sorting, K can be any value in the range
  -- (d[n/2-1], d[n/2]], where d is sorted in ascending order
  let sorted := difficulties.toArray.qsort (· ≤ ·) |>.toList
  let mid := n / 2
  -- The result is the difference between the (mid)th and (mid-1)th elements
  -- in the sorted list (1-indexed: mid corresponds to index mid-1, mid-1 corresponds to index mid-2)
  result = sorted[mid]! - sorted[mid - 1]! ∧
  -- This represents the count of integer values K where sorted[mid-1] < K ≤ sorted[mid]
  -- which is exactly sorted[mid] - sorted[mid-1]
  (∀ k : Nat, isValidThreshold difficulties n k ↔ sorted[mid - 1]! < k ∧ k ≤ sorted[mid]!)
  -- !benchmark @end postcond


-- Proof content
theorem countValidThresholds_postcond_satisfied (n: Nat) (difficulties: List Nat) (h_precond : countValidThresholds_precond (n) (difficulties)) :
    countValidThresholds_postcond (n) (difficulties) (countValidThresholds (n) (difficulties) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

