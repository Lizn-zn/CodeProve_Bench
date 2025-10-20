import Mathlib

namespace no_1297_leetcode_1588


-- Precondition auxiliary definitions
/-- Auxiliary definition for sum of subarray from index i to j (inclusive) -/
def subarraySum (arr : Array Nat) (i j : Nat) : Nat :=
  if h : i ≤ j ∧ j < arr.size then
    let indices := List.range (j - i + 1)
    indices.foldl (fun acc k => acc + arr.get! (i+k)) 0
  else
    0

/-- Check if a number is odd -/
def isOdd (n : Nat) : Bool :=
  n % 2 = 1

-- Precondition definitions
@[reducible, simp]
def sumOddLengthSubarrays_precond (arr : Array Nat) : Prop :=
  -- !benchmark @start precond
  arr.size > 0 ∧ (∀ i, i < arr.size → arr.get! i > 0)
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Efficiently calculate the sum of all odd-length subarrays using contribution counting -/
def sumOddLengthSubarraysEfficient (arr : Array Nat) : Nat :=
  let n := arr.size
  let indices := List.range n
  indices.foldl (fun acc i =>
    let left := i + 1
    let right := n - i
    let totalSubarrays := left * right
    let oddCount := (totalSubarrays + 1) / 2
    acc + arr.get! i * oddCount
  ) 0

-- Main function definitions
def sumOddLengthSubarrays (arr : Array Nat) (h_precond : sumOddLengthSubarrays_precond arr) : Nat :=
  -- !benchmark @start code
  sumOddLengthSubarraysEfficient arr
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Generate all odd-length subarrays and compute their sum -/
def sumOfOddLengthSubarrays (arr : Array Nat) : Nat :=
  let indices := List.range arr.size
  let subarrays := indices.flatMap fun i =>
    let remainingIndices := List.range (arr.size - i)
    remainingIndices.map fun j => (i, i + j)
  let oddLengthSubarrays := subarrays.filter fun p => isOdd (p.2 - p.1 + 1)
  oddLengthSubarrays.foldl (fun acc p => acc + subarraySum arr p.1 p.2) 0

-- Postcondition definitions
@[reducible, simp]
def sumOddLengthSubarrays_postcond (arr : Array Nat) (result : Nat) (h_precond : sumOddLengthSubarrays_precond arr) : Prop :=
  -- !benchmark @start postcond
  result = sumOfOddLengthSubarrays arr
  -- !benchmark @end postcond


-- Proof content
theorem sumOddLengthSubarrays_postcond_satisfied (arr : Array Nat) (h_precond : sumOddLengthSubarrays_precond arr) :
    sumOddLengthSubarrays_postcond arr (sumOddLengthSubarrays arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1297_leetcode_1588