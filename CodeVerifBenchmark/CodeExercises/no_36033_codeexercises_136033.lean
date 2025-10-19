import Mathlib

-- Precondition definitions
@[reducible, simp]
def break_and_multiplier_precond (chef_list : List (String × Nat)) (ingredient : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def break_and_multiplier (chef_list : List (String × Nat)) (ingredient : String) (h_precond : break_and_multiplier_precond (chef_list) (ingredient)) : List (String × Nat) :=
  -- !benchmark @start code
  match chef_list with
  | [] => []
  | (name, quantity) :: rest =>
    if name = ingredient then
      (name, quantity * 2) :: rest
    else
      (name, quantity) :: break_and_multiplier rest ingredient h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def find_and_update (l : List (String × Nat)) (ingredient : String) : List (String × Nat) :=
  match l with
  | [] => []
  | (name, quantity) :: rest =>
    if name = ingredient then
      (name, quantity * 2) :: rest
    else
      (name, quantity) :: find_and_update rest ingredient

-- Postcondition definitions
@[reducible, simp]
def break_and_multiplier_postcond (chef_list : List (String × Nat)) (ingredient : String) (result: List (String × Nat)) (h_precond : break_and_multiplier_precond (chef_list) (ingredient)) : Prop :=
  -- !benchmark @start postcond
  result = find_and_update chef_list ingredient
  -- !benchmark @end postcond


-- Proof content
theorem break_and_multiplier_postcond_satisfied (chef_list: List (String × Nat)) (ingredient: String) (h_precond : break_and_multiplier_precond (chef_list) (ingredient)) :
    break_and_multiplier_postcond (chef_list) (ingredient) (break_and_multiplier (chef_list) (ingredient) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

