import Mathlib

namespace no_349_p00387


-- Precondition definitions
@[reducible, simp]
def partyDress_precond (numDresses : Nat) (numParties : Nat) : Prop :=
  -- !benchmark @start precond
  numDresses ≥ 1 ∧ numParties ≥ 1
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def partyDress (numDresses : Nat) (numParties : Nat) (h_precond : partyDress_precond (numDresses) (numParties)) : Nat :=
  -- !benchmark @start code
  (numParties + numDresses - 1) / numDresses
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if we can distribute numParties across numDresses
-- such that no dress is worn more than maxUses times
def canDistribute (numDresses : Nat) (numParties : Nat) (maxUses : Nat) : Prop :=
  numDresses * maxUses ≥ numParties

-- The result is the minimum number of times the most reused dress must be worn
def isMinMaxUses (numDresses : Nat) (numParties : Nat) (result : Nat) : Prop :=
  -- The result allows us to cover all parties
  canDistribute numDresses numParties result ∧
  -- No smaller value would work
  (result > 0 → ¬canDistribute numDresses numParties (result - 1))

-- Postcondition definitions
@[reducible, simp]
def partyDress_postcond (numDresses : Nat) (numParties : Nat) (result: Nat) (h_precond : partyDress_precond (numDresses) (numParties)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the ceiling of numParties / numDresses
  -- which is the minimum maximum frequency of wearing any dress
  isMinMaxUses numDresses numParties result ∧
  result = (numParties + numDresses - 1) / numDresses
  -- !benchmark @end postcond


-- Proof content
theorem partyDress_postcond_satisfied (numDresses: Nat) (numParties: Nat) (h_precond : partyDress_precond (numDresses) (numParties)) :
    partyDress_postcond (numDresses) (numParties) (partyDress (numDresses) (numParties) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_349_p00387