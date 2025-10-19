import Mathlib

-- Precondition definitions
@[reducible, simp]
def countPossibleColors_precond (n : Nat) (sizes : List Nat) : Prop :=
  -- !benchmark @start precond
  n = sizes.length ∧ n ≥ 2 ∧ sizes.all (· > 0)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute prefix sums
def computePrefixSums (lst : List Nat) : List Nat :=
  lst.scanl (· + ·) 0 |>.tail!

-- Find the first index where the condition breaks
def findBreakPoint (sortedSizes : List Nat) (sums : List Nat) : Option Nat :=
  sortedSizes.enum.find? (fun (i, _) => 
    i + 1 < sortedSizes.length ∧ 
    sums[i]! * 2 < sortedSizes[i + 1]!
  ) |>.map Prod.fst

-- Main function definitions
def countPossibleColors (n : Nat) (sizes : List Nat) (h_precond : countPossibleColors_precond (n) (sizes)) : Nat :=
  -- !benchmark @start code
  -- Sort the sizes
    let sortedSizes := sizes.toArray.qsort (· ≤ ·) |>.toList
    -- Compute prefix sums
    let sums := computePrefixSums sortedSizes
    -- Find the break point
    match findBreakPoint sortedSizes sums with
    | none => n  -- All creatures can be the final color
    | some breakIdx => n - breakIdx - 1  -- Only creatures after the break point can be final
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to compute prefix sums
def prefixSums (lst : List Nat) : List Nat :=
  lst.scanl (· + ·) 0 |>.tail!

-- A creature of color i (0-indexed) can become the final creature if:
-- when sorted by size, starting from creature i, each subsequent creature
-- can be absorbed by the accumulated mass up to that point
def canBeFinalColor (sortedSizes : List Nat) (colorIdx : Nat) : Prop :=
  colorIdx < sortedSizes.length ∧
  let sums := prefixSums sortedSizes
  ∀ j, colorIdx < j → j < sortedSizes.length → 
    2 * sums[j]! ≥ sortedSizes[j]!

-- Count how many colors can be the final color
def countFinalColors (sortedSizes : List Nat) : Nat :=
  let optBreakIdx := sortedSizes.enum.find? (fun (i, _) => 
    i + 1 < sortedSizes.length ∧ 
    let sums := prefixSums sortedSizes
    sums[i]! * 2 < sortedSizes[i + 1]!
  )
  match optBreakIdx with
  | none => sortedSizes.length
  | some (i, _) => sortedSizes.length - (i + 1)

-- Postcondition definitions
@[reducible, simp]
def countPossibleColors_postcond (n : Nat) (sizes : List Nat) (result: Nat) (h_precond : countPossibleColors_precond (n) (sizes)) : Prop :=
  -- !benchmark @start postcond
  -- The result equals the number of possible final colors
  -- This is determined by sorting the sizes and checking from the end:
  -- A color can be final if, when we sort all creatures by size,
  -- starting from that creature's position in sorted order,
  -- each creature can be absorbed by the cumulative sum before it
  let sortedSizes := sizes.toArray.qsort (· ≤ ·) |>.toList
  result = countFinalColors sortedSizes
  -- !benchmark @end postcond


-- Proof content
theorem countPossibleColors_postcond_satisfied (n: Nat) (sizes: List Nat) (h_precond : countPossibleColors_precond (n) (sizes)) :
    countPossibleColors_postcond (n) (sizes) (countPossibleColors (n) (sizes) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof