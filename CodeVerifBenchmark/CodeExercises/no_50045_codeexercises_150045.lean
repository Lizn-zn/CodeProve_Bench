import Mathlib

namespace no_50045_codeexercises_150045


-- Precondition definitions
@[reducible, simp]
def get_even_indices_precond (numbers_tuple : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed for this implementation

-- Main function definitions
def get_even_indices (numbers_tuple : List Nat) (h_precond : get_even_indices_precond (numbers_tuple)) : List Nat :=
  -- !benchmark @start code
  match numbers_tuple with
  | [] => []
  | [x] => [x]
  | x :: _ :: xs => x :: get_even_indices xs (by simp [get_even_indices_precond])
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def get_even_indices_helper (nums : List Nat) : List Nat :=
  match nums with
  | [] => []
  | [x] => [x]
  | x :: _ :: xs => x :: get_even_indices_helper xs

-- Postcondition definitions
@[reducible, simp]
def get_even_indices_postcond (numbers_tuple : List Nat) (result: List Nat) (h_precond : get_even_indices_precond (numbers_tuple)) : Prop :=
  -- !benchmark @start postcond
  result = get_even_indices_helper numbers_tuple
  -- !benchmark @end postcond


-- Proof content
theorem get_even_indices_postcond_satisfied (numbers_tuple: List Nat) (h_precond : get_even_indices_precond (numbers_tuple)) :
    get_even_indices_postcond (numbers_tuple) (get_even_indices (numbers_tuple) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_50045_codeexercises_150045