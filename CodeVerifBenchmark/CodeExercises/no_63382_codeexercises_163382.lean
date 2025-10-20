import Mathlib

namespace no_63382_codeexercises_163382


-- Precondition definitions
@[reducible, simp]
def modify_list_precond (athlete : List α) (start : Nat) (stop : Nat) (new_value : α) : Prop :=
  -- !benchmark @start precond
  start ≤ stop ∧ stop ≤ athlete.length
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def modify_list (athlete : List α) (start : Nat) (stop : Nat) (new_value : α) (h_precond : modify_list_precond (athlete) (start) (stop) (new_value)) : List α :=
  -- !benchmark @start code
  let rec helper (l : List α) (idx : Nat) : List α :=
    match l with
    | [] => []
    | x :: xs => 
      if start ≤ idx ∧ idx < stop then
        new_value :: helper xs (idx + 1)
      else
        x :: helper xs (idx + 1)
  helper athlete 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def modify_list_postcond (athlete : List α) (start : Nat) (stop : Nat) (new_value : α) (result: List α) (h_precond : modify_list_precond (athlete) (start) (stop) (new_value)) : Prop :=
  -- !benchmark @start postcond
  result.length = athlete.length ∧
  ∀ i, if start ≤ i ∧ i < stop then result.get? i = some new_value else result.get? i = athlete.get? i
  -- !benchmark @end postcond


-- Proof content
theorem modify_list_postcond_satisfied (athlete: List α) (start: Nat) (stop: Nat) (new_value: α) (h_precond : modify_list_precond (athlete) (start) (stop) (new_value)) :
    modify_list_postcond (athlete) (start) (stop) (new_value) (modify_list (athlete) (start) (stop) (new_value) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_63382_codeexercises_163382