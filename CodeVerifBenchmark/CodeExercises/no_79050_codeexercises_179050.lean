import Mathlib

-- Precondition definitions
@[reducible, simp]
def add_to_list_precond (numbers_list : List Nat) (value : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def add_to_list (numbers_list : List Nat) (value : Nat) (h_precond : add_to_list_precond (numbers_list) (value)) : List Nat :=
  -- !benchmark @start code
  match numbers_list with
    | [] => []
    | hd :: tl => (hd + value) :: add_to_list tl value h_precond
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def add_to_list_postcond (numbers_list : List Nat) (value : Nat) (result: List Nat) (h_precond : add_to_list_precond (numbers_list) (value)) : Prop :=
  -- !benchmark @start postcond
  result.length = numbers_list.length ∧
  ∀ (i : Fin result.length), result[i]! = numbers_list[i]! + value
  -- !benchmark @end postcond


-- Proof content
theorem add_to_list_postcond_satisfied (numbers_list: List Nat) (value: Nat) (h_precond : add_to_list_precond (numbers_list) (value)) :
    add_to_list_postcond (numbers_list) (value) (add_to_list (numbers_list) (value) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

