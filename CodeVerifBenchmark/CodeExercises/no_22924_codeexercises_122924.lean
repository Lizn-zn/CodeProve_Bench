import Mathlib

-- Precondition definitions
@[reducible, simp]
def remove_duplicates_precond (lst : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def remove_duplicates [DecidableEq α] (lst : List α) (h_precond : remove_duplicates_precond (lst)) : List α :=
  -- !benchmark @start code
  match lst with
    | [] => []
    | x :: xs => 
      let rest := remove_duplicates xs h_precond
      if x ∈ rest then rest else x :: rest
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def remove_duplicates_postcond (lst : List α) (result: List α) (h_precond : remove_duplicates_precond (lst)) : Prop :=
  -- !benchmark @start postcond
  result.Nodup ∧ ∀ x : α, x ∈ result ↔ x ∈ lst
  -- !benchmark @end postcond


-- Proof content
theorem remove_duplicates_postcond_satisfied [DecidableEq α] (lst: List α) (h_precond : remove_duplicates_precond (lst)) :
    remove_duplicates_postcond (lst) (remove_duplicates (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof