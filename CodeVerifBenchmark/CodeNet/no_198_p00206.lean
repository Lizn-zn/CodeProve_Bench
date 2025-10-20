import Mathlib

namespace no_198_p00206


-- Precondition definitions
@[reducible, simp]
def calculateMonthsToSavings_precond (tripCost : Nat) (monthlySavings : List Int) : Prop :=
  -- !benchmark @start precond
  -- The trip cost is positive and the monthly savings list has exactly 12 elements
  tripCost > 0 ∧ monthlySavings.length = 12
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to find the first month where savings goal is reached
def findMonthHelper (tripCost : Nat) (monthlySavings : List Int) (currentMonth : Nat) (accumulatedSavings : Int) : Option Nat :=
  if currentMonth > 12 then
    none
  else
    let newAccumulated := accumulatedSavings + monthlySavings[currentMonth - 1]!
    if newAccumulated ≥ tripCost then
      some currentMonth
    else
      findMonthHelper tripCost monthlySavings (currentMonth + 1) newAccumulated
termination_by 12 - currentMonth
decreasing_by sorry

-- Main function definitions
def calculateMonthsToSavings (tripCost : Nat) (monthlySavings : List Int) (h_precond : calculateMonthsToSavings_precond (tripCost) (monthlySavings)) : Option Nat :=
  -- !benchmark @start code
  findMonthHelper tripCost monthlySavings 1 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to compute cumulative savings up to month i (1-indexed)
def cumulativeSavings (monthlySavings : List Int) (month : Nat) : Int :=
  (monthlySavings.take month).foldl (· + ·) 0

-- Postcondition definitions
@[reducible, simp]
def calculateMonthsToSavings_postcond (tripCost : Nat) (monthlySavings : List Int) (result: Option Nat) (h_precond : calculateMonthsToSavings_precond (tripCost) (monthlySavings)) : Prop :=
  -- !benchmark @start postcond
  -- The result is Some n if and only if:
  -- 1. n is the smallest month (1-indexed, 1 ≤ n ≤ 12) where cumulative savings >= trip cost
  -- The result is None if and only if:
  -- 1. After 12 months, cumulative savings < trip cost
  match result with
    | some n => 
        -- n is in valid range [1, 12]
        1 ≤ n ∧ n ≤ 12 ∧
        -- Cumulative savings at month n is at least the trip cost
        cumulativeSavings monthlySavings n ≥ tripCost ∧
        -- For all earlier months, cumulative savings is less than trip cost
        (∀ m : Nat, 1 ≤ m ∧ m < n → cumulativeSavings monthlySavings m < tripCost)
    | none =>
        -- After all 12 months, cumulative savings is still less than trip cost
        cumulativeSavings monthlySavings 12 < tripCost
  -- !benchmark @end postcond


-- Proof content
theorem calculateMonthsToSavings_postcond_satisfied (tripCost: Nat) (monthlySavings: List Int) (h_precond : calculateMonthsToSavings_precond (tripCost) (monthlySavings)) :
    calculateMonthsToSavings_postcond (tripCost) (monthlySavings) (calculateMonthsToSavings (tripCost) (monthlySavings) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_198_p00206