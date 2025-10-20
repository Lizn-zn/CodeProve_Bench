import Mathlib

namespace no_72208_codeexercises_172208


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def find_common_divisors_precond (a : Nat) (b : Nat) : Prop :=
  -- !benchmark @start precond
  a > 0 ∧ b > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def find_common_divisors (a : Nat) (b : Nat) (h_precond : find_common_divisors_precond (a) (b)) : Nat :=
  -- !benchmark @start code
  let gcd_val := Nat.gcd a b
  (Finset.filter (λ d => gcd_val % d = 0) (Finset.Icc 1 gcd_val)).card
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_common_divisors (a b : Nat) : Nat :=
  let divisors_a := Finset.filter (λ d => a % d = 0) (Finset.Icc 1 a)
  let divisors_b := Finset.filter (λ d => b % d = 0) (Finset.Icc 1 b)
  (divisors_a ∩ divisors_b).card

-- Postcondition definitions
@[reducible, simp]
def find_common_divisors_postcond (a : Nat) (b : Nat) (result: Nat) (h_precond : find_common_divisors_precond (a) (b)) : Prop :=
  -- !benchmark @start postcond
  result = count_common_divisors a b
  -- !benchmark @end postcond


-- Proof content
theorem find_common_divisors_postcond_satisfied (a: Nat) (b: Nat) (h_precond : find_common_divisors_precond (a) (b)) :
    find_common_divisors_postcond (a) (b) (find_common_divisors (a) (b) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_72208_codeexercises_172208