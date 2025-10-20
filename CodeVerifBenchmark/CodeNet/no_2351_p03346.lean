import Mathlib

namespace no_2351_p03346


-- Precondition definitions
@[reducible, simp]
def minOperationsToSort_precond (n : Nat) (p : List Nat) : Prop :=
  -- !benchmark @start precond
  -- n is positive and p is a permutation of 1 through n
  n > 0 ∧ p.length = n ∧ (∀ i ∈ List.range n, (i + 1) ∈ p) ∧ p.Nodup
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to find the longest increasing subsequence of indices
def findLongestIncreasingIndexSubseq (p : List Nat) : Nat :=
  let indexed := p.enum.map (fun (i, v) => (v, i))
  let sorted := indexed.mergeSort (fun a b => a.1 ≤ b.1)
  let indices := sorted.map (fun (_, i) => i)
  
  let rec helper (l : List Nat) (lastIdx : Int) (currentLen : Nat) (maxLen : Nat) : Nat :=
    match l with
    | [] => max currentLen maxLen
    | idx :: rest =>
      if lastIdx < 0 || idx > lastIdx.toNat then
        helper rest idx (currentLen + 1) (max (currentLen + 1) maxLen)
      else
        helper rest idx 1 (max currentLen maxLen)
  
  match indices with
  | [] => 0
  | first :: rest => helper rest first 1 1

-- Main function definitions
def minOperationsToSort (n : Nat) (p : List Nat) (h_precond : minOperationsToSort_precond (n) (p)) : Nat :=
  -- !benchmark @start code
  let longestSeq := findLongestIncreasingIndexSubseq p
  n - longestSeq
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if a list is sorted
def isSorted (l : List Nat) : Prop :=
  ∀ i j, i < j → j < l.length → l[i]! ≤ l[j]!

-- Helper function to represent moving an element to the beginning or end
-- A sequence of operations transforms p into a sorted sequence
def canSortWithOperations (p : List Nat) (numOps : Nat) : Prop :=
  ∃ (ops : List (Nat × Bool)), -- (index, toBeginning) where Bool indicates move to beginning (true) or end (false)
    ops.length = numOps ∧
    ∃ (final : List Nat),
      isSorted final ∧
      final.length = p.length ∧
      (∀ x, x ∈ p ↔ x ∈ final)

-- Find the length of the longest increasing subsequence of indices
-- when the permutation is sorted by value
def longestIncreasingIndexSubseq (p : List Nat) : Nat :=
  let indexed := p.enum.map (fun (i, v) => (v, i))
  let sorted := indexed.mergeSort (fun a b => a.1 ≤ b.1)
  let indices := sorted.map (fun (_, i) => i)
  -- Find longest strictly increasing subsequence in indices
  let rec helper (l : List Nat) (lastIdx : Nat) (currentLen : Nat) (maxLen : Nat) : Nat :=
    match l with
    | [] => max currentLen maxLen
    | idx :: rest =>
      if idx > lastIdx then
        helper rest idx (currentLen + 1) (max (currentLen + 1) maxLen)
      else
        helper rest idx 1 (max currentLen maxLen)
  match indices with
  | [] => 0
  | first :: rest => helper rest first 1 1

-- Postcondition definitions
@[reducible, simp]
def minOperationsToSort_postcond (n : Nat) (p : List Nat) (result: Nat) (h_precond : minOperationsToSort_precond (n) (p)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the minimum number of operations needed to sort p
  -- Key insight: elements that are already in increasing order by their original indices
  -- (when sorted by value) don't need to be moved
  -- So minimum operations = n - length of longest such subsequence
  result = n - longestIncreasingIndexSubseq p ∧
  canSortWithOperations p result ∧
  (∀ k < result, ¬canSortWithOperations p k)
  -- !benchmark @end postcond


-- Proof content
theorem minOperationsToSort_postcond_satisfied (n: Nat) (p: List Nat) (h_precond : minOperationsToSort_precond (n) (p)) :
    minOperationsToSort_postcond (n) (p) (minOperationsToSort (n) (p) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2351_p03346