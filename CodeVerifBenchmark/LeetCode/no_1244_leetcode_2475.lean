import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def countTriplets_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  -- The precondition is simply that the input is a list of natural numbers
  -- This is already guaranteed by the type signature, so we just return true
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/--
  Count the number of valid triplets (i, j, k) such that:
  - 0 ≤ i < j < k < length of nums
  - nums[i], nums[j], and nums[k] are pairwise distinct
-/
def countTripletsImpl (nums : List Nat) : Nat :=
  let arr := nums.toArray
  let n := arr.size
  let count := (0 : Nat)
  let count := Id.run do
    let mut c := count
    for i in [:n] do
      for j in [i+1:n] do
        for k in [j+1:n] do
          if arr[i]! ≠ arr[j]! ∧ arr[i]! ≠ arr[k]! ∧ arr[j]! ≠ arr[k]! then
            c := c + 1
    c
  count

-- Main function definitions
def countTriplets (nums : List Nat) (h_precond : countTriplets_precond (nums)) : Nat :=
  -- !benchmark @start code
  countTripletsImpl nums
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- 
  Count the number of valid triplets (i, j, k) such that:
  - 0 ≤ i < j < k < length of nums
  - nums[i], nums[j], and nums[k] are pairwise distinct
-/
def countValidTriplets (nums : List Nat) : Nat :=
  let indices := List.range nums.length
  let triplets := indices.flatMap fun i =>
    (List.range nums.length).flatMap fun j =>
      (List.range nums.length).flatMap fun k =>
        if i < j ∧ j < k ∧ 
           nums.get! i ≠ nums.get! j ∧
           nums.get! i ≠ nums.get! k ∧
           nums.get! j ≠ nums.get! k then
          [1]
        else
          []
  triplets.length

-- Postcondition definitions
@[reducible, simp]
def countTriplets_postcond (nums : List Nat) (result: Nat) (h_precond : countTriplets_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  -- The result should equal the number of valid triplets as computed by our reference implementation
  result = countValidTriplets nums
  -- !benchmark @end postcond


-- Proof content
theorem countTriplets_postcond_satisfied (nums: List Nat) (h_precond : countTriplets_precond (nums)) :
    countTriplets_postcond (nums) (countTriplets (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof