import Mathlib

-- Precondition definitions
@[reducible, simp]
def break_inside_loop_precond (iterable : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this function

-- Main function definitions
def break_inside_loop (iterable : List Nat) (h_precond : break_inside_loop_precond (iterable)) : Option Nat :=
  -- !benchmark @start code
  match List.find? (λ x => x = 50) iterable with
  | some x => some x
  | none => none
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def break_inside_loop_postcond (iterable : List Nat) (result: Option Nat) (h_precond : break_inside_loop_precond (iterable)) : Prop :=
  -- !benchmark @start postcond
  match List.find? (λ x => x = 50) iterable with
  | some x => result = some x
  | none => result = none
  -- !benchmark @end postcond


-- Proof content
theorem break_inside_loop_postcond_satisfied (iterable: List Nat) (h_precond : break_inside_loop_precond (iterable)) :
    break_inside_loop_postcond (iterable) (break_inside_loop (iterable) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

