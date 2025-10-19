import Mathlib

-- Precondition definitions
@[reducible, simp]
def nested_ternary_short_circuiting_precond (a : Bool) (b : Bool) (c : Bool) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def nested_ternary_short_circuiting (a : Bool) (b : Bool) (c : Bool) (h_precond : nested_ternary_short_circuiting_precond (a) (b) (c)) : String :=
  -- !benchmark @start code
  if a then
      if b then "A" else "B"
    else
      if c then "C" else "D"
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def nested_ternary_short_circuiting_postcond (a : Bool) (b : Bool) (c : Bool) (result: String) (h_precond : nested_ternary_short_circuiting_precond (a) (b) (c)) : Prop :=
  -- !benchmark @start postcond
  match a, b, c with
  | true, true, _ => result = "A"
  | true, false, _ => result = "B"
  | false, _, true => result = "C"
  | false, _, false => result = "D"
  -- !benchmark @end postcond


-- Proof content
theorem nested_ternary_short_circuiting_postcond_satisfied (a: Bool) (b: Bool) (c: Bool) (h_precond : nested_ternary_short_circuiting_precond (a) (b) (c)) :
    nested_ternary_short_circuiting_postcond (a) (b) (c) (nested_ternary_short_circuiting (a) (b) (c) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof