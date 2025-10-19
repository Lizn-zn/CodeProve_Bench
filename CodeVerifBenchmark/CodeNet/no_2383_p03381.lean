import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def findMediansExcludingEach_precond (n : Nat) (xs : List Nat) : Prop :=
  -- !benchmark @start precond
  -- N is even and at least 2
    n ≥ 2 ∧ n % 2 = 0 ∧ xs.length = n ∧ 
    -- All elements are positive (between 1 and 10^9)
    (∀ x ∈ xs, 1 ≤ x ∧ x ≤ 1000000000)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No additional auxiliary definitions needed beyond those in postcond_aux

-- Main function definitions
def findMediansExcludingEach (n : Nat) (xs : List Nat) (h_precond : findMediansExcludingEach_precond (n) (xs)) : List Nat :=
  -- !benchmark @start code
  -- Sort the list once
    let sorted := xs.mergeSort (· ≤ ·)
    -- Get the two middle elements (at positions n/2-1 and n/2)
    let mid1 := sorted[n / 2 - 1]!
    let mid2 := sorted[n / 2]!
    -- For each element, determine which median to use
    xs.map (fun x => if x >= mid1 then mid2 else mid1)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to get the median of a list with odd length
def medianOfOddList (lst : List Nat) : Nat :=
  let sorted := lst.mergeSort (· ≤ ·)
  sorted[(sorted.length / 2)]!

-- Helper function to remove element at index i from a list
def removeAt (lst : List Nat) (i : Nat) : List Nat :=
  (lst.take i) ++ (lst.drop (i + 1))

-- Postcondition definitions
@[reducible, simp]
def findMediansExcludingEach_postcond (n : Nat) (xs : List Nat) (result: List Nat) (h_precond : findMediansExcludingEach_precond (n) (xs)) : Prop :=
  -- !benchmark @start postcond
  -- Result has the same length as input
    result.length = n ∧
    -- For each index i, result[i] is the median of xs excluding xs[i]
    (∀ i : Nat, i < n → 
      result[i]! = medianOfOddList (removeAt xs i))
  -- !benchmark @end postcond


-- Proof content
theorem findMediansExcludingEach_postcond_satisfied (n: Nat) (xs: List Nat) (h_precond : findMediansExcludingEach_precond (n) (xs)) :
    findMediansExcludingEach_postcond (n) (xs) (findMediansExcludingEach (n) (xs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof