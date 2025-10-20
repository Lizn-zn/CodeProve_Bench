import Mathlib

namespace no_15704_codeexercises_115704


-- Precondition definitions
@[reducible, simp]
def count_even_numbers_precond (matrix : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed since the postcondition helpers are already provided

-- Main function definitions
def count_even_numbers (matrix : List (List Nat)) (h_precond : count_even_numbers_precond (matrix)) : Nat :=
  -- !benchmark @start code
  let is_even (n : Nat) : Bool := n % 2 == 0
  let count_even_in_row (row : List Nat) : Nat := row.filter is_even |>.length
  matrix.foldl (λ acc row => acc + count_even_in_row row) 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_even (n : Nat) : Bool :=
  n % 2 == 0

def count_even_in_row (row : List Nat) : Nat :=
  row.filter is_even |>.length

def total_even_count (matrix : List (List Nat)) : Nat :=
  matrix.foldl (λ acc row => acc + count_even_in_row row) 0

-- Postcondition definitions
@[reducible, simp]
def count_even_numbers_postcond (matrix : List (List Nat)) (result: Nat) (h_precond : count_even_numbers_precond (matrix)) : Prop :=
  -- !benchmark @start postcond
  result = total_even_count matrix
  -- !benchmark @end postcond


-- Proof content
theorem count_even_numbers_postcond_satisfied (matrix: List (List Nat)) (h_precond : count_even_numbers_precond (matrix)) :
    count_even_numbers_postcond (matrix) (count_even_numbers (matrix) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_15704_codeexercises_115704