import Mathlib

namespace no_1628_leetcode_3255


-- Precondition auxiliary definitions
def IsConsecutiveAndSorted (arr : Array Int) : Bool :=
  if arr.size = 0 then
    true
  else
    let sorted := arr[0]!
    let rec check (i : Nat) : Bool :=
      if i ≥ arr.size then
        true
      else if arr[i]! ≠ sorted + i then
        false
      else
        check (i + 1)
    check 0

-- Precondition definitions
@[reducible, simp]
def findSubarrayPowers_precond (nums : Array Int) (k : Nat) : Prop :=
  -- !benchmark @start precond
  0 < k ∧ k ≤ nums.size
  -- !benchmark @end precond

-- Code auxiliary definitions
def SubarrayPower (nums : Array Int) (start : Nat) (len : Nat) : Int :=
  if start + len > nums.size then
    -1
  else
    let sub := nums[start: start + len]
    if IsConsecutiveAndSorted sub then
      sub[sub.size - 1]!
    else
      -1

-- Main function definitions
def findSubarrayPowers (nums : Array Int) (k : Nat) (h_precond : findSubarrayPowers_precond (nums) (k)) : Array Int :=
  -- !benchmark @start code
  let n := nums.size
  let result_size := n - k + 1
  let result : Array Int := #[]

  let result := (List.range result_size).foldl (fun (acc : Array Int) (i : Nat) =>
    let sub := nums[i:i + k]
    let is_valid := IsConsecutiveAndSorted sub
    let power := if is_valid then sub[sub.size - 1]! else -1
    acc.push power
  ) result

  result
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def findSubarrayPowers_postcond (nums : Array Int) (k : Nat) (result: Array Int) (h_precond : findSubarrayPowers_precond (nums) (k)) : Prop :=
  -- !benchmark @start postcond
  result.size = nums.size - k + 1 ∧
    ∀ (i : Nat), i < result.size → result[i]! = SubarrayPower nums i k
  -- !benchmark @end postcond

-- Proof content
theorem findSubarrayPowers_postcond_satisfied (nums: Array Int) (k: Nat) (h_precond : findSubarrayPowers_precond (nums) (k)) :
    findSubarrayPowers_postcond (nums) (k) (findSubarrayPowers (nums) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1628_leetcode_3255