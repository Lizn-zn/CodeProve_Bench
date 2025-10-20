import Mathlib

namespace no_1511_leetcode_2944


-- Precondition auxiliary definitions
/-- A helper function to compute the minimum coins required using dynamic programming -/
def minCoinsToAcquireFruits.dp (prices : List Nat) : List Nat → Nat
  | [] => 0
  | _ =>
    let n := prices.length
    let dp := List.range n |>.reverse |>.foldl (fun (acc : List Nat) i =>
      let cost := prices.get! i
      let freeRange := i + 1
      let maxFreeIndex := i + freeRange
      let futureCosts := List.range (n - (i + 1)) |>.map (fun j => acc.get! j)
      let applicableFutureCosts := futureCosts.take freeRange
      let minFutureCost := if applicableFutureCosts.isEmpty then 0 else applicableFutureCosts.foldl min (applicableFutureCosts.head!)
      (cost + minFutureCost) :: acc
    ) (List.replicate n 0)
    dp.get! 0

-- !benchmark @end precond_aux

-- Precondition definitions
@[reducible, simp]
def minCoinsToAcquireFruits_precond (prices : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- A helper function to compute the minimum coins required using dynamic programming -/
def minCoinsToAcquireFruits.computeDP (prices : List Nat) : List Nat :=
  let n := prices.length
  -- Initialize dp array with a large number (we'll use 1000000000 as infinity)
  let inf := 1000000000
  let dpInit := List.replicate (n + 1) inf
  -- dp[n] = 0 (no cost for fruits beyond the array)
  let dpBase := dpInit.set n 0
  -- Iterate backwards from n-1 to 0
  List.range n |>.reverse |>.foldl (fun (dp : List Nat) (i : Nat) =>
    let cost := prices.get! i
    let freeCount := i + 1
    -- The range of free fruits is from i+1 to min(n-1, i + freeCount)
    -- In 0-based indexing, that's from i+1 to min(n-1, i + freeCount)
    let endFree := min (n - 1) (i + freeCount)
    -- Number of free fruits available from position i+1 onwards
    let numFree := endFree - i
    -- Find the minimum dp value in the range [i+1, endFree]
    let futureCosts := List.range (numFree + 1) |>.map (fun j => dp.get! (i + 1 + j))
    let minFutureCost := if futureCosts.isEmpty then inf else futureCosts.foldl min (futureCosts.head!)
    -- Update dp[i] = cost + minFutureCost
    dp.set i (cost + minFutureCost)
  ) dpBase

-- Main function definitions
def minCoinsToAcquireFruits (prices : List Nat) (h_precond : minCoinsToAcquireFruits_precond (prices)) : Nat :=
  -- !benchmark @start code
  let dp := minCoinsToAcquireFruits.computeDP prices
  dp.get! 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Verifies that a given solution matches the expected minimal cost -/
def minCoinsToAcquireFruits.verifySolution (prices : List Nat) (totalCost : Nat) : Prop :=
  totalCost = minCoinsToAcquireFruits.dp prices prices

-- !benchmark @end postcond_aux

-- Postcondition definitions
@[reducible, simp]
def minCoinsToAcquireFruits_postcond (prices : List Nat) (result: Nat) (h_precond : minCoinsToAcquireFruits_precond (prices)) : Prop :=
  -- !benchmark @start postcond
  minCoinsToAcquireFruits.verifySolution prices result
  -- !benchmark @end postcond


-- Proof content
theorem minCoinsToAcquireFruits_postcond_satisfied (prices: List Nat) (h_precond : minCoinsToAcquireFruits_precond (prices)) :
    minCoinsToAcquireFruits_postcond (prices) (minCoinsToAcquireFruits (prices) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1511_leetcode_2944