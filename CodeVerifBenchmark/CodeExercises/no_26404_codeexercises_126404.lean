import Mathlib

-- Precondition definitions
@[reducible, simp]
def get_odd_indexes_precond (lst : List α) : Prop :=
  -- !benchmark @start precond
  lst.length ≥ 3
  -- !benchmark @end precond


-- Code auxiliary definitions
def get_odd_indexes_aux : List α → List α
  | [] => []
  | [_] => []
  | _::x::xs => x :: get_odd_indexes_aux xs

-- Main function definitions
def get_odd_indexes (lst : List α) (h_precond : get_odd_indexes_precond (lst)) : List α :=
  -- !benchmark @start code
  match lst with
  | [] => []
  | [_] => []
  | _::x::xs => x :: get_odd_indexes_aux xs
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def get_odd_indexes_aux_post : List α → List α
  | [] => []
  | [_] => []
  | _::x::xs => x :: get_odd_indexes_aux_post xs

-- Postcondition definitions
@[reducible, simp]
def get_odd_indexes_postcond (lst : List α) (result: List α) (h_precond : get_odd_indexes_precond (lst)) : Prop :=
  -- !benchmark @start postcond
  result = get_odd_indexes_aux_post lst
  -- !benchmark @end postcond


-- Proof content
theorem get_odd_indexes_postcond_satisfied (lst: List α) (h_precond : get_odd_indexes_precond (lst)) :
    get_odd_indexes_postcond (lst) (get_odd_indexes (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof