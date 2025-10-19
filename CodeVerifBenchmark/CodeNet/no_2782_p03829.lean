import Mathlib

-- Precondition definitions
@[reducible, simp]
def minFatigueLevel_precond (n : Nat) (a : Nat) (b : Nat) (positions : List Nat) : Prop :=
  -- !benchmark @start precond
  n ≥ 2 ∧ 
    positions.length = n ∧ 
    a ≥ 1 ∧ 
    b ≥ 1 ∧
    (∀ i : Nat, i < n → positions[i]! ≥ 1) ∧
    (∀ i : Nat, i < n - 1 → positions[i]! < positions[i + 1]!)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to iterate through consecutive pairs and sum up minimum costs
def sumMinCosts (a b : Nat) (positions : List Nat) (idx : Nat) (acc : Nat) : Nat :=
  if idx + 1 >= positions.length then
    acc
  else
    let dist := positions[idx + 1]! - positions[idx]!
    let cost := min (a * dist) b
    sumMinCosts a b positions (idx + 1) (acc + cost)

-- Main function definitions
def minFatigueLevel (n : Nat) (a : Nat) (b : Nat) (positions : List Nat) (h_precond : minFatigueLevel_precond (n) (a) (b) (positions)) : Nat :=
  -- !benchmark @start code
  sumMinCosts a b positions 0 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to compute the cost between consecutive towns
def travelCost (a b : Nat) (dist : Nat) : Nat :=
  min (a * dist) b

-- Helper function to compute total minimum fatigue
def computeMinFatigue (a b : Nat) (positions : List Nat) : Nat :=
  match positions with
  | [] => 0
  | [_] => 0
  | x :: xs@(y :: _) => 
      travelCost a b (y - x) + computeMinFatigue a b xs

-- Postcondition definitions
@[reducible, simp]
def minFatigueLevel_postcond (n : Nat) (a : Nat) (b : Nat) (positions : List Nat) (result: Nat) (h_precond : minFatigueLevel_precond (n) (a) (b) (positions)) : Prop :=
  -- !benchmark @start postcond
  result = computeMinFatigue a b positions
  -- !benchmark @end postcond


-- Proof content
theorem minFatigueLevel_postcond_satisfied (n: Nat) (a: Nat) (b: Nat) (positions: List Nat) (h_precond : minFatigueLevel_precond (n) (a) (b) (positions)) :
    minFatigueLevel_postcond (n) (a) (b) (positions) (minFatigueLevel (n) (a) (b) (positions) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

