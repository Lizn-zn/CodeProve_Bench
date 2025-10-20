import Mathlib

namespace no_262_p00274


-- Precondition definitions
@[reducible, simp]
def minChallengesForMatchingPrize_precond (prizes : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Postcondition auxiliary definitions
-- Count how many prizes have at least 2 items remaining
def countPrizesWithAtLeastTwo (prizes : List Nat) : Nat :=
  prizes.filter (· ≥ 2) |>.length

-- Count how many prizes have at least 1 item remaining
def countPrizesWithAtLeastOne (prizes : List Nat) : Nat :=
  prizes.filter (· ≥ 1) |>.length


-- Main function definitions
def minChallengesForMatchingPrize (prizes : List Nat) (h_precond : minChallengesForMatchingPrize_precond (prizes)) : Option Nat :=
  -- !benchmark @start code
  let prizesWithAtLeastTwo := countPrizesWithAtLeastTwo prizes
  let prizesWithAtLeastOne := countPrizesWithAtLeastOne prizes
  if prizesWithAtLeastTwo > 0 then
    some (prizesWithAtLeastOne + 1)
  else
    none
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def minChallengesForMatchingPrize_postcond (prizes : List Nat) (result: Option Nat) (h_precond : minChallengesForMatchingPrize_precond (prizes)) : Prop :=
  -- !benchmark @start postcond
  match result with
    | none => 
      -- Result is NA (none) if and only if there are no prizes with at least 2 items
      countPrizesWithAtLeastTwo prizes = 0
    | some n =>
      -- If there exists at least one prize with ≥ 2 items, then:
      -- The minimum number of challenges needed is (number of prizes with ≥ 1 item) + 1
      -- This is because in the worst case, we get one of each different prize type first,
      -- and then the next challenge must give us a duplicate
      countPrizesWithAtLeastTwo prizes > 0 ∧ 
      n = countPrizesWithAtLeastOne prizes + 1
  -- !benchmark @end postcond


-- Proof content
theorem minChallengesForMatchingPrize_postcond_satisfied (prizes: List Nat) (h_precond : minChallengesForMatchingPrize_precond (prizes)) :
    minChallengesForMatchingPrize_postcond (prizes) (minChallengesForMatchingPrize (prizes) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_262_p00274