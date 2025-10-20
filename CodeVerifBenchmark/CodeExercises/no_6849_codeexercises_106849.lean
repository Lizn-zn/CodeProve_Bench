import Mathlib

namespace no_6849_codeexercises_106849


-- Precondition definitions
@[reducible, simp]
def sum_first_n_numbers_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def sum_first_n_numbers (n : Nat) (h_precond : sum_first_n_numbers_precond n) : Nat :=
  -- !benchmark @start code
  match n with
  | 0 => 0
  | n + 1 => (n + 1) + sum_first_n_numbers n h_precond
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def sum_first_n_numbers_postcond (n : Nat) (result : Nat) (h_precond : sum_first_n_numbers_precond n) : Prop :=
  -- !benchmark @start postcond
  result = n * (n + 1) / 2
  -- !benchmark @end postcond


-- Proof content
theorem sum_first_n_numbers_correct (n : Nat) (h_precond : sum_first_n_numbers_precond n) : 
    sum_first_n_numbers_postcond n (sum_first_n_numbers n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_6849_codeexercises_106849