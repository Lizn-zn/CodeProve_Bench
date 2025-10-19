import Mathlib

-- Precondition definitions
@[reducible, simp]
def maxGcdOfSequence_precond (N : Nat) (M : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ N ∧ N ≤ 100000 ∧ N ≤ M ∧ M ≤ 1000000000
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to find the maximum divisor of M that is at most M/N
def findMaxDivisor (M N : Nat) (bound : Nat) (current : Nat) : Nat :=
  if current = 0 then 1
  else if M % current = 0 then current
  else findMaxDivisor M N bound (current - 1)

-- Main helper that starts from M/N and goes down
def findMaxGcd (M N : Nat) : Nat :=
  let bound := M / N
  findMaxDivisor M N bound bound

-- Main function definitions
def maxGcdOfSequence (N : Nat) (M : Nat) (h_precond : maxGcdOfSequence_precond (N) (M)) : Nat :=
  -- !benchmark @start code
  -- The answer is the largest divisor of M that is at most M/N
    -- Starting from M/N, we find the first number that divides M
    findMaxGcd M N
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Check if there exists a valid sequence with given gcd
def existsSequenceWithGcd (N M gcd : Nat) : Prop :=
  gcd > 0 ∧ M % gcd = 0 ∧ M / gcd ≥ N ∧
  ∃ (a : List Nat), 
    a.length = N ∧ 
    (∀ x ∈ a, x > 0) ∧
    a.sum = M ∧
    (∀ x ∈ a, gcd ∣ x) ∧
    Nat.gcd_list a = gcd
  where
    Nat.gcd_list : List Nat → Nat
    | [] => 0
    | [x] => x
    | x :: xs => Nat.gcd x (Nat.gcd_list xs)

-- The maximum gcd is M / N when M is divisible by N, otherwise we need the largest divisor of M that is ≤ M / N
def isMaxGcdOfSequence (N M result : Nat) : Prop :=
  result > 0 ∧
  M % result = 0 ∧
  result ≤ M / N ∧
  existsSequenceWithGcd N M result ∧
  (∀ g : Nat, g > result → ¬existsSequenceWithGcd N M g)

-- Postcondition definitions
@[reducible, simp]
def maxGcdOfSequence_postcond (N : Nat) (M : Nat) (result: Nat) (h_precond : maxGcdOfSequence_precond (N) (M)) : Prop :=
  -- !benchmark @start postcond
  isMaxGcdOfSequence N M result
  -- !benchmark @end postcond


-- Proof content
theorem maxGcdOfSequence_postcond_satisfied (N: Nat) (M: Nat) (h_precond : maxGcdOfSequence_precond (N) (M)) :
    maxGcdOfSequence_postcond (N) (M) (maxGcdOfSequence (N) (M) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

