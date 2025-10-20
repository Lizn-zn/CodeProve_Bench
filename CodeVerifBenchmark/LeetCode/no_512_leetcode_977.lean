import Mathlib

namespace no_512_leetcode_977


-- Precondition auxiliary definitions
/-- Checks if an array is sorted in non-decreasing order -/
def IsSorted (arr : Array Int) : Prop :=
  ∀ i j : Nat, i < j → j < arr.size → arr[i]! ≤ arr[j]!

-- Precondition definitions
@[reducible, simp]
def sortedSquares_precond (nums : Array Int) : Prop :=
  -- !benchmark @start precond
  IsSorted nums
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Merge two sorted arrays into one sorted array -/
def mergeSorted (arr1 arr2 : Array Int) : Array Int := Id.run do
  let mut result := #[]
  let mut i := 0
  let mut j := 0
  
  while i < arr1.size && j < arr2.size do
    if arr1[i]! ≤ arr2[j]! then
      result := result.push arr1[i]!
      i := i + 1
    else
      result := result.push arr2[j]!
      j := j + 1
  
  -- Add remaining elements from arr1
  while i < arr1.size do
    result := result.push arr1[i]!
    i := i + 1
  
  -- Add remaining elements from arr2
  while j < arr2.size do
    result := result.push arr2[j]!
    j := j + 1
    
  return result

/-- Square all elements in an array -/
def squareArray (arr : Array Int) : Array Int :=
  arr.map (fun x => x * x)

-- Main function definitions
def sortedSquares (nums : Array Int) (h_precond : sortedSquares_precond nums) : Array Int :=
  -- !benchmark @start code
  -- Since the input is sorted, we can split it into negative and non-negative parts
  -- Then square each part (which reverses the negative part's order)
  -- Finally merge them back together
  
  let negPart := #[]
  let nonNegPart := #[]
  
  -- Split the array into negative and non-negative parts
  let parts := nums.foldl (fun acc num =>
    if num < 0 then
      (acc.1.push num, acc.2)
    else
      (acc.1, acc.2.push num)
  ) (negPart, nonNegPart)
  
  let negPart := parts.1
  let nonNegPart := parts.2
  
  -- Square both parts
  let negSquared := squareArray negPart.reverse
  let nonNegSquared := squareArray nonNegPart
  
  -- Merge the two sorted arrays
  mergeSorted negSquared nonNegSquared
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Checks if an array contains the squares of another array's elements -/
def IsSquareOf (original : Array Int) (squared : Array Int) : Prop :=
  original.size = squared.size ∧
  ∀ i : Nat, i < original.size → squared[i]! = original[i]! * original[i]!

-- Postcondition definitions
@[reducible, simp]
def sortedSquares_postcond (nums : Array Int) (result: Array Int) (h_precond : sortedSquares_precond nums) : Prop :=
  -- !benchmark @start postcond
  IsSorted result ∧ IsSquareOf nums result
  -- !benchmark @end postcond


-- Proof content
theorem sortedSquares_postcond_satisfied (nums: Array Int) (h_precond : sortedSquares_precond nums) :
    sortedSquares_postcond nums (sortedSquares nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_512_leetcode_977