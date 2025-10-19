import Mathlib

-- Precondition definitions
@[reducible, simp]
def minAttacksToDefeatMonster_precond (H : Nat) : Prop :=
  -- !benchmark @start precond
  H ≥ 1
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute minimum attacks recursively
def computeMinAttacksHelper (h : Nat) (fuel : Nat) : Nat :=
  match fuel with
  | 0 => 1  -- fallback case
  | fuel' + 1 =>
    if h ≤ 1 then 1
    else
      let half := h / 2
      1 + 2 * computeMinAttacksHelper half fuel'

-- Wrapper that provides sufficient fuel based on the logarithm of H
def computeMinAttacksWithFuel (h : Nat) : Nat :=
  if h ≤ 1 then 1
  else
    -- We need at most log2(h) + 1 recursive calls
    let fuel := 64  -- sufficient for H up to 2^64
    computeMinAttacksHelper h fuel

-- Main function definitions
def minAttacksToDefeatMonster (H : Nat) (h_precond : minAttacksToDefeatMonster_precond (H)) : Nat :=
  -- !benchmark @start code
  computeMinAttacksWithFuel H
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Recursive function to compute the minimum number of attacks needed
def computeMinAttacks (h : Nat) : Nat :=
  if h ≤ 1 then 1
  else
    let half := h / 2
    1 + 2 * computeMinAttacks half

-- Alternative characterization: the result equals 2^k - 1 where k is the number of times
-- we can divide H by 2 (rounding down) until we reach 1, plus 1
def attacksFormula (h : Nat) : Nat :=
  if h ≤ 1 then 1
  else
    let depth := Nat.log2 h + 1  -- depth of the binary tree
    2^depth - 1

-- Postcondition definitions
@[reducible, simp]
def minAttacksToDefeatMonster_postcond (H : Nat) (result: Nat) (h_precond : minAttacksToDefeatMonster_precond (H)) : Prop :=
  -- !benchmark @start postcond
  -- The result equals the number of attacks computed by the recursive formula
    result = computeMinAttacks H ∧
    -- The result is always odd (since it's 2^k - 1 for some k ≥ 1)
    result % 2 = 1 ∧
    -- The result is at least 1 (we need at least one attack)
    result ≥ 1 ∧
    -- For H = 1, exactly 1 attack is needed
    (H = 1 → result = 1) ∧
    -- For H > 1, the result follows the recursive pattern:
    -- attacks(H) = 1 + 2 * attacks(H/2)
    (H > 1 → result = 1 + 2 * computeMinAttacks (H / 2))
  -- !benchmark @end postcond


-- Proof content
theorem minAttacksToDefeatMonster_postcond_satisfied (H: Nat) (h_precond : minAttacksToDefeatMonster_precond (H)) :
    minAttacksToDefeatMonster_postcond (H) (minAttacksToDefeatMonster (H) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

