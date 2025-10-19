import Mathlib

-- Precondition auxiliary definitions
/-- Checks if an array is sorted in ascending order -/
def IsSorted (arr : Array Int) : Prop :=
  ∀ (i j : Nat), i < j → j < arr.size → arr[i]! ≤ arr[j]!

/-- Checks if two arrays are permutations of each other -/
def IsPermutation (arr1 arr2 : Array Int) : Prop :=
  arr1.size = arr2.size ∧
  ∀ (x : Int), (arr1.extract 0 arr1.size).count x = (arr2.extract 0 arr2.size).count x

-- Precondition definitions
@[reducible, simp]
def sortArray_precond (nums : Array Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Merges two sorted arrays into one sorted array -/
def merge (left right : Array Int) : Array Int := Id.run do
  let mut result := #[]
  let mut i := 0
  let mut j := 0

  while i < left.size && j < right.size do
    if left[i]! ≤ right[j]! then
      result := result.push left[i]!
      i := i + 1
    else
      result := result.push right[j]!
      j := j + 1

  -- Append remaining elements from left
  while i < left.size do
    result := result.push left[i]!
    i := i + 1

  -- Append remaining elements from right
  while j < right.size do
    result := result.push right[j]!
    j := j + 1

  result

/-- Sorts an array using merge sort -/
def mergeSort (arr : Array Int) : Array Int :=
  if arr.size ≤ 1 then
    arr
  else
    let mid := arr.size / 2
    let left := arr.extract 0 mid
    let right := arr.extract mid arr.size
    let sortedLeft := mergeSort left
    let sortedRight := mergeSort right
    merge sortedLeft sortedRight

-- Main function definitions
def sortArray (nums : Array Int) (h_precond : sortArray_precond (nums)) : Array Int :=
  -- !benchmark @start code
  mergeSort nums
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def sortArray_postcond (nums : Array Int) (result: Array Int) (h_precond : sortArray_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  IsSorted result ∧ IsPermutation nums result
  -- !benchmark @end postcond


-- Proof content
theorem sortArray_postcond_satisfied (nums: Array Int) (h_precond : sortArray_precond (nums)) :
    sortArray_postcond (nums) (sortArray (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

