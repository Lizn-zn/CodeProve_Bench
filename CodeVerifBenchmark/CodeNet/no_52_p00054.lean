import Mathlib

-- Precondition definitions
@[reducible, simp]
def sumDecimalDigits_precond (a : Nat) (b : Nat) (n : Nat) : Prop :=
  -- !benchmark @start precond
  b > 0
  -- !benchmark @end precond


-- Postcondition auxiliary definitions
-- Helper function to get the i-th decimal digit (1-indexed) of the fraction a/b
def getDecimalDigit (a b : Nat) (i : Nat) : Nat :=
  if b = 0 then 0
  else
    -- Compute (a * 10^i) / b and extract the last digit
    ((a * (10 ^ i)) / b) % 10

-- Helper function to compute the sum of first n decimal digits
def sumFirstNDigits (a b n : Nat) : Nat :=
  match n with
  | 0 => 0
  | k + 1 => sumFirstNDigits a b k + getDecimalDigit a b (k + 1)

-- Code auxiliary definitions
-- Helper function to compute decimal digits iteratively
def computeSumHelper (a b : Nat) (n : Nat) (current : Nat) (sum : Nat) : Nat :=
  if h : current > n then sum
  else
    let digit := getDecimalDigit a b current
    computeSumHelper a b n (current + 1) (sum + digit)
termination_by (n + 1 - current)

-- Main function definitions
def sumDecimalDigits (a : Nat) (b : Nat) (n : Nat) (h_precond : sumDecimalDigits_precond (a) (b) (n)) : Nat :=
  -- !benchmark @start code
  computeSumHelper a b n 1 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def sumDecimalDigits_postcond (a : Nat) (b : Nat) (n : Nat) (result: Nat) (h_precond : sumDecimalDigits_precond (a) (b) (n)) : Prop :=
  -- !benchmark @start postcond
  result = sumFirstNDigits a b n
  -- !benchmark @end postcond


-- Proof content
theorem sumDecimalDigits_postcond_satisfied (a: Nat) (b: Nat) (n: Nat) (h_precond : sumDecimalDigits_precond (a) (b) (n)) :
    sumDecimalDigits_postcond (a) (b) (n) (sumDecimalDigits (a) (b) (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof