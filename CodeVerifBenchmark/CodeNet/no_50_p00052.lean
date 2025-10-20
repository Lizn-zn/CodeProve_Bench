import Mathlib

namespace no_50_p00052


-- Precondition definitions
@[reducible, simp]
def countTrailingZeros_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  n ≤ 20000
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def countTrailingZeros (n : Nat) (h_precond : countTrailingZeros_precond (n)) : Nat :=
  -- !benchmark @start code
  -- Count trailing zeros by counting factors of 5 in n!
  -- Since there are always more factors of 2 than 5, we only need to count 5s
  let rec countFives (num : Nat) (acc : Nat) : Nat :=
    if num < 5 then acc
    else 
      let quotient := num / 5
      countFives quotient (acc + quotient)
  decreasing_by sorry
  countFives n 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Count the number of times a prime p divides n!
def countPrimeInFactorial (n : Nat) (p : Nat) : Nat :=
  if p ≤ 1 then 0
  else
    let rec loop (pk : Nat) (acc : Nat) : Nat :=
      if pk > n then acc
      else loop (pk * p) (acc + n / pk)
    decreasing_by sorry
    loop p 0

-- The number of trailing zeros in n! equals min(count of 2s, count of 5s) in the prime factorization
-- Since there are always more 2s than 5s in n!, it equals the count of 5s
def trailingZerosInFactorial (n : Nat) : Nat :=
  countPrimeInFactorial n 5

-- Postcondition definitions
@[reducible, simp]
def countTrailingZeros_postcond (n : Nat) (result: Nat) (h_precond : countTrailingZeros_precond (n)) : Prop :=
  -- !benchmark @start postcond
  result = trailingZerosInFactorial n
  -- !benchmark @end postcond


-- Proof content
theorem countTrailingZeros_postcond_satisfied (n: Nat) (h_precond : countTrailingZeros_precond (n)) :
    countTrailingZeros_postcond (n) (countTrailingZeros (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_50_p00052