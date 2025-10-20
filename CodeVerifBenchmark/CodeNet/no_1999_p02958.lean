import Mathlib

namespace no_1999_p02958


-- Precondition auxiliary definitions
-- Helper function to check if a list is a permutation of {1, 2, ..., n}
def isPermutation (n : Nat) (p : List Nat) : Prop :=
  p.length = n ∧ (∀ i, 1 ≤ i ∧ i ≤ n → i ∈ p) ∧ p.Nodup

-- Precondition definitions
@[reducible, simp]
def canSortWithOneSwap_precond (n : Nat) (p : List Nat) : Prop :=
  -- !benchmark @start precond
  -- The input must be a valid permutation of {1, 2, ..., n}
    n ≥ 2 ∧ isPermutation n p
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Count how many positions differ from the sorted permutation
def countDifferences (p : List Nat) : Nat :=
  let sorted := List.range p.length |>.map (· + 1)
  (List.zip p sorted).foldl (fun acc (x, y) => if x ≠ y then acc + 1 else acc) 0

-- Main function definitions
def canSortWithOneSwap (n : Nat) (p : List Nat) (h_precond : canSortWithOneSwap_precond (n) (p)) : String :=
  -- !benchmark @start code
  -- Count the number of positions where p differs from the sorted sequence [1, 2, ..., n]
    let cnt := countDifferences p
    -- If at most 2 positions differ, we can sort with at most one swap
    if cnt ≤ 2 then "YES" else "NO"
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to swap two elements at positions i and j in a list
def swapAt (p : List Nat) (i j : Nat) : List Nat :=
  if i < p.length ∧ j < p.length then
    let vi := p[i]!
    let vj := p[j]!
    (p.set i vj).set j vi
  else
    p

-- Helper function to check if a list is sorted in ascending order
def isSorted (p : List Nat) : Prop :=
  ∀ i j, i < j → j < p.length → p[i]! < p[j]!

-- Helper function to check if we can sort with at most one swap
def canBeSortedWithAtMostOneSwap (p : List Nat) : Prop :=
  isSorted p ∨ (∃ i j, i < j ∧ j < p.length ∧ isSorted (swapAt p i j))

-- Postcondition definitions
@[reducible, simp]
def canSortWithOneSwap_postcond (n : Nat) (p : List Nat) (result: String) (h_precond : canSortWithOneSwap_precond (n) (p)) : Prop :=
  -- !benchmark @start postcond
  -- The result is "YES" if and only if the permutation can be sorted with at most one swap
    (result = "YES" ↔ canBeSortedWithAtMostOneSwap p) ∧
    (result = "NO" ↔ ¬canBeSortedWithAtMostOneSwap p)
  -- !benchmark @end postcond


-- Proof content
theorem canSortWithOneSwap_postcond_satisfied (n: Nat) (p: List Nat) (h_precond : canSortWithOneSwap_precond (n) (p)) :
    canSortWithOneSwap_postcond (n) (p) (canSortWithOneSwap (n) (p) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1999_p02958