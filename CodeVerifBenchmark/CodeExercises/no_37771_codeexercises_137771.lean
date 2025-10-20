import Mathlib

namespace no_37771_codeexercises_137771


-- Precondition definitions
@[reducible, simp]
def delete_odd_numbers_precond (numbers : List Nat) : Prop :=
  -- !benchmark @start precond
  ∀ x ∈ numbers, x > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def delete_odd_numbers (numbers : List Nat) (h_precond : delete_odd_numbers_precond (numbers)) : List Nat :=
  -- !benchmark @start code
  numbers.filter (λ x => x % 2 = 0)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_even (n : Nat) : Bool := n % 2 = 0

-- Postcondition definitions
@[reducible, simp]
def delete_odd_numbers_postcond (numbers : List Nat) (result: List Nat) (h_precond : delete_odd_numbers_precond (numbers)) : Prop :=
  -- !benchmark @start postcond
  result = numbers.filter is_even
  -- !benchmark @end postcond


-- Proof content
theorem delete_odd_numbers_postcond_satisfied (numbers: List Nat) (h_precond : delete_odd_numbers_precond (numbers)) :
    delete_odd_numbers_postcond (numbers) (delete_odd_numbers (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_37771_codeexercises_137771