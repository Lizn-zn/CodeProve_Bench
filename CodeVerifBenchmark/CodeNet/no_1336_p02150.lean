import Mathlib

namespace no_1336_p02150


-- Precondition definitions
@[reducible, simp]
def calculateMaxMilk_precond (a : Nat) (b : Nat) (x : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ a ∧ b < a ∧ x ≥ 0
  -- !benchmark @end precond


-- Main function definitions
def calculateMaxMilk (a : Nat) (b : Nat) (x : Nat) (h_precond : calculateMaxMilk_precond (a) (b) (x)) : Nat :=
  -- !benchmark @start code
  if b ≥ x then
      x % 1000000007
    else
      let d := a - b
      let n := (x - b) / d
      (x + n * b) % 1000000007
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Calculate the maximum number of milk bottles that can be drunk
-- given the exchange rate and initial bottles
def maxMilkBottles (a b x : Nat) : Nat :=
  if b ≥ x then
    x
  else
    let d := a - b
    let n := (x - b) / d
    x + n * b

-- Postcondition definitions
@[reducible, simp]
def calculateMaxMilk_postcond (a : Nat) (b : Nat) (x : Nat) (result: Nat) (h_precond : calculateMaxMilk_precond (a) (b) (x)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the maximum milk bottles modulo 1000000007
  -- The logic follows: drink x bottles initially, then exchange empty bottles
  -- For each exchange: give a empty bottles, get b full bottles back
  -- Net cost per exchange: a - b empty bottles, gain b full bottles
  -- Maximum exchanges possible: (x - b) / (a - b) when x > b
  -- Total milk drunk: x + number_of_exchanges * b
  result = maxMilkBottles a b x % 1000000007
  -- !benchmark @end postcond


-- Proof content
theorem calculateMaxMilk_postcond_satisfied (a: Nat) (b: Nat) (x: Nat) (h_precond : calculateMaxMilk_precond (a) (b) (x)) :
    calculateMaxMilk_postcond (a) (b) (x) (calculateMaxMilk (a) (b) (x) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1336_p02150