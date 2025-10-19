import Mathlib

-- Precondition definitions
@[reducible, simp]
def count_even_numbers_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def count_even_numbers (numbers : List Int) (h_precond : count_even_numbers_precond (numbers)) : Nat :=
  -- !benchmark @start code
  match numbers with
  | [] => 0
  | x :: xs => 
    let rest := count_even_numbers xs h_precond
    if x % 2 = 0 then rest + 1 else rest
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_even (n : Int) : Bool := n % 2 = 0

-- Postcondition definitions
@[reducible, simp]
def count_even_numbers_postcond (numbers : List Int) (result: Nat) (h_precond : count_even_numbers_precond (numbers)) : Prop :=
  -- !benchmark @start postcond
  result = (numbers.filter is_even).length
  -- !benchmark @end postcond


-- Proof content
theorem count_even_numbers_postcond_satisfied (numbers: List Int) (h_precond : count_even_numbers_precond (numbers)) :
    count_even_numbers_postcond (numbers) (count_even_numbers (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

