import Mathlib

-- Precondition auxiliary definitions
def isValidPairing (nums : List Nat) (p : Nat) (pairs : List (Nat × Nat)) : Prop :=
  let indices := pairs.flatMap (fun (i, j) => [i, j])
  (pairs.length = p) ∧
  (pairs.all (fun (i, j) => i < nums.length ∧ j < nums.length ∧ i ≠ j)) ∧
  (indices.Nodup) ∧
  (pairs.all (fun (i, j) => i < j))

def maxDifference (nums : List Nat) (pairs : List (Nat × Nat)) : Nat :=
  if pairs = [] then 0
  else
    let diffs := pairs.map (fun (i, j) => Int.natAbs (Int.ofNat (nums.get ⟨i, by sorry⟩) - Int.ofNat (nums.get ⟨j, by sorry⟩)))
    diffs.foldl max 0

-- Precondition definitions
@[reducible, simp]
def minimizeMax_precond (nums : List Nat) (p : Nat) : Prop :=
  -- !benchmark @start precond
  0 ≤ p ∧ p ≤ nums.length / 2
  -- !benchmark @end precond


-- Code auxiliary definitions
def countPairs (sortedNums : List Nat) (maxDiff : Nat) : Nat :=
  let rec go (lst : List Nat) (count : Nat) : Nat :=
    match lst with
    | [] => count
    | [_] => count
    | a :: b :: rest =>
      if b - a ≤ maxDiff then
        go rest (count + 1)
      else
        go (b :: rest) count
  go sortedNums 0

def sortedNums (nums : List Nat) : List Nat :=
  List.mergeSort nums

-- Main function definitions
def minimizeMax (nums : List Nat) (p : Nat) (h_precond : minimizeMax_precond (nums) (p)) : Nat :=
  -- !benchmark @start code
  let sorted := sortedNums nums
  let len := sorted.length
  
  if p = 0 ∨ len = 0 then
    0
  else
    let rec binarySearch (low : Nat) (high : Nat) : Nat :=
      if low ≥ high then
        low
      else
        let mid := (low + high) / 2
        let pairs := countPairs sorted mid
        if pairs ≥ p then
          binarySearch low mid
        else
          binarySearch (mid + 1) high
    
    let maxPossibleDiff := 
      match sorted.getLast? with
      | some lastVal =>
        match sorted.head? with
        | some firstVal => lastVal - firstVal
        | none => 0
      | none => 0
    
    binarySearch 0 (maxPossibleDiff + 1)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- No auxiliary definitions needed for postcondition

-- Postcondition definitions
@[reducible, simp]
def minimizeMax_postcond (nums : List Nat) (p : Nat) (result: Nat) (h_precond : minimizeMax_precond (nums) (p)) : Prop :=
  -- !benchmark @start postcond
  ∀ (pairs : List (Nat × Nat)), 
    (isValidPairing nums p pairs → maxDifference nums pairs ≥ result) ∧
    (∃ pairs', isValidPairing nums p pairs' ∧ maxDifference nums pairs' = result)
  -- !benchmark @end postcond


-- Proof content
theorem minimizeMax_postcond_satisfied (nums: List Nat) (p: Nat) (h_precond : minimizeMax_precond (nums) (p)) :
    minimizeMax_postcond (nums) (p) (minimizeMax (nums) (p) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof