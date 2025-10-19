import Mathlib

-- Precondition definitions
@[reducible, simp]
def primeFactorization_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  2 ≤ n ∧ n ≤ 10^9
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to perform prime factorization
partial def primeFactorizationAux (n : Nat) (divisor : Nat) (acc : List Nat) : List Nat :=
  if n ≤ 1 then
    acc.reverse
  else if divisor * divisor > n then
    (n :: acc).reverse
  else if n % divisor = 0 then
    primeFactorizationAux (n / divisor) divisor (divisor :: acc)
  else
    let nextDivisor := if divisor = 2 then 3 else divisor + 2
    primeFactorizationAux n nextDivisor acc

-- Main function definitions
def primeFactorization (n : Nat) (h_precond : primeFactorization_precond (n)) : List Nat :=
  -- !benchmark @start code
  primeFactorizationAux n 2 []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if a number is prime
def isPrime (p : Nat) : Prop :=
  p ≥ 2 ∧ ∀ d : Nat, d > 1 → d < p → ¬(p % d = 0)

-- Helper function to compute the product of a list
def listProduct (l : List Nat) : Nat :=
  l.foldl (· * ·) 1

-- Helper function to check if a list is sorted in ascending order
def isSorted (l : List Nat) : Prop :=
  match l with
  | [] => True
  | [_] => True
  | x :: y :: rest => x ≤ y ∧ isSorted (y :: rest)

-- Postcondition definitions
@[reducible, simp]
def primeFactorization_postcond (n : Nat) (result: List Nat) (h_precond : primeFactorization_precond (n)) : Prop :=
  -- !benchmark @start postcond
  -- The result is non-empty
    result.length > 0 ∧
    -- All elements in the result are prime numbers
    (∀ p ∈ result, isPrime p) ∧
    -- The product of all prime factors equals n
    listProduct result = n ∧
    -- The result is sorted in ascending order
    isSorted result
  -- !benchmark @end postcond


-- Proof content
theorem primeFactorization_postcond_satisfied (n: Nat) (h_precond : primeFactorization_precond (n)) :
    primeFactorization_postcond (n) (primeFactorization (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

