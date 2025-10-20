import Mathlib

namespace no_555_leetcode_1060


-- Precondition auxiliary definitions
def isSortedUnique (nums : Array Int) : Prop :=
  ∀ i j : Nat, i < j → j < nums.size → nums[i]! < nums[j]!

def countMissing (nums : Array Int) (idx : Nat) : Int :=
  if h : idx < nums.size then
    nums[idx]! - nums[0]! - idx
  else
    0

-- Precondition definitions
@[reducible, simp]
def findKthMissing_precond (nums : Array Int) (k : Nat) : Prop :=
  -- !benchmark @start precond
  k > 0 ∧ nums.size > 0 ∧ isSortedUnique nums
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Binary search to find the index where the kth missing number lies -/
def findIndex (nums : Array Int) (k : Nat) : Nat :=
  let rec loop (l r : Nat) : Nat :=
    if l ≥ r then
      l
    else
      let mid := (l + r) / 2
      let missing := countMissing nums mid
      if missing < k then
        loop (mid + 1) r
      else
        loop l mid
  loop 0 nums.size

-- Main function definitions
def findKthMissing (nums : Array Int) (k : Nat) (h_precond : findKthMissing_precond (nums) (k)) : Int :=
  -- !benchmark @start code
  let idx := findIndex nums k
  if idx = 0 then
    nums[0]! + k
  else if idx < nums.size then
    nums[idx - 1]! + (k - countMissing nums (idx - 1))
  else
    nums[nums.size - 1]! + (k - countMissing nums (nums.size - 1))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def missingUpTo (nums : Array Int) (idx : Nat) : Int :=
  if h : idx < nums.size then
    nums[idx]! - nums[0]! - idx
  else
    nums[nums.size - 1]! - nums[0]! - (nums.size - 1)

-- Postcondition definitions
@[reducible, simp]
def findKthMissing_postcond (nums : Array Int) (k : Nat) (result: Int) (h_precond : findKthMissing_precond (nums) (k)) : Prop :=
  -- !benchmark @start postcond
  (if k ≤ missingUpTo nums (nums.size - 1) then
    ∃ i : Nat, i < nums.size ∧
      (i = 0 ∨ missingUpTo nums (i - 1) < k) ∧
      k ≤ missingUpTo nums i ∧
      result = nums[0]! + (k + i)
  else
    result = nums[nums.size - 1]! + (k - missingUpTo nums (nums.size - 1)))
  -- !benchmark @end postcond


-- Proof content
theorem findKthMissing_postcond_satisfied (nums: Array Int) (k: Nat) (h_precond : findKthMissing_precond (nums) (k)) :
    findKthMissing_postcond (nums) (k) (findKthMissing (nums) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_555_leetcode_1060