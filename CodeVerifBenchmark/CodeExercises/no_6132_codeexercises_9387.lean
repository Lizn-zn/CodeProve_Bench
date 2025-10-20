import Mathlib

namespace no_6132_codeexercises_9387


-- Precondition definitions
@[reducible, simp]
def is_perfect_square_precond (number : Nat) : Prop :=
  -- !benchmark @start precond
  number > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def is_perfect_square (number : Nat) (h_precond : is_perfect_square_precond (number)) : Bool :=
  -- !benchmark @start code
  if number == 1 then
    true
  else
    let sqrt_approx := Nat.sqrt number
    sqrt_approx * sqrt_approx == number
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def is_perfect_square_postcond (number : Nat) (result: Bool) (h_precond : is_perfect_square_precond (number)) : Prop :=
  -- !benchmark @start postcond
  ∃ (k : Nat), k * k = number ↔ result = true
  -- !benchmark @end postcond


-- Proof content
theorem is_perfect_square_postcond_satisfied (number: Nat) (h_precond : is_perfect_square_precond (number)) :
    is_perfect_square_postcond (number) (is_perfect_square (number) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_6132_codeexercises_9387