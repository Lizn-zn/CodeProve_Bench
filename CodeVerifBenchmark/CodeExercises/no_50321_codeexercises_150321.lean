import Mathlib

-- Precondition definitions
@[reducible, simp]
def flatten_list_precond (nested_list : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def flatten_list (nested_list : List (List Nat)) (h_precond : flatten_list_precond (nested_list)) : List Nat :=
  -- !benchmark @start code
  match nested_list with
  | [] => []
  | hd :: tl => hd ++ flatten_list tl h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def flatten_aux : List (List Nat) → List Nat
  | [] => []
  | hd :: tl => hd ++ flatten_aux tl

-- Postcondition definitions
@[reducible, simp]
def flatten_list_postcond (nested_list : List (List Nat)) (result: List Nat) (h_precond : flatten_list_precond (nested_list)) : Prop :=
  -- !benchmark @start postcond
  result = flatten_aux nested_list
  -- !benchmark @end postcond


-- Proof content
theorem flatten_list_postcond_satisfied (nested_list: List (List Nat)) (h_precond : flatten_list_precond (nested_list)) :
    flatten_list_postcond (nested_list) (flatten_list (nested_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

