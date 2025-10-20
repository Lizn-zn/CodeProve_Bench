import Mathlib

namespace no_34249_codeexercises_52794


-- Precondition definitions
@[reducible, simp]
def print_even_squares_precond (numbers : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def is_even (n : Nat) : Bool := n % 2 == 0

def is_divisible_by_five (n : Nat) : Bool := n % 5 == 0

-- Main function definitions
def print_even_squares (numbers : List Nat) (h_precond : print_even_squares_precond numbers) : List Nat :=
  -- !benchmark @start code
  numbers.filterMap (λ n => 
    if is_divisible_by_five n then none
    else if is_even n then some (n * n)
    else none)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- (is_even and is_divisible_by_five moved to code auxiliary definitions)

-- Postcondition definitions
@[reducible, simp]
def print_even_squares_postcond (numbers : List Nat) (result : List Nat) (h_precond : print_even_squares_precond numbers) : Prop :=
  -- !benchmark @start postcond
  let filtered_numbers := numbers.filter (λ n => is_even n ∧ ¬is_divisible_by_five n)
  result = filtered_numbers.map (λ n => n * n)
  -- !benchmark @end postcond


-- Proof content
theorem print_even_squares_postcond_satisfied (numbers : List Nat) (h_precond : print_even_squares_precond numbers) :
    print_even_squares_postcond numbers (print_even_squares numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_34249_codeexercises_52794