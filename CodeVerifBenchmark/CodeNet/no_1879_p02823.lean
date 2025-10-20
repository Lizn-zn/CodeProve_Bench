import Mathlib

namespace no_1879_p02823


-- Precondition definitions
@[reducible, simp]
def minRoundsToMeet_precond (N : Nat) (A : Nat) (B : Nat) : Prop :=
  -- !benchmark @start precond
  2 ≤ N ∧ 1 ≤ A ∧ A < B ∧ B ≤ N
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def minRoundsToMeet (N : Nat) (A : Nat) (B : Nat) (h_precond : minRoundsToMeet_precond (N) (A) (B)) : Nat :=
  -- !benchmark @start code
  if (B - A) % 2 = 0 then
      (B - A) / 2
    else
      min ((A + B) / 2) ((2 * N - B - A + 1) / 2)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to determine if two players at tables a and b can meet after k rounds
def canMeetAfterKRounds (a b k : Nat) : Prop :=
  ∃ (finalTable : Nat), 
    -- Player at table a can reach finalTable in k rounds
    (finalTable ≥ (if a ≥ k then a - k else 1) ∧ finalTable ≤ a + k) ∧
    -- Player at table b can reach finalTable in k rounds  
    (finalTable ≥ (if b ≥ k then b - k else 1) ∧ finalTable ≤ b + k) ∧
    -- Both players must move the same parity of steps to meet
    ((a - finalTable) % 2 = (finalTable - b) % 2)

-- Helper function accounting for table boundaries
def canMeetAfterKRoundsWithBounds (N a b k : Nat) : Prop :=
  ∃ (finalTable : Nat),
    1 ≤ finalTable ∧ finalTable ≤ N ∧
    -- Player at a can reach finalTable in exactly k moves (respecting boundaries)
    (if finalTable ≤ a then a - finalTable ≤ k else finalTable - a ≤ k) ∧
    -- Player at b can reach finalTable in exactly k moves (respecting boundaries)
    (if finalTable ≤ b then b - finalTable ≤ k else finalTable - b ≤ k) ∧
    -- Parity constraint: both must move same parity distance
    ((if finalTable ≤ a then a - finalTable else finalTable - a) % 2 = 
     (if finalTable ≤ b then b - finalTable else finalTable - b) % 2)

-- Postcondition definitions
@[reducible, simp]
def minRoundsToMeet_postcond (N : Nat) (A : Nat) (B : Nat) (result: Nat) (h_precond : minRoundsToMeet_precond (N) (A) (B)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the minimum number of rounds
    canMeetAfterKRoundsWithBounds N A B result ∧
    (∀ k : Nat, k < result → ¬canMeetAfterKRoundsWithBounds N A B k) ∧
    -- Verify the result matches the expected formula
    (if (B - A) % 2 = 0 then
      result = (B - A) / 2
    else
      result = min ((A + B) / 2) ((2 * N - B - A + 1) / 2))
  -- !benchmark @end postcond


-- Proof content
theorem minRoundsToMeet_postcond_satisfied (N: Nat) (A: Nat) (B: Nat) (h_precond : minRoundsToMeet_precond (N) (A) (B)) :
    minRoundsToMeet_postcond (N) (A) (B) (minRoundsToMeet (N) (A) (B) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1879_p02823