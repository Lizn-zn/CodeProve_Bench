import Mathlib

-- Precondition definitions
@[reducible, simp]
def sum_natural_numbers_precond (pairs : List (Char × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def sum_aux : List (Char × Nat) → Nat :=
  λ
  | [] => 0
  | (_, n) :: rest => n + sum_aux rest

-- Main function definitions
def sum_natural_numbers (pairs : List (Char × Nat)) (h_precond : sum_natural_numbers_precond (pairs)) : Nat :=
  -- !benchmark @start code
  sum_aux pairs
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def sum_natural_numbers_postcond (pairs : List (Char × Nat)) (result: Nat) (h_precond : sum_natural_numbers_precond (pairs)) : Prop :=
  -- !benchmark @start postcond
  result = (pairs.map Prod.snd).sum
  -- !benchmark @end postcond


-- Proof content
theorem sum_natural_numbers_postcond_satisfied (pairs: List (Char × Nat)) (h_precond : sum_natural_numbers_precond (pairs)) :
    sum_natural_numbers_postcond (pairs) (sum_natural_numbers (pairs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof