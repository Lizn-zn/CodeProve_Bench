import Mathlib

-- Precondition definitions
@[reducible, simp]
def reconstructOrder_precond (n : Nat) (counts : Array Nat) : Prop :=
  -- !benchmark @start precond
  counts.size = n ∧ n ≥ 1 ∧
    -- All counts are between 1 and n
    (∀ i : Fin n, 1 ≤ counts[i]! ∧ counts[i]! ≤ n) ∧
    -- All counts are distinct
    (∀ i j : Fin n, i ≠ j → counts[i]! ≠ counts[j]!)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to create the result array by placing student numbers at positions based on their counts
partial def buildOrder (n : Nat) (counts : Array Nat) (idx : Nat) (result : Array Nat) : Array Nat :=
  if idx >= n then
    result
  else
    let studentNum := idx + 1
    let position := counts[idx]! - 1
    let newResult := result.set! position studentNum
    buildOrder n counts (idx + 1) newResult

-- Main function definitions
def reconstructOrder (n : Nat) (counts : Array Nat) (h_precond : reconstructOrder_precond (n) (counts)) : Array Nat :=
  -- !benchmark @start code
  -- Initialize result array with zeros
    let result := Array.mkArray n 0
    -- Build the order by placing each student at their corresponding position
    buildOrder n counts 0 result
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def reconstructOrder_postcond (n : Nat) (counts : Array Nat) (result: Array Nat) (h_precond : reconstructOrder_precond (n) (counts)) : Prop :=
  -- !benchmark @start postcond
  -- Result has correct size
    result.size = n ∧
    -- Result contains a permutation of student numbers 1 to n
    (∀ i : Fin n, 1 ≤ result[i]! ∧ result[i]! ≤ n) ∧
    (∀ i j : Fin n, i ≠ j → result[i]! ≠ result[j]!) ∧
    -- The key property: if student k entered at position i (0-indexed),
    -- then counts[k-1] = i + 1 (the number of students including themselves)
    (∀ i : Fin n, counts[result[i]! - 1]! = i.val + 1)
  -- !benchmark @end postcond


-- Proof content
theorem reconstructOrder_postcond_satisfied (n: Nat) (counts: Array Nat) (h_precond : reconstructOrder_precond (n) (counts)) :
    reconstructOrder_postcond (n) (counts) (reconstructOrder (n) (counts) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

