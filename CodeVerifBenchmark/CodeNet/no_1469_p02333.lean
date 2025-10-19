import Mathlib

-- Postcondition auxiliary definitions
-- Define the modulo constant
def MOD : Nat := 10^9 + 7

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def ballsAndBoxes3_precond (n : Nat) (k : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ n ∧ n ≤ 1000 ∧ 1 ≤ k ∧ k ≤ 1000
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute modular exponentiation
def modPow (base : Nat) (exp : Nat) (mod : Nat) : Nat :=
  let rec loop (b e acc : Nat) : Nat :=
    if e = 0 then acc
    else if e % 2 = 1 then
      loop ((b * b) % mod) (e / 2) ((acc * b) % mod)
    else
      loop ((b * b) % mod) (e / 2) acc
  loop (base % mod) exp 1

-- Helper function to compute binomial coefficient C(n, k)
def binomial (n k : Nat) : Nat :=
  if k > n then 0
  else Nat.choose n k

-- Helper function to compute the result using inclusion-exclusion
def computeInclusionExclusion (n k : Nat) : Nat :=
  let rec loop (i : Nat) (acc : Int) : Int :=
    if i ≥ k then acc
    else
      let binom := binomial k i
      let power := modPow (k - i) n MOD
      let term := (binom % MOD) * power % MOD
      let signedTerm := if i % 2 = 0 then (term : Int) else -(term : Int)
      loop (i + 1) (acc + signedTerm)
  let result := loop 0 0
  let finalResult := result % (MOD : Int)
  if finalResult < 0 then
    ((finalResult + MOD) % MOD).toNat
  else
    finalResult.toNat

-- Main function definitions
def ballsAndBoxes3 (n : Nat) (k : Nat) (h_precond : ballsAndBoxes3_precond (n) (k)) : Nat :=
  -- !benchmark @start code
  if k > n then
      0
    else
      computeInclusionExclusion n k
  -- !benchmark @end code


-- A surjective function from balls to boxes represents a valid distribution
-- where each box contains at least one ball
def isSurjectiveDistribution (n k : Nat) (f : Fin n → Fin k) : Prop :=
  ∀ box : Fin k, ∃ ball : Fin n, f ball = box

-- Count of surjective functions from n balls to k boxes
def countSurjectiveFunctions (n k : Nat) : Nat :=
  if n < k then 0
  else
    -- This represents the number of ways to distribute n distinguishable balls
    -- into k distinguishable boxes such that each box has at least one ball
    -- This is computed using the inclusion-exclusion principle:
    -- Sum over i from 0 to k-1 of (-1)^i * C(k,i) * (k-i)^n
    -- where C(k,i) is the binomial coefficient
    let rec computeSum (i : Nat) (acc : Int) : Int :=
      if i ≥ k then acc
      else
        let binom := Nat.choose k i
        let power := (k - i) ^ n
        let term := binom * power
        let signedTerm := if i % 2 = 0 then (term : Int) else -(term : Int)
        computeSum (i + 1) (acc + signedTerm)
    (computeSum 0 0).toNat % MOD

-- Postcondition definitions
@[reducible, simp]
def ballsAndBoxes3_postcond (n : Nat) (k : Nat) (result: Nat) (h_precond : ballsAndBoxes3_precond (n) (k)) : Prop :=
  -- !benchmark @start postcond
  -- The result should be the count of surjective functions modulo MOD
  result = countSurjectiveFunctions n k ∧
  -- When k > n, it's impossible to have at least one ball in each box
  (k > n → result = 0) ∧
  -- When k ≤ n, the result represents the number of onto functions
  (k ≤ n → result < MOD)
  -- !benchmark @end postcond


-- Proof content
theorem ballsAndBoxes3_postcond_satisfied (n: Nat) (k: Nat) (h_precond : ballsAndBoxes3_precond (n) (k)) :
    ballsAndBoxes3_postcond (n) (k) (ballsAndBoxes3 (n) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof