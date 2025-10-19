import Mathlib

-- Precondition definitions
@[reducible, simp]
def ternary_operator_and_short_circuiting_precond (condition1 : Bool) (condition2 : Bool) (value1 : α) (value2 : α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def ternary_operator_and_short_circuiting (condition1 : Bool) (condition2 : Bool) (value1 : α) (value2 : α) (h_precond : ternary_operator_and_short_circuiting_precond condition1 condition2 value1 value2) : α :=
  -- !benchmark @start code
  if condition1 then (if condition2 then value1 else value2) else value2
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def ternary_operator_and_short_circuiting_postcond (condition1 : Bool) (condition2 : Bool) (value1 : α) (value2 : α) (result: α) (h_precond : ternary_operator_and_short_circuiting_precond condition1 condition2 value1 value2) : Prop :=
  -- !benchmark @start postcond
  result = if condition1 ∧ condition2 then value1 else value2
  -- !benchmark @end postcond


-- Proof content
theorem ternary_operator_and_short_circuiting_postcond_satisfied (condition1: Bool) (condition2: Bool) (value1: α) (value2: α) (h_precond : ternary_operator_and_short_circuiting_precond condition1 condition2 value1 value2) :
    ternary_operator_and_short_circuiting_postcond condition1 condition2 value1 value2 (ternary_operator_and_short_circuiting condition1 condition2 value1 value2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof