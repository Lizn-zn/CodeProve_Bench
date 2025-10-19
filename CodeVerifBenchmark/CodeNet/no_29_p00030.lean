import Mathlib

-- Precondition definitions
@[reducible, simp]
def countCombinations_precond (n : Nat) (s : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ n ∧ n ≤ 9 ∧ s ≤ 100
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to generate combinations and count those that sum to s
def countCombinationsHelper (digits : List Nat) (n : Nat) (s : Nat) (currentSum : Nat) : Nat :=
  if n == 0 then
    if currentSum == s then 1 else 0
  else
    match digits with
    | [] => 0
    | x :: xs =>
      -- Include x in the combination
      let includeCount := countCombinationsHelper xs (n - 1) s (currentSum + x)
      -- Exclude x from the combination
      let excludeCount := countCombinationsHelper xs n s currentSum
      includeCount + excludeCount

-- Main function definitions
def countCombinations (n : Nat) (s : Nat) (h_precond : countCombinations_precond (n) (s)) : Nat :=
  -- !benchmark @start code
  let digits := List.range 10
  countCombinationsHelper digits n s 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if a list contains distinct elements from 0 to 9
def isValidCombination (lst : List Nat) : Bool :=
  lst.all (· < 10) && lst.length == lst.eraseDups.length

-- Helper function to count combinations of n distinct digits from 0-9 that sum to s
def countValidCombinations (n : Nat) (s : Nat) : Nat :=
  -- Generate all n-element subsets of {0,1,2,...,9} and count those that sum to s
  let digits := List.range 10
  let rec countHelper (remaining : List Nat) (chosen : List Nat) (currentN : Nat) (currentSum : Nat) : Nat :=
    if currentN == 0 then
      if currentSum == s then 1 else 0
    else
      match remaining with
      | [] => 0
      | x :: xs =>
        -- Include x in the combination
        let includeCount := countHelper xs (x :: chosen) (currentN - 1) (currentSum + x)
        -- Exclude x from the combination
        let excludeCount := countHelper xs chosen currentN currentSum
        includeCount + excludeCount
  countHelper digits [] n 0

-- Postcondition definitions
@[reducible, simp]
def countCombinations_postcond (n : Nat) (s : Nat) (result: Nat) (h_precond : countCombinations_precond (n) (s)) : Prop :=
  -- !benchmark @start postcond
  result = countValidCombinations n s
  -- !benchmark @end postcond


-- Proof content
theorem countCombinations_postcond_satisfied (n: Nat) (s: Nat) (h_precond : countCombinations_precond (n) (s)) :
    countCombinations_postcond (n) (s) (countCombinations (n) (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof