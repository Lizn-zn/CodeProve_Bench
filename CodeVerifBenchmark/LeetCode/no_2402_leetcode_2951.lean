import Mathlib

namespace no_2402_leetcode_2951


-- Precondition definitions
@[reducible, simp]
def findPeaks_precond (mountain : List Nat) : Prop :=
  -- !benchmark @start precond
  mountain.length ≥ 3
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Check if index `i` is a peak in the mountain list -/
def isPeak (mountain : List Nat) (i : Nat) : Bool :=
  if h : i > 0 ∧ i < mountain.length - 1 then
    let prev := mountain.get! (i-1)
    let curr := mountain.get! i
    let next := mountain.get! (i+1)
    curr > prev ∧ curr > next
  else
    false

-- Main function definitions
def findPeaks (mountain : List Nat) (h_precond : findPeaks_precond (mountain)) : List Nat :=
  -- !benchmark @start code
  List.range mountain.length |>.filter (isPeak mountain ·)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- A valid peak index `i` in the mountain list -/
def IsPeak (mountain : List Nat) (i : Nat) : Prop :=
  -- Must be within bounds (not first or last)
  i > 0 ∧ i < mountain.length - 1 ∧
  -- Must be strictly greater than both neighbors
  mountain.get! i > mountain.get! (i-1) ∧
  mountain.get! i > mountain.get! (i+1)

-- Postcondition definitions
@[reducible, simp]
def findPeaks_postcond (mountain : List Nat) (result: List Nat) (h_precond : findPeaks_precond (mountain)) : Prop :=
  -- !benchmark @start postcond
  -- The result must contain only valid peak indices
  (∀ i ∈ result, IsPeak mountain i) ∧
  -- All valid peak indices must be in the result (completeness)
  (∀ i, IsPeak mountain i → i ∈ result) ∧
  -- The result must contain no duplicates
  result.Nodup
  -- !benchmark @end postcond


-- Proof content
theorem findPeaks_postcond_satisfied (mountain: List Nat) (h_precond : findPeaks_precond (mountain)) :
    findPeaks_postcond (mountain) (findPeaks (mountain) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2402_leetcode_2951