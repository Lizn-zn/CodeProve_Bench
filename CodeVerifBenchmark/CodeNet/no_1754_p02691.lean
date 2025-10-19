import Mathlib

-- Precondition definitions
@[reducible, simp]
def countSatisfyingPairs_precond (n : Nat) (heights : List Nat) : Prop :=
  -- !benchmark @start precond
  heights.length = n ∧ n ≥ 2
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to count occurrences of a value in a list
def countOccurrences (lst : List Int) (val : Int) : Nat :=
  lst.foldl (fun acc x => if x = val then acc + 1 else acc) 0

-- Main function definitions
def countSatisfyingPairs (n : Nat) (heights : List Nat) (h_precond : countSatisfyingPairs_precond (n) (heights)) : Nat :=
  -- !benchmark @start code
  -- Transform the problem: for pair (i, j) where i < j
    -- We need: j - i = heights[i] + heights[j]
    -- Rearranging: j - heights[j] = i + heights[i]
    -- So we can compute (i + heights[i]) for all i and (j - heights[j]) for all j
    -- and count matches
    
    let ap := heights.enum.map (fun (i, h) => (i : Int) + (h : Int))
    let am := heights.enum.map (fun (i, h) => (i : Int) - (h : Int))
    
    -- For each value in am, count how many times it appears in ap
    -- This gives us the number of pairs where j - heights[j] = i + heights[i]
    am.foldl (fun cnt m => cnt + countOccurrences ap m) 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if a pair (i, j) satisfies the condition
-- The condition is: |i - j| = heights[i] + heights[j]
-- Since i and j are 0-indexed in the list but 1-indexed in the problem,
-- we need: |(i+1) - (j+1)| = heights[i] + heights[j]
-- which simplifies to: |i - j| = heights[i] + heights[j]
def pairSatisfiesCondition (heights : List Nat) (i j : Nat) : Bool :=
  if h1 : i < heights.length then
    if h2 : j < heights.length then
      if i < j then
        (j - i) = (heights[i]! + heights[j]!)
      else if j < i then
        (i - j) = (heights[i]! + heights[j]!)
      else
        false
    else
      false
  else
    false

-- Count all pairs (i, j) where i < j that satisfy the condition
def countAllSatisfyingPairs (heights : List Nat) : Nat :=
  let pairs := List.range heights.length
  (pairs.foldl (fun acc i =>
    acc + (List.range heights.length).foldl (fun acc2 j =>
      if i < j && pairSatisfiesCondition heights i j then
        acc2 + 1
      else
        acc2
    ) 0
  ) 0)

-- Postcondition definitions
@[reducible, simp]
def countSatisfyingPairs_postcond (n : Nat) (heights : List Nat) (result: Nat) (h_precond : countSatisfyingPairs_precond (n) (heights)) : Prop :=
  -- !benchmark @start postcond
  result = countAllSatisfyingPairs heights
  -- !benchmark @end postcond


-- Proof content
theorem countSatisfyingPairs_postcond_satisfied (n: Nat) (heights: List Nat) (h_precond : countSatisfyingPairs_precond (n) (heights)) :
    countSatisfyingPairs_postcond (n) (heights) (countSatisfyingPairs (n) (heights) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

