import Mathlib

-- Precondition definitions
@[reducible, simp]
def list_length_precond (lst : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def list_length (lst : List Nat) (h_precond : list_length_precond (lst)) : Nat :=
  -- !benchmark @start code
  match lst with
  | [] => 0
  | _ :: xs => 1 + list_length xs h_precond
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def list_length_postcond (lst : List Nat) (result: Nat) (h_precond : list_length_precond (lst)) : Prop :=
  -- !benchmark @start postcond
  result = lst.length
  -- !benchmark @end postcond


-- Proof content
theorem list_length_postcond_satisfied (lst: List Nat) (h_precond : list_length_precond (lst)) :
    list_length_postcond (lst) (list_length (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

