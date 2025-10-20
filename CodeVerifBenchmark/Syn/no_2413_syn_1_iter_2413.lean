import Mathlib

namespace no_2413_syn_1_iter_2413


-- Precondition definitions
@[reducible, simp]
def nat_to_list_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def range_list (n : Nat) : List Nat :=
  match n with
  | 0 => []
  | m+1 => range_list m ++ [m]

-- Main function definitions
def nat_to_list (n : Nat) (h_precond : nat_to_list_precond (n)) : List Nat :=
  -- !benchmark @start code
  match n with
  | 0 => []
  | m+1 => range_list m ++ [m]
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Removed duplicate range_list definition

-- Postcondition definitions
@[reducible, simp]
def nat_to_list_postcond (n : Nat) (result: List Nat) (h_precond : nat_to_list_precond (n)) : Prop :=
  -- !benchmark @start postcond
  result = range_list n
  -- !benchmark @end postcond


-- Proof content
theorem nat_to_list_postcond_satisfied (n: Nat) (h_precond : nat_to_list_precond (n)) :
    nat_to_list_postcond (n) (nat_to_list (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2413_syn_1_iter_2413