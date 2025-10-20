import Mathlib

namespace no_2749_leetcode_3366


-- Precondition auxiliary definitions
/-- `div2RoundUp n` divides `n` by 2, rounding up. -/
def div2RoundUp (n : Nat) : Nat :=
  (n + 1) / 2

/-- `applyOp1 nums i` applies operation 1 (div2RoundUp) to the element at index `i` of `nums`. -/
def applyOp1 (nums : List Nat) (i : Nat) : List Nat :=
  if h : i < nums.length then
    nums.set i (div2RoundUp (nums.get ⟨i, h⟩))
  else
    nums

/-- `applyOp2 nums i k` applies operation 2 (subtract `k`) to the element at index `i` of `nums`, if `nums[i] >= k`. -/
def applyOp2 (nums : List Nat) (i : Nat) (k : Nat) : List Nat :=
  if h : i < nums.length then
    let val := nums.get ⟨i, h⟩
    if val ≥ k then nums.set i (val - k) else nums
  else
    nums

/-- `isValidOp1Selection indices numsLen op1` checks if the selected indices for op1 are valid:
    - All indices are within bounds (0 <= i < numsLen)
    - All indices are distinct
    - The number of indices is at most op1 -/
def isValidOp1Selection (indices : List Nat) (numsLen : Nat) (op1 : Nat) : Prop :=
  indices.length ≤ op1 ∧
  indices.all (fun i => i < numsLen) ∧
  indices.Nodup

/-- `isValidOp2Selection indices nums k op2` checks if the selected indices for op2 are valid:
    - All indices are within bounds (0 <= i < nums.length)
    - All indices are distinct
    - The number of indices is at most op2
    - For each selected index i, nums[i] >= k -/
def isValidOp2Selection (indices : List Nat) (nums : List Nat) (k : Nat) (op2 : Nat) : Prop :=
  indices.length ≤ op2 ∧
  indices.all (fun i => i < nums.length) ∧
  indices.Nodup ∧
  indices.all (fun i => if h : i < nums.length then (nums.get ⟨i, h⟩) ≥ k else False)

/-- `applyOp1Sequence nums indices` applies operation 1 to the elements at the given indices in sequence.
    Assumes indices are valid and distinct. -/
def applyOp1Sequence (nums : List Nat) (indices : List Nat) : List Nat :=
  indices.foldl applyOp1 nums

/-- `applyOp2Sequence nums indices k` applies operation 2 to the elements at the given indices in sequence.
    Assumes indices are valid and distinct. -/
def applyOp2Sequence (nums : List Nat) (indices : List Nat) (k : Nat) : List Nat :=
  indices.foldl (fun acc i => applyOp2 acc i k) nums

/-- `disjointSelections indices1 indices2` checks if two lists of indices have no elements in common. -/
def disjointSelections (indices1 indices2 : List Nat) : Prop :=
  indices1.all (fun i => ¬ indices2.contains i)

/-- `sumOfList nums` computes the sum of all elements in the list. -/
def sumOfList (nums : List Nat) : Nat :=
  nums.foldl (· + ·) 0

-- Precondition definitions
@[reducible, simp]
def minArraySum_precond (nums : List Nat) (k : Nat) (op1 : Nat) (op2 : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Generate all subsets of a list with a given maximum length. -/
def subsetsWithMaxLength (maxLen : Nat) (lst : List Nat) : List (List Nat) :=
  lst.sublists.filter (fun s => s.length ≤ maxLen)

/-- Check if a list of natural numbers is a valid selection for op1. -/
def checkOp1Selection (indices : List Nat) (numsLen : Nat) (op1 : Nat) : Bool :=
  indices.length ≤ op1 &&
  indices.all (fun i => i < numsLen) &&
  indices.Nodup

/-- Check if a list of natural numbers is a valid selection for op2. -/
def checkOp2Selection (indices : List Nat) (nums : List Nat) (k : Nat) (op2 : Nat) : Bool :=
  indices.length ≤ op2 &&
  indices.all (fun i => i < nums.length) &&
  indices.Nodup &&
  indices.all (fun i => if h : i < nums.length then (nums.get ⟨i, h⟩) ≥ k else False)

/-- Compute all valid combinations of op1 and op2 selections. -/
def computeValidCombinations (nums : List Nat) (k : Nat) (op1 : Nat) (op2 : Nat) : List (List Nat × List Nat) :=
  let indices := List.range nums.length
  let op1Choices := subsetsWithMaxLength op1 indices
  let op2Choices := subsetsWithMaxLength op2 indices
  let validOp1 := op1Choices.filter (fun s => checkOp1Selection s nums.length op1)
  let validOp2 := op2Choices.filter (fun s => checkOp2Selection s nums k op2)
  validOp1.flatMap (fun op1Sel =>
    (validOp2.filter (fun op2Sel => op1Sel.all (fun i => ¬ op2Sel.contains i))).map (fun op2Sel => (op1Sel, op2Sel)))

-- Main function definitions
def minArraySum (nums : List Nat) (k : Nat) (op1 : Nat) (op2 : Nat) (h_precond : minArraySum_precond (nums) (k) (op1) (op2)) : Nat :=
  -- !benchmark @start code
  let combinations := computeValidCombinations nums k op1 op2
  let sums := combinations.map (fun (op1Sel, op2Sel) =>
    sumOfList (applyOp2Sequence (applyOp1Sequence nums op1Sel) op2Sel k))
  if sums.isEmpty then 0 else sums.foldl min sums.head!
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- `existsValidSequence` expresses that there exist valid sequences of indices for op1 and op2
    such that applying them results in the given `result` sum. -/
def existsValidSequence (nums : List Nat) (k : Nat) (op1 : Nat) (op2 : Nat) (result : Nat) : Prop :=
  ∃ (op1Indices op2Indices : List Nat),
    isValidOp1Selection op1Indices nums.length op1 ∧
    isValidOp2Selection op2Indices nums k op2 ∧
    disjointSelections op1Indices op2Indices ∧
    sumOfList (applyOp2Sequence (applyOp1Sequence nums op1Indices) op2Indices k) = result

/-- `isMinimumSum` expresses that the `result` is the minimum possible sum achievable by any valid sequence of operations. -/
def isMinimumSum (nums : List Nat) (k : Nat) (op1 : Nat) (op2 : Nat) (result : Nat) : Prop :=
  existsValidSequence nums k op1 op2 result ∧
  ∀ (otherResult : Nat),
    existsValidSequence nums k op1 op2 otherResult →
    result ≤ otherResult

-- Postcondition definitions
@[reducible, simp]
def minArraySum_postcond (nums : List Nat) (k : Nat) (op1 : Nat) (op2 : Nat) (result: Nat) (h_precond : minArraySum_precond (nums) (k) (op1) (op2)) : Prop :=
  -- !benchmark @start postcond
  isMinimumSum nums k op1 op2 result
  -- !benchmark @end postcond


-- Proof content
theorem minArraySum_postcond_satisfied (nums: List Nat) (k: Nat) (op1: Nat) (op2: Nat) (h_precond : minArraySum_precond (nums) (k) (op1) (op2)) :
    minArraySum_postcond (nums) (k) (op1) (op2) (minArraySum (nums) (k) (op1) (op2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2749_leetcode_3366