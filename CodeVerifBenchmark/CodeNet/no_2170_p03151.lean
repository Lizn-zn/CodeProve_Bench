import Mathlib

namespace no_2170_p03151


-- Precondition definitions
@[reducible, simp]
def minExamChanges_precond (n : Nat) (A : List Int) (B : List Int) : Prop :=
  -- !benchmark @start precond
  n > 0 ∧ A.length = n ∧ B.length = n ∧ 
    (∀ i, i < n → A[i]! > 0 ∧ B[i]! > 0)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to sort a list in descending order
def sortDescending (l : List Int) : List Int :=
  l.toArray.qsort (· > ·) |>.toList

-- Helper function to count how many elements can remain unchanged
def countUnchanged (sorted_C : List Int) (surplus : Int) (idx : Nat) (count : Nat) : Nat :=
  if idx >= sorted_C.length then count
  else
    let val := sorted_C[idx]!
    if val < 0 then count
    else if val ≤ surplus then
      countUnchanged sorted_C (surplus - val) (idx + 1) (count + 1)
    else count

-- Main function definitions
def minExamChanges (n : Nat) (A : List Int) (B : List Int) (h_precond : minExamChanges_precond (n) (A) (B)) : Int :=
  -- !benchmark @start code
  -- Calculate C[i] = A[i] - B[i] for each i
    let C_diff := List.zipWith (· - ·) A B
    -- Calculate total surplus
    let total_surplus := C_diff.foldl (· + ·) 0
    -- If total surplus is negative, impossible to satisfy all requirements
    if total_surplus < 0 then -1
    else
      -- Sort C_diff in descending order
      let sorted_C := sortDescending C_diff
      -- Count how many elements can remain unchanged
      let unchanged := countUnchanged sorted_C total_surplus 0 0
      -- Return the number of changes needed
      n - unchanged
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if a valid sequence C exists
def validSequenceExists (A B : List Int) : Prop :=
  ∃ C : List Int, 
    C.length = A.length ∧
    (C.map (·.toNat)).sum = (A.map (·.toNat)).sum ∧
    (∀ i, i < C.length → C[i]! ≥ B[i]!)

-- Helper function to count differences between two sequences
def countDifferences (A C : List Int) : Nat :=
  (List.range A.length).filter (fun i => A[i]! ≠ C[i]!) |>.length

-- Computable version to check if total surplus is non-negative
def hasNonNegativeSurplus (A B : List Int) : Bool :=
  let C_diff := List.zipWith (· - ·) A B
  let total_surplus := C_diff.foldl (· + ·) 0
  total_surplus ≥ 0

-- The minimum number of changes needed
def minChangesNeeded (A B : List Int) : Int :=
  if hasNonNegativeSurplus A B then
    let C_diff := List.zipWith (· - ·) A B
    let total_surplus := C_diff.foldl (· + ·) 0
    if total_surplus < 0 then -1
    else
      let sorted_C := C_diff.toArray.qsort (· > ·) |>.toList
      let rec countUnchanged (surplus : Int) (idx : Nat) (count : Nat) : Nat :=
        if idx >= sorted_C.length then count
        else
          let val := sorted_C[idx]!
          if val < 0 then count
          else if val ≤ surplus then
            countUnchanged (surplus - val) (idx + 1) (count + 1)
          else count
      A.length - countUnchanged total_surplus 0 0
  else -1

-- Postcondition definitions
@[reducible, simp]
def minExamChanges_postcond (n : Nat) (A : List Int) (B : List Int) (result: Int) (h_precond : minExamChanges_precond (n) (A) (B)) : Prop :=
  -- !benchmark @start postcond
  -- If no valid sequence exists, return -1
  (¬validSequenceExists A B → result = -1) ∧
  -- If a valid sequence exists, result is the minimum number of changes
  (validSequenceExists A B → 
    (result = -1 ∨ 
     (result ≥ 0 ∧ result ≤ n ∧
      -- There exists a valid sequence C with exactly 'result' differences from A
      (∃ C : List Int, 
        C.length = n ∧
        (C.map (·.toNat)).sum = (A.map (·.toNat)).sum ∧
        (∀ i, i < n → C[i]! ≥ B[i]!) ∧
        countDifferences A C = result.toNat) ∧
      -- No valid sequence exists with fewer differences
      (∀ C : List Int, 
        C.length = n ∧
        (C.map (·.toNat)).sum = (A.map (·.toNat)).sum ∧
        (∀ i, i < n → C[i]! ≥ B[i]!) →
        countDifferences A C ≥ result.toNat))))
  -- !benchmark @end postcond


-- Proof content
theorem minExamChanges_postcond_satisfied (n: Nat) (A: List Int) (B: List Int) (h_precond : minExamChanges_precond (n) (A) (B)) :
    minExamChanges_postcond (n) (A) (B) (minExamChanges (n) (A) (B) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2170_p03151