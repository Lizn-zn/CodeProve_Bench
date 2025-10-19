import Mathlib

-- Precondition definitions
@[reducible, simp]
def findKthSmallest_precond (n : Nat) (k : Nat) (operations : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  -- n matches the length of operations
    operations.length = n ∧
    -- k is at least 1
    k ≥ 1 ∧
    -- k is at most the total count of all integers
    k ≤ (operations.map (·.2)).sum ∧
    -- all values and counts are positive
    operations.all (fun (a, b) => a ≥ 1 ∧ b ≥ 1)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to merge counts for the same value
def mergeCounts (operations : List (Nat × Nat)) : List (Nat × Nat) :=
  let grouped := operations.foldl (fun acc (a, b) =>
    match acc.find? (fun (x, _) => x == a) with
    | some (_, oldCount) => 
        let filtered := acc.filter (fun (x, _) => x != a)
        filtered ++ [(a, oldCount + b)]
    | none => acc ++ [(a, b)]
  ) []
  grouped.mergeSort (fun (a1, _) (a2, _) => a1 ≤ a2)

-- Helper function to find k-th element by iterating through sorted pairs
def findKthInSorted (sortedPairs : List (Nat × Nat)) (k : Nat) : Nat :=
  match sortedPairs with
  | [] => 0  -- should not happen given preconditions
  | (a, b) :: rest =>
      if k ≤ b then a
      else findKthInSorted rest (k - b)

-- Main function definitions
def findKthSmallest (n : Nat) (k : Nat) (operations : List (Nat × Nat)) (h_precond : findKthSmallest_precond (n) (k) (operations)) : Nat :=
  -- !benchmark @start code
  let merged := mergeCounts operations
  findKthInSorted merged k
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Construct the full array from operations
def constructArray (operations : List (Nat × Nat)) : List Nat :=
  operations.flatMap (fun (a, b) => List.replicate b a)

-- Get the k-th smallest element (1-indexed) from a sorted list
def kthSmallest (arr : List Nat) (k : Nat) : Option Nat :=
  let sorted := arr.mergeSort (· ≤ ·)
  sorted.get? (k - 1)

-- Postcondition definitions
@[reducible, simp]
def findKthSmallest_postcond (n : Nat) (k : Nat) (operations : List (Nat × Nat)) (result: Nat) (h_precond : findKthSmallest_precond (n) (k) (operations)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the k-th smallest element in the constructed array
    let arr := constructArray operations
    kthSmallest arr k = some result
  -- !benchmark @end postcond


-- Proof content
theorem findKthSmallest_postcond_satisfied (n: Nat) (k: Nat) (operations: List (Nat × Nat)) (h_precond : findKthSmallest_precond (n) (k) (operations)) :
    findKthSmallest_postcond (n) (k) (operations) (findKthSmallest (n) (k) (operations) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof