import Mathlib

namespace no_943_leetcode_1133


-- Precondition auxiliary definitions
def countOccurrences (nums : List Nat) (n : Nat) : Nat :=
  nums.filter (· = n) |>.length

def occursOnce (nums : List Nat) (n : Nat) : Bool :=
  countOccurrences nums n = 1

-- Precondition definitions
@[reducible, simp]
def largestUniqueNumber_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ nums.length ∧ nums.length ≤ 2000 ∧ nums.all (· ≤ 1000)
  -- !benchmark @end precond

-- Postcondition auxiliary definitions
def uniqueNumbers (nums : List Nat) : List Nat :=
  nums.filter (occursOnce nums ·)

-- Code auxiliary definitions
def getLargestUniqueNumber (nums : List Nat) : Int :=
  let uniqueNums := uniqueNumbers nums
  if uniqueNums.isEmpty then
    -1
  else
    let maxVal : Nat := uniqueNums.foldl max 0
    maxVal

-- Main function definitions
def largestUniqueNumber (nums : List Nat) (h_precond : largestUniqueNumber_precond nums) : Int :=
  -- !benchmark @start code
  getLargestUniqueNumber nums
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def largestUniqueNumber_postcond (nums : List Nat) (result : Int) (h_precond : largestUniqueNumber_precond nums) : Prop :=
  -- !benchmark @start postcond
  (if (uniqueNumbers nums).isEmpty then
    result = -1
  else
    let maxVal := (uniqueNumbers nums).foldl max 0
    result = maxVal) ∧
  result ≥ -1
  -- !benchmark @end postcond

-- Proof content
theorem largestUniqueNumber_postcond_satisfied (nums : List Nat) (h_precond : largestUniqueNumber_precond nums) :
    largestUniqueNumber_postcond nums (largestUniqueNumber nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_943_leetcode_1133