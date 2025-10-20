import Mathlib

namespace no_294_p00312


-- Precondition definitions
@[reducible, simp]
def minJumpsToHome_precond (D : Nat) (L : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ D ∧ D ≤ 10000 ∧ 2 ≤ L ∧ L ≤ 10000
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def minJumpsToHome (D : Nat) (L : Nat) (h_precond : minJumpsToHome_precond (D) (L)) : Nat :=
  -- !benchmark @start code
  D / L + D % L
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Check if we can reach exactly distance d with numBigJumps big jumps and numSmallJumps small jumps
def canReach (d : Nat) (l : Nat) (numBigJumps : Nat) (numSmallJumps : Nat) : Prop :=
  numBigJumps * l + numSmallJumps = d

-- Check if the result is achievable (there exists a valid combination of jumps)
def isAchievable (d : Nat) (l : Nat) (totalJumps : Nat) : Prop :=
  ∃ (numBigJumps numSmallJumps : Nat), 
    numBigJumps + numSmallJumps = totalJumps ∧ 
    canReach d l numBigJumps numSmallJumps

-- Postcondition definitions
@[reducible, simp]
def minJumpsToHome_postcond (D : Nat) (L : Nat) (result: Nat) (h_precond : minJumpsToHome_precond (D) (L)) : Prop :=
  -- !benchmark @start postcond
  -- The result equals D // L + D % L
    result = D / L + D % L ∧
    -- The result is achievable (we can reach exactly D with this many jumps)
    isAchievable D L result ∧
    -- The result is minimal (no smaller number of jumps can reach exactly D)
    (∀ n : Nat, n < result → ¬isAchievable D L n)
  -- !benchmark @end postcond


-- Proof content
theorem minJumpsToHome_postcond_satisfied (D: Nat) (L: Nat) (h_precond : minJumpsToHome_precond (D) (L)) :
    minJumpsToHome_postcond (D) (L) (minJumpsToHome (D) (L) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_294_p00312