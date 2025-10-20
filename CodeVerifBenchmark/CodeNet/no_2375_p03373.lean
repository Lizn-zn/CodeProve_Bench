import Mathlib

namespace no_2375_p03373


-- Precondition definitions
@[reducible, simp]
def minPizzaCost_precond (A : Nat) (B : Nat) (C : Nat) (X : Nat) (Y : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ A ∧ A ≤ 5000 ∧
    1 ≤ B ∧ B ≤ 5000 ∧
    1 ≤ C ∧ C ≤ 5000 ∧
    1 ≤ X ∧ X ≤ 100000 ∧
    1 ≤ Y ∧ Y ≤ 100000
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to find minimum cost by trying different numbers of AB-pizzas
def findMinCostHelper (A B C X Y : Nat) (abCount : Nat) (fuel : Nat) (currentMin : Nat) : Nat :=
  match fuel with
  | 0 => currentMin
  | fuel' + 1 =>
    -- Calculate how many A and B pizzas we need after buying abCount AB-pizzas
    let aFromAB := abCount / 2
    let bFromAB := abCount / 2
    let aNeeded := if X > aFromAB then X - aFromAB else 0
    let bNeeded := if Y > bFromAB then Y - bFromAB else 0
    let cost := A * aNeeded + B * bNeeded + C * abCount
    let newMin := min cost currentMin
    findMinCostHelper A B C X Y (abCount + 2) fuel' newMin

-- Main function definitions
def minPizzaCost (A : Nat) (B : Nat) (C : Nat) (X : Nat) (Y : Nat) (h_precond : minPizzaCost_precond (A) (B) (C) (X) (Y)) : Nat :=
  -- !benchmark @start code
  -- Try different numbers of AB-pizzas (always even numbers since we buy in pairs)
    -- We need at most 2 * max(X, Y) AB-pizzas to satisfy both requirements
    let maxAB := 2 * (max X Y)
    -- Initial cost: buy all A and B pizzas directly
    let initialCost := A * X + B * Y
    -- Try buying 0, 2, 4, ... AB-pizzas and find the minimum cost
    findMinCostHelper A B C X Y 0 (maxAB + 1) initialCost
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if a purchase strategy satisfies the requirements
def satisfiesPizzaRequirement (numA : Nat) (numB : Nat) (numAB : Nat) (X : Nat) (Y : Nat) : Prop :=
  -- numA A-pizzas + numAB AB-pizzas (each gives half A-pizza) >= X A-pizzas needed
  -- numB B-pizzas + numAB AB-pizzas (each gives half B-pizza) >= Y B-pizzas needed
  -- Since 2 AB-pizzas = 1 A-pizza + 1 B-pizza
  2 * numA + numAB ≥ 2 * X ∧ 2 * numB + numAB ≥ 2 * Y

-- Cost calculation for a given strategy
def pizzaCost (A B C : Nat) (numA numB numAB : Nat) : Nat :=
  A * numA + B * numB + C * numAB

-- Postcondition definitions
@[reducible, simp]
def minPizzaCost_postcond (A : Nat) (B : Nat) (C : Nat) (X : Nat) (Y : Nat) (result: Nat) (h_precond : minPizzaCost_precond (A) (B) (C) (X) (Y)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the minimum cost among all valid purchase strategies
    (∃ (numA numB numAB : Nat), 
      satisfiesPizzaRequirement numA numB numAB X Y ∧
      result = pizzaCost A B C numA numB numAB) ∧
    (∀ (numA' numB' numAB' : Nat),
      satisfiesPizzaRequirement numA' numB' numAB' X Y →
      result ≤ pizzaCost A B C numA' numB' numAB')
  -- !benchmark @end postcond


-- Proof content
theorem minPizzaCost_postcond_satisfied (A: Nat) (B: Nat) (C: Nat) (X: Nat) (Y: Nat) (h_precond : minPizzaCost_precond (A) (B) (C) (X) (Y)) :
    minPizzaCost_postcond (A) (B) (C) (X) (Y) (minPizzaCost (A) (B) (C) (X) (Y) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2375_p03373