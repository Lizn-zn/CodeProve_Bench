import Mathlib

namespace no_116_leetcode_219


-- Precondition auxiliary definitions
def withinBounds (nums : List Int) (k : Nat) : Prop :=
  1 ≤ nums.length ∧ nums.length ≤ 10^5 ∧
  (∀ i ∈ List.range nums.length, -10^9 ≤ nums[i]! ∧ nums[i]! ≤ 10^9) ∧
  k ≤ 10^5

-- Precondition definitions
@[reducible, simp]
def containsNearbyDuplicate_precond (nums : List Int) (k : Nat) : Prop :=
  -- !benchmark @start precond
  withinBounds nums k
  -- !benchmark @end precond


-- Code auxiliary definitions
def checkNearby (nums : List Int) (k : Nat) (index : Nat) (value : Int) : Bool :=
  let rec go (i : Nat) : Bool :=
    if h : i < index then
      let diff := if index < i then i - index else index - i
      if diff ≤ k ∧ nums[i]! = value then
        true
      else
        go (i+1)
    else
      false
  go 0

-- Main function definitions
def containsNearbyDuplicate (nums : List Int) (k : Nat) (h_precond : containsNearbyDuplicate_precond (nums) (k)) : Bool :=
  -- !benchmark @start code
  let rec loop (i : Nat) : Bool :=
    if h : i < nums.length then
      let val := nums[i]!
      if checkNearby nums k i val then
        true
      else
        loop (i+1)
    else
      false
  loop 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def hasNearbyDuplicate (nums : List Int) (k : Nat) : Prop :=
  ∃ i j : Nat, i < nums.length ∧ j < nums.length ∧ i ≠ j ∧ nums[i]! = nums[j]! ∧ |(i : Int) - j| ≤ k

-- Postcondition definitions
@[reducible, simp]
def containsNearbyDuplicate_postcond (nums : List Int) (k : Nat) (result: Bool) (h_precond : containsNearbyDuplicate_precond (nums) (k)) : Prop :=
  -- !benchmark @start postcond
  result ↔ hasNearbyDuplicate nums k
  -- !benchmark @end postcond


-- Proof content
theorem containsNearbyDuplicate_postcond_satisfied (nums: List Int) (k: Nat) (h_precond : containsNearbyDuplicate_precond (nums) (k)) :
    containsNearbyDuplicate_postcond (nums) (k) (containsNearbyDuplicate (nums) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_116_leetcode_219