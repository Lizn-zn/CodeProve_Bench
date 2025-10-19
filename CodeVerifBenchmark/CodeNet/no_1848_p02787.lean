import Mathlib

-- Precondition definitions
@[reducible, simp]
def minMagicPoints_precond (H : Nat) (N : Nat) (spells : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  -- H is the monster's health (positive)
    -- N is the number of spell types
    -- spells is a list of N pairs (damage, cost) where each spell deals damage and costs magic points
    H > 0 ∧ 
    N > 0 ∧ 
    spells.length = N ∧
    (∀ (spell : Nat × Nat), spell ∈ spells → spell.1 > 0 ∧ spell.2 > 0)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute minimum cost using dynamic programming
def computeMinCost (H : Nat) (spells : List (Nat × Nat)) : Nat :=
  let INF := H * 10000 + 1  -- Large enough value
  let dp := Array.range (H + 1) |>.map (fun _ => INF)
  let dp := dp.set! H 0
  let dp := (List.range (H + 1)).reverse.foldl (fun dp i =>
    spells.foldl (fun dp spell =>
      let (damage, cost) := spell
      let newHealth := if i >= damage then i - damage else 0
      let currentCost := dp[i]!
      let newCost := currentCost + cost
      if dp[newHealth]! > newCost then
        dp.set! newHealth newCost
      else
        dp
    ) dp
  ) dp
  dp[0]!

-- Main function definitions
def minMagicPoints (H : Nat) (N : Nat) (spells : List (Nat × Nat)) (h_precond : minMagicPoints_precond (H) (N) (spells)) : Nat :=
  -- !benchmark @start code
  computeMinCost H spells
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper to check if a sequence of spell uses defeats the monster
def defeatsMonster (H : Nat) (spells : List (Nat × Nat)) (usage : List Nat) : Prop :=
  usage.length = spells.length ∧
  (List.zipWith (fun spell count => spell.1 * count) spells usage).sum ≥ H

-- Helper to calculate total cost of spell usage
def totalCost (spells : List (Nat × Nat)) (usage : List Nat) : Nat :=
  (List.zipWith (fun spell count => spell.2 * count) spells usage).sum

-- Postcondition definitions
@[reducible, simp]
def minMagicPoints_postcond (H : Nat) (N : Nat) (spells : List (Nat × Nat)) (result: Nat) (h_precond : minMagicPoints_precond (H) (N) (spells)) : Prop :=
  -- !benchmark @start postcond
  -- result is the minimum total magic points needed to reduce monster's health to 0 or below
    -- There exists a way to defeat the monster with exactly 'result' magic points
    (∃ (usage : List Nat), defeatsMonster H spells usage ∧ totalCost spells usage = result) ∧
    -- No other strategy can defeat the monster with fewer magic points
    (∀ (usage : List Nat), defeatsMonster H spells usage → totalCost spells usage ≥ result)
  -- !benchmark @end postcond


-- Proof content
theorem minMagicPoints_postcond_satisfied (H: Nat) (N: Nat) (spells: List (Nat × Nat)) (h_precond : minMagicPoints_precond (H) (N) (spells)) :
    minMagicPoints_postcond (H) (N) (spells) (minMagicPoints (H) (N) (spells) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

