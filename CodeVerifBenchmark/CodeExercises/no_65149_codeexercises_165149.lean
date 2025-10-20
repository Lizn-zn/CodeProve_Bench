import Mathlib

namespace no_65149_codeexercises_165149


-- Precondition definitions
@[reducible, simp]
def find_modulus_of_numbers_precond (numbers : List Nat) (divisor : Nat) : Prop :=
  -- !benchmark @start precond
  divisor > 0
  -- !benchmark @end precond


-- Main function definitions
def find_modulus_of_numbers (numbers : List Nat) (divisor : Nat) (h_precond : find_modulus_of_numbers_precond (numbers) (divisor)) : List Nat :=
  -- !benchmark @start code
  match numbers with
    | [] => []
    | x :: xs => (x % divisor) :: find_modulus_of_numbers xs divisor h_precond
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def find_modulus_of_numbers_postcond (numbers : List Nat) (divisor : Nat) (result: List Nat) (h_precond : find_modulus_of_numbers_precond (numbers) (divisor)) : Prop :=
  -- !benchmark @start postcond
  result.length = numbers.length ∧
  ∀ i : Fin numbers.length, result[i]! = numbers[i]! % divisor
  -- !benchmark @end postcond


-- Proof content
theorem find_modulus_of_numbers_postcond_satisfied (numbers: List Nat) (divisor: Nat) (h_precond : find_modulus_of_numbers_precond (numbers) (divisor)) :
    find_modulus_of_numbers_postcond (numbers) (divisor) (find_modulus_of_numbers (numbers) (divisor) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_65149_codeexercises_165149