import Mathlib

namespace no_1128_leetcode_2263


-- Precondition auxiliary definitions
def IsNonDecreasing (lst : List Nat) : Prop :=
  ∀ i j : Fin lst.length, i < j → lst.get i ≤ lst.get j

def IsNonIncreasing (lst : List Nat) : Prop :=
  ∀ i j : Fin lst.length, i < j → lst.get i ≥ lst.get j

def operationsToMakeMonotonic (original target : List Nat) : Nat :=
  (List.zipWith (fun a b => Nat.dist a b) original target).sum

-- !benchmark @end precond_aux

-- Precondition definitions
@[reducible, simp]
def minOperationsToMonotonic_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Convert a list to an array for efficient random access -/
def listToByteArray (lst : List Nat) : Array Nat :=
  lst.toArray

/-- Convert an array back to a list -/
def byteArrayToList (arr : Array Nat) : List Nat :=
  arr.toList

/-- Calculate the cost to convert the original list to the target list -/
def cost (original target : List Nat) : Nat :=
  (List.zipWith (fun a b => Nat.dist a b) original target).sum

/-- Generate all non-decreasing sequences with the same length as the input list -/
partial def generateNonDecreasingSequences (lst : List Nat) (maxVal : Nat) : List (List Nat) :=
  let n := lst.length
  if n = 0 then
    [[]]
  else
    let prevSequences := generateNonDecreasingSequences (lst.drop 1) maxVal
    let result := Id.run do
      let mut acc : List (List Nat) := []
      for prev in prevSequences do
        for val in [0:maxVal+1] do
          if prev.isEmpty ∨ val ≤ prev.head! then
            acc := (val :: prev) :: acc
      return acc
    result

/-- Generate all non-increasing sequences with the same length as the input list -/
partial def generateNonIncreasingSequences (lst : List Nat) (maxVal : Nat) : List (List Nat) :=
  let n := lst.length
  if n = 0 then
    [[]]
  else
    let prevSequences := generateNonIncreasingSequences (lst.drop 1) maxVal
    let result := Id.run do
      let mut acc : List (List Nat) := []
      for prev in prevSequences do
        for val in [0:maxVal+1] do
          if prev.isEmpty ∨ val ≥ prev.head! then
            acc := (val :: prev) :: acc
      return acc
    result

/-- Find the maximum value in a list -/
def maxValInList (lst : List Nat) : Nat :=
  match lst with
  | [] => 0
  | hd :: tl =>
    let maxRest := maxValInList tl
    if hd > maxRest then hd else maxRest

-- Main function definitions
def minOperationsToMonotonic (nums : List Nat) (h_precond : minOperationsToMonotonic_precond (nums)) : Nat :=
  -- !benchmark @start code
  let maxVal := maxValInList nums
  let nonDecreasingTargets := generateNonDecreasingSequences nums maxVal
  let nonIncreasingTargets := generateNonIncreasingSequences nums maxVal
  let allTargets := nonDecreasingTargets ++ nonIncreasingTargets
  let costs := allTargets.map (cost nums ·)
  match costs with
  | [] => 0
  | hd :: tl => (hd :: tl).foldl min hd
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- !benchmark @end postcond_aux

-- Postcondition definitions
@[reducible, simp]
def minOperationsToMonotonic_postcond (nums : List Nat) (result: Nat) (h_precond : minOperationsToMonotonic_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  ∃ target : List Nat,
    (IsNonDecreasing target ∨ IsNonIncreasing target) ∧
    target.length = nums.length ∧
    result = operationsToMakeMonotonic nums target ∧
    ∀ otherTarget : List Nat,
      (IsNonDecreasing otherTarget ∨ IsNonIncreasing otherTarget) →
      otherTarget.length = nums.length →
      operationsToMakeMonotonic nums otherTarget ≥ result
  -- !benchmark @end postcond
  -- !benchmark @end postcond


-- Proof content
theorem minOperationsToMonotonic_postcond_satisfied (nums: List Nat) (h_precond : minOperationsToMonotonic_precond (nums)) :
    minOperationsToMonotonic_postcond (nums) (minOperationsToMonotonic (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1128_leetcode_2263