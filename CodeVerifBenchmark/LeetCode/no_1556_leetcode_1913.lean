import Mathlib

namespace no_1556_leetcode_1913


-- Precondition auxiliary definitions
/-- A helper function to compute the product difference of two pairs of numbers -/
def productDifference (a b c d : Nat) : Int :=
  (a * b) - (c * d)

/-- Checks if four indices are pairwise distinct -/
def pairwiseDistinct (w x y z : Nat) : Bool :=
  w ≠ x && w ≠ y && w ≠ z && x ≠ y && x ≠ z && y ≠ z

/-- Computes all valid combinations of 4 distinct indices from a list of length n -/
def validIndexCombinations (n : Nat) : List (Nat × Nat × Nat × Nat) :=
  let indices := List.range n
  indices.flatMap fun w =>
  indices.flatMap fun x =>
  indices.flatMap fun y =>
  indices.flatMap fun z =>
    if pairwiseDistinct w x y z then
      [(w, x, y, z)]
    else
      []

/-- Computes the maximum product difference over all valid index combinations -/
def maxProductDiffValue (nums : List Nat) : Int :=
  let len := nums.length
  let combinations := validIndexCombinations len
  let values := combinations.map (fun (w, x, y, z) => 
    productDifference (nums.get! w) (nums.get! x) (nums.get! y) (nums.get! z))
  match List.max? values with
  | some m => m
  | none => 0

-- Precondition definitions
@[reducible, simp]
def maxProductDifference_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  nums.length ≥ 4
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Sorts a list of natural numbers in ascending order -/
def sortList (l : List Nat) : List Nat :=
  l.mergeSort (· ≤ ·)

/-- Gets the first two elements from a list -/
def firstTwo (l : List Nat) : Nat × Nat :=
  match l with
  | a :: b :: _ => (a, b)
  | _ => (0, 0)  -- This case shouldn't occur due to precondition

/-- Gets the last two elements from a list -/
def lastTwo (l : List Nat) : Nat × Nat :=
  let sorted := sortList l
  let len := sorted.length
  if len ≥ 2 then
    (sorted.get! (len - 2), sorted.get! (len - 1))
  else
    (0, 0)  -- This case shouldn't occur due to precondition

-- Main function definitions
def maxProductDifference (nums : List Nat) (h_precond : maxProductDifference_precond (nums)) : Nat :=
  -- !benchmark @start code
  let sortedNums := sortList nums
  let (min1, min2) := firstTwo sortedNums
  let (max2, max1) := lastTwo sortedNums
  let maxProduct := max1 * max2
  let minProduct := min1 * min2
  maxProduct - minProduct
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def maxProductDifference_postcond (nums : List Nat) (result: Nat) (h_precond : maxProductDifference_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result = (maxProductDiffValue nums).toNat
  -- !benchmark @end postcond


-- Proof content
theorem maxProductDifference_postcond_satisfied (nums: List Nat) (h_precond : maxProductDifference_precond (nums)) :
    maxProductDifference_postcond (nums) (maxProductDifference (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1556_leetcode_1913