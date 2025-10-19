import Mathlib

-- Precondition definitions
@[reducible, simp]
def check_condition_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def is_valid_element (x : Int) : Bool :=
  x % 2 = 0 ∧ x > 0

-- Main function definitions
def check_condition (lst : List Int) (h_precond : check_condition_precond (lst)) : Nat :=
  -- !benchmark @start code
  match lst with
  | [] => 0
  | x :: xs => 
    if is_valid_element x then
      1 + check_condition xs (by simp [check_condition_precond])
    else
      check_condition xs (by simp [check_condition_precond])
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Postcondition definitions
@[reducible, simp]
def check_condition_postcond (lst : List Int) (result: Nat) (h_precond : check_condition_precond (lst)) : Prop :=
  -- !benchmark @start postcond
  result = (lst.filter (λ x => is_valid_element x)).length
  -- !benchmark @end postcond


-- Proof content
theorem check_condition_postcond_satisfied (lst: List Int) (h_precond : check_condition_precond (lst)) :
    check_condition_postcond (lst) (check_condition (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof