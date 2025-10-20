import Mathlib

namespace no_1416_p02272


-- Precondition definitions
@[reducible, simp]
def mergeSort_precond (arr : Array Nat) (left : Nat) (right : Nat) : Prop :=
  -- !benchmark @start precond
  left ≤ right ∧ right ≤ arr.size
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Sentinel value (larger than any element in the problem: 10^9 + 1)
def SENTINEL : Nat := 1000000001

-- Merge function that merges two sorted subarrays
def merge (arr : Array Nat) (left : Nat) (mid : Nat) (right : Nat) : Array Nat × Nat :=
  let n1 := mid - left
  let n2 := right - mid
  
  -- Create L array with sentinel
  let L := (List.range n1).foldl (fun acc i => acc.push arr[left + i]!) #[] |>.push SENTINEL
  
  -- Create R array with sentinel
  let R := (List.range n2).foldl (fun acc i => acc.push arr[mid + i]!) #[] |>.push SENTINEL
  
  -- Merge back into arr
  let (finalArr, _, _) := (List.range (right - left)).foldl 
    (fun (state : Array Nat × Nat × Nat) k =>
      let (currArr, i, j) := state
      if L[i]! ≤ R[j]! then
        (currArr.set! (left + k) L[i]!, i + 1, j)
      else
        (currArr.set! (left + k) R[j]!, i, j + 1))
    (arr, 0, 0)
  
  (finalArr, right - left)

-- Helper function for merge sort recursion
partial def mergeSortAux (arr : Array Nat) (left : Nat) (right : Nat) : Array Nat × Nat :=
  if left + 1 < right then
    let mid := (left + right) / 2
    let (arr1, count1) := mergeSortAux arr left mid
    let (arr2, count2) := mergeSortAux arr1 mid right
    let (arr3, count3) := merge arr2 left mid right
    (arr3, count1 + count2 + count3)
  else
    (arr, 0)

-- Main function definitions
def mergeSort (arr : Array Nat) (left : Nat) (right : Nat) (h_precond : mergeSort_precond (arr) (left) (right)) : Array Nat × Nat :=
  -- !benchmark @start code
  mergeSortAux arr left right
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper to check if a subarray is sorted
def isSortedBetween (arr : Array Nat) (left : Nat) (right : Nat) : Prop :=
  ∀ i j, left ≤ i → i < j → j < right → arr[i]! ≤ arr[j]!

-- Helper to check if two arrays are permutations of each other in a range
def isPermutationBetween (arr1 arr2 : Array Nat) (left : Nat) (right : Nat) : Prop :=
  ∀ v, (arr1.toList.drop left |>.take (right - left)).count v = 
       (arr2.toList.drop left |>.take (right - left)).count v

-- Helper to check if elements outside the range are unchanged
def unchangedOutside (arr1 arr2 : Array Nat) (left : Nat) (right : Nat) : Prop :=
  (∀ i, i < left → arr1[i]! = arr2[i]!) ∧ 
  (∀ i, right ≤ i → i < arr1.size → arr1[i]! = arr2[i]!)

-- Helper to count comparisons for merge sort
-- The number of comparisons in merge is (right - left)
-- Total comparisons = sum of all merge operations
def mergeComparisonCount (left : Nat) (right : Nat) : Nat :=
  if right - left ≤ 1 then 0
  else
    let mid := (left + right) / 2
    mergeComparisonCount left mid + 
    mergeComparisonCount mid right + 
    (right - left)

-- Postcondition definitions
@[reducible, simp]
def mergeSort_postcond (arr : Array Nat) (left : Nat) (right : Nat) (result: Array Nat × Nat) (h_precond : mergeSort_precond (arr) (left) (right)) : Prop :=
  -- !benchmark @start postcond
  let (sortedArr, compCount) := result
  -- The result array has the same size as input
  sortedArr.size = arr.size ∧
  -- The subarray from left to right is sorted
  isSortedBetween sortedArr left right ∧
  -- The subarray from left to right is a permutation of the original
  isPermutationBetween arr sortedArr left right ∧
  -- Elements outside [left, right) are unchanged
  unchangedOutside arr sortedArr left right ∧
  -- The comparison count matches the expected number for merge sort
  compCount = mergeComparisonCount left right
  -- !benchmark @end postcond


-- Proof content
theorem mergeSort_postcond_satisfied (arr: Array Nat) (left: Nat) (right: Nat) (h_precond : mergeSort_precond (arr) (left) (right)) :
    mergeSort_postcond (arr) (left) (right) (mergeSort (arr) (left) (right) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1416_p02272