import Mathlib

namespace no_831_p01101


-- Precondition definitions
@[reducible, simp]
def findBestPair_precond (n : Nat) (m : Nat) (prices : List Nat) : Prop :=
  -- !benchmark @start precond
  -- The number of items matches the length of the prices list
    n = prices.length ∧
    -- There are at least 2 items
    n ≥ 2 ∧
    -- The maximum allowed amount is at least 2
    m ≥ 2 ∧
    -- All prices are positive
    ∀ p ∈ prices, p ≥ 1
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to find the best pair using a two-pointer approach
def findBestPairAux (sortedPrices : List Nat) (m : Nat) : Option Nat :=
  let n := sortedPrices.length
  let rec search (i : Nat) (pos : Nat) (currentBest : Nat) : Nat :=
    if i >= n then currentBest
    else
      -- Find the rightmost position where sortedPrices[i] + sortedPrices[pos] <= m
      let rec findPos (p : Nat) : Nat :=
        if p <= i then p
        else if sortedPrices[i]! + sortedPrices[p]! <= m then p
        else findPos (p - 1)
      let newPos := findPos pos
      if newPos <= i then currentBest
      else
        let newSum := sortedPrices[i]! + sortedPrices[newPos]!
        search (i + 1) newPos (max currentBest newSum)
  let result := search 0 (n - 1) 0
  if result > 0 then some result else none

-- Main function definitions
def findBestPair (n : Nat) (m : Nat) (prices : List Nat) (h_precond : findBestPair_precond (n) (m) (prices)) : Option Nat :=
  -- !benchmark @start code
  -- Sort the prices list
    let sortedPrices := prices.insertionSort (· ≤ ·)
    -- Find the best pair using the auxiliary function
    findBestPairAux sortedPrices m
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper to check if a pair sum is valid (two different items, sum ≤ m)
def isValidPair (prices : List Nat) (i j : Nat) (m : Nat) : Prop :=
  i < prices.length ∧ 
  j < prices.length ∧ 
  i ≠ j ∧ 
  prices[i]! + prices[j]! ≤ m

-- Helper to check if there exists any valid pair
def hasValidPair (prices : List Nat) (m : Nat) : Prop :=
  ∃ i j, isValidPair prices i j m

-- Helper to get the maximum sum among all valid pairs
def maxValidPairSum (prices : List Nat) (m : Nat) : Nat :=
  let allPairs := List.range prices.length |>.flatMap fun i =>
    List.range prices.length |>.filterMap fun j =>
      if i ≠ j ∧ prices[i]! + prices[j]! ≤ m then
        some (prices[i]! + prices[j]!)
      else
        none
  List.foldl max 0 allPairs

-- Postcondition definitions
@[reducible, simp]
def findBestPair_postcond (n : Nat) (m : Nat) (prices : List Nat) (result: Option Nat) (h_precond : findBestPair_precond (n) (m) (prices)) : Prop :=
  -- !benchmark @start postcond
  match result with
    | none => 
      -- Return none if and only if no valid pair exists
      ¬hasValidPair prices m
    | some sum =>
      -- If a sum is returned, it must be:
      -- 1. The sum of two different items
      (∃ i j, isValidPair prices i j m ∧ prices[i]! + prices[j]! = sum) ∧
      -- 2. Not exceeding the maximum allowed amount
      sum ≤ m ∧
      -- 3. The maximum among all valid pairs
      (∀ i j, isValidPair prices i j m → prices[i]! + prices[j]! ≤ sum)
  -- !benchmark @end postcond


-- Proof content
theorem findBestPair_postcond_satisfied (n: Nat) (m: Nat) (prices: List Nat) (h_precond : findBestPair_precond (n) (m) (prices)) :
    findBestPair_postcond (n) (m) (prices) (findBestPair (n) (m) (prices) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_831_p01101