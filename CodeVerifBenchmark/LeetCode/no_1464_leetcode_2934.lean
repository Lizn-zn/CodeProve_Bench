import Mathlib

namespace no_1464_leetcode_2934


-- Precondition auxiliary definitions
def maxList (l : List Nat) : Nat :=
  match l with
  | [] => 0
  | x :: xs => Nat.max x (maxList xs)

-- Check whether we can make last element maximum by swapping indices
-- Two cases:
-- Case 1: Do not swap the last element
-- Case 2: Swap the last element
def checkFeasibility (nums1 nums2 : List Nat) : Bool :=
  let n := nums1.length
  if n ≠ nums2.length then false else
  let max1 := maxList nums1
  let max2 := maxList nums2
  let last1 := nums1.getLast!
  let last2 := nums2.getLast!

  -- Feasibility without swapping the last elements
  let feasibleWithoutSwap : Bool :=
    (last1 == max1 ∧ last2 == max2) ∧
      (List.all (List.range (n-1)) (fun i => nums1.get! i ≤ last1 ∧ nums2.get! i ≤ last2))

  -- Feasibility with swapping the last elements
  let feasibleWithSwap : Bool :=
    let newLast1 := last2
    let newLast2 := last1
    (newLast1 == max1 ∨ newLast1 == max2) ∧ (newLast2 == max1 ∨ newLast2 == max2) ∧
      (List.all (List.range n) (fun i =>
          let v1 := nums1.get! i
          let v2 := nums2.get! i
          (if i < n - 1 then (v1 ≤ newLast1 ∧ v2 ≤ newLast2) ∨ (v2 ≤ newLast1 ∧ v1 ≤ newLast2) else True)
        ))

  feasibleWithoutSwap || feasibleWithSwap

-- Precondition definitions
@[reducible, simp]
def minOperationsToSatisfyConditions_precond (nums1 : List Nat) (nums2 : List Nat) : Prop :=
  -- !benchmark @start precond
  nums1.length = nums2.length ∧ nums1.length > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
def maxList_code (l : List Nat) : Nat :=
  match l with
  | [] => 0
  | x :: xs => Nat.max x (maxList_code xs)

def countSwapsRequired (nums1 nums2 : List Nat) : Option Nat :=
  let n := nums1.length
  if n = 0 then none else
  let max1 := maxList_code nums1
  let max2 := maxList_code nums2
  let last1 := nums1.getLast!
  let last2 := nums2.getLast!

  -- Count swaps needed without swapping the last element
  let countWithoutSwap : Option Nat :=
    if last1 = max1 ∧ last2 = max2 ∧
       List.all (List.range (n-1)) (fun i => nums1.get! i ≤ last1 ∧ nums2.get! i ≤ last2)
    then some 0 else none

  -- Count swaps needed with swapping the last element
  let countWithSwap : Option Nat :=
    let newLast1 := last2
    let newLast2 := last1
    if (newLast1 = max1 ∨ newLast1 = max2) ∧ (newLast2 = max1 ∨ newLast2 = max2) ∧
       List.all (List.range n) (fun i =>
           let v1 := nums1.get! i
           let v2 := nums2.get! i
           (if i < n - 1 then (v1 ≤ newLast1 ∧ v2 ≤ newLast2) ∨ (v2 ≤ newLast1 ∧ v1 ≤ newLast2) else True)
         )
    then
      let swaps := List.foldr (fun i acc =>
        let v1 := nums1.get! i
        let v2 := nums2.get! i
        if i < n - 1 ∧ ¬(v1 ≤ newLast1 ∧ v2 ≤ newLast2) then acc + 1 else acc
      ) 0 (List.range (n-1))
      some (swaps + 1) -- +1 for final swap
    else none

  match countWithoutSwap, countWithSwap with
  | some c1, some c2 => some (Nat.min c1 c2)
  | some c1, none => some c1
  | none, some c2 => some c2
  | none, none => none

-- Main function definitions
def minOperationsToSatisfyConditions (nums1 : List Nat) (nums2 : List Nat) (h_precond : minOperationsToSatisfyConditions_precond (nums1) (nums2)) : Int :=
  -- !benchmark @start code
  match countSwapsRequired nums1 nums2 with
    | some k => Int.ofNat k
    | none => -1
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def maxList_post (l : List Nat) : Nat :=
  match l with
  | [] => 0
  | x :: xs => Nat.max x (maxList_post xs)

def countSwapsRequired_post (nums1 nums2 : List Nat) : Option Nat :=
  let n := nums1.length
  let max1 := maxList_post nums1
  let max2 := maxList_post nums2
  let last1 := nums1.getLast!
  let last2 := nums2.getLast!

  -- Count swaps needed to make last elements the maximums
  let countWithoutSwap : Option Nat :=
    if last1 == max1 ∧ last2 == max2 ∧
       List.all (List.range (n-1)) (fun i => nums1.get! i ≤ last1 ∧ nums2.get! i ≤ last2)
    then some 0 else none

  let countWithSwap : Option Nat :=
    let newLast1 := last2
    let newLast2 := last1
    if (newLast1 == max1 ∨ newLast1 == max2) ∧ (newLast2 == max1 ∨ newLast2 == max2) ∧
       List.all (List.range n) (fun i =>
           let v1 := nums1.get! i
           let v2 := nums2.get! i
           (if i < n - 1 then (v1 ≤ newLast1 ∧ v2 ≤ newLast2) ∨ (v2 ≤ newLast1 ∧ v1 ≤ newLast2) else True)
         )
    then
      let swaps := List.foldr (fun i acc =>
        let v1 := nums1.get! i
        let v2 := nums2.get! i
        if i < n - 1 ∧ ¬(v1 ≤ newLast1 ∧ v2 ≤ newLast2) then acc + 1 else acc
      ) 0 (List.range (n-1))
      some (swaps + 1) -- +1 for final swap
    else none

  match countWithoutSwap, countWithSwap with
  | some c1, some c2 => some (Nat.min c1 c2)
  | some c1, none => some c1
  | none, some c2 => some c2
  | none, none => none

-- Postcondition definitions
@[reducible, simp]
def minOperationsToSatisfyConditions_postcond (nums1 : List Nat) (nums2 : List Nat) (result: Int) (h_precond : minOperationsToSatisfyConditions_precond (nums1) (nums2)) : Prop :=
  -- !benchmark @start postcond
  let computed := countSwapsRequired_post nums1 nums2
  match computed with
  | some k => result = Int.ofNat k
  | none => result = -1
  -- !benchmark @end postcond


-- Proof content
theorem minOperationsToSatisfyConditions_postcond_satisfied (nums1: List Nat) (nums2: List Nat) (h_precond : minOperationsToSatisfyConditions_precond (nums1) (nums2)) :
    minOperationsToSatisfyConditions_postcond (nums1) (nums2) (minOperationsToSatisfyConditions (nums1) (nums2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1464_leetcode_2934