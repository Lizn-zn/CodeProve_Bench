import Mathlib

-- Precondition definitions
@[reducible, simp]
def factorial_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ n ∧ n ≤ 20
  -- !benchmark @end precond


-- Main function definitions
def factorial (n : Nat) (h_precond : factorial_precond (n)) : Nat :=
  -- !benchmark @start code
  Id.run do
    let mut base := 1
    for i in [0:n] do
      base := base * (i + 1)
    return base
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Define factorial function for specification
def fact : Nat → Nat
  | 0 => 1
  | n + 1 => (n + 1) * fact n

-- Postcondition definitions
@[reducible, simp]
def factorial_postcond (n : Nat) (result: Nat) (h_precond : factorial_precond (n)) : Prop :=
  -- !benchmark @start postcond
  result = fact n
  -- !benchmark @end postcond


-- Proof content
theorem factorial_postcond_satisfied (n: Nat) (h_precond : factorial_precond (n)) :
    factorial_postcond (n) (factorial (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof