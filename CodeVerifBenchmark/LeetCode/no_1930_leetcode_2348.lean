import Mathlib

-- Precondition auxiliary definitions
/-- A helper function that counts the number of zero-filled subarrays in a list of integers. -/
def countZeroSubarraysAux : List Int → Nat
  | [] => 0
  | xs =>
    let contiguousZeros := List.takeWhile (· = 0) xs
    let n := contiguousZeros.length
    -- For a group of n consecutive zeros, the number of subarrays is n * (n + 1) / 2
    (n * (n + 1)) / 2 + countZeroSubarraysAux (List.drop (n + 1) xs)
  decreasing_by sorry

-- Precondition definitions
@[reducible, simp]
def countZeroSubarrays_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Counts the number of subarrays filled with 0 in a single pass. -/
def countZeroSubarraysCore : List Int → Nat → Nat
  | [], _ => 0
  | x :: xs, currentCount =>
    if x = 0 then
      let newCount := currentCount + 1
      newCount + countZeroSubarraysCore xs newCount
    else
      countZeroSubarraysCore xs 0

-- Main function definitions
def countZeroSubarrays (nums : List Int) (h_precond : countZeroSubarrays_precond (nums)) : Nat :=
  -- !benchmark @start code
  countZeroSubarraysCore nums 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def countZeroSubarrays_postcond (nums : List Int) (result: Nat) (h_precond : countZeroSubarrays_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result = countZeroSubarraysAux nums
  -- !benchmark @end postcond


-- Proof content
theorem countZeroSubarrays_postcond_satisfied (nums: List Int) (h_precond : countZeroSubarrays_precond (nums)) :
    countZeroSubarrays_postcond (nums) (countZeroSubarrays (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof