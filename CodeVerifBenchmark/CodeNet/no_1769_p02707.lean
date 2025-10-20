import Mathlib

namespace no_1769_p02707


-- Precondition definitions
@[reducible, simp]
def countImmediateSubordinates_precond (n : Nat) (bosses : List Nat) : Prop :=
  -- !benchmark @start precond
  -- n is at least 2 (there are at least 2 members)
    n ≥ 2 ∧
    -- bosses list has exactly n-1 elements (for members 2 through n)
    bosses.length = n - 1 ∧
    -- each boss ID is valid: for member i+2, boss ID must be in range [1, i+1]
    (∀ i : Nat, i < bosses.length → 1 ≤ bosses[i]! ∧ bosses[i]! < i + 2)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to increment count at a specific index in a list
def incrementAt (counts : List Nat) (index : Nat) : List Nat :=
  counts.mapIdx (fun i val => if i = index then val + 1 else val)

-- Process all bosses to build the subordinate counts
def processBosses (bosses : List Nat) (n : Nat) : List Nat :=
  bosses.foldl (fun counts boss => incrementAt counts (boss - 1)) (List.replicate n 0)

-- Main function definitions
def countImmediateSubordinates (n : Nat) (bosses : List Nat) (h_precond : countImmediateSubordinates_precond (n) (bosses)) : List Nat :=
  -- !benchmark @start code
  processBosses bosses n
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to count occurrences of a value in a list
def countOccurrences (lst : List Nat) (val : Nat) : Nat :=
  lst.foldl (fun acc x => if x = val then acc + 1 else acc) 0

-- Postcondition definitions
@[reducible, simp]
def countImmediateSubordinates_postcond (n : Nat) (bosses : List Nat) (result: List Nat) (h_precond : countImmediateSubordinates_precond (n) (bosses)) : Prop :=
  -- !benchmark @start postcond
  -- result has exactly n elements (one for each member)
    result.length = n ∧
    -- for each member i (1-indexed), result[i-1] equals the number of times i appears in bosses
    (∀ i : Nat, i < n → result[i]! = countOccurrences bosses (i + 1))
  -- !benchmark @end postcond


-- Proof content
theorem countImmediateSubordinates_postcond_satisfied (n: Nat) (bosses: List Nat) (h_precond : countImmediateSubordinates_precond (n) (bosses)) :
    countImmediateSubordinates_postcond (n) (bosses) (countImmediateSubordinates (n) (bosses) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1769_p02707