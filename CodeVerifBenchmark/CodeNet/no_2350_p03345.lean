import Mathlib

namespace no_2350_p03345


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def solve_precond (A : Nat) (B : Nat) (C : Nat) (K : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ A ∧ A ≤ 10^9 ∧
    1 ≤ B ∧ B ≤ 10^9 ∧
    1 ≤ C ∧ C ≤ 10^9 ∧
    K ≤ 10^18
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute (-1)^k * (a - b) efficiently
def computeDiff (a b : Int) (k : Nat) : Int :=
  if k % 2 = 0 then a - b else b - a

-- Main function definitions
def solve (A : Nat) (B : Nat) (C : Nat) (K : Nat) (h_precond : solve_precond (A) (B) (C) (K)) : String :=
  -- !benchmark @start code
  let diff := computeDiff (Int.ofNat A) (Int.ofNat B) K
    if diff.natAbs > 10^18 then
      "Unfair"
    else
      toString diff
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to simulate the operation k times
def simulateOperation (a b c : Int) (k : Nat) : Int × Int × Int :=
  match k with
  | 0 => (a, b, c)
  | k' + 1 =>
    let (a', b', c') := simulateOperation a b c k'
    (b' + c', a' + c', a' + b')

-- Helper function to compute the answer
def computeAnswer (A B C : Nat) (K : Nat) : String :=
  let (finalA, finalB, _) := simulateOperation (Int.ofNat A) (Int.ofNat B) (Int.ofNat C) K
  let diff := finalA - finalB
  if diff.natAbs > 10^18 then
    "Unfair"
  else
    toString diff

-- Postcondition definitions
@[reducible, simp]
def solve_postcond (A : Nat) (B : Nat) (C : Nat) (K : Nat) (result: String) (h_precond : solve_precond (A) (B) (C) (K)) : Prop :=
  -- !benchmark @start postcond
  result = computeAnswer A B C K
  -- !benchmark @end postcond


-- Proof content
theorem solve_postcond_satisfied (A: Nat) (B: Nat) (C: Nat) (K: Nat) (h_precond : solve_precond (A) (B) (C) (K)) :
    solve_postcond (A) (B) (C) (K) (solve (A) (B) (C) (K) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2350_p03345