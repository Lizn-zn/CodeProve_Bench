import Mathlib

-- Precondition definitions
@[reducible, simp]
def xor_shortcircuit_precond (a : Bool) (b : Bool) (c : Bool) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def xor_shortcircuit (a : Bool) (b : Bool) (c : Bool) (h_precond : xor_shortcircuit_precond (a) (b) (c)) : Bool :=
  -- !benchmark @start code
  if a then
    if b then
      c
    else
      !c
  else
    if b then
      !c
    else
      c
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def xor_shortcircuit_postcond (a : Bool) (b : Bool) (c : Bool) (result: Bool) (h_precond : xor_shortcircuit_precond (a) (b) (c)) : Prop :=
  -- !benchmark @start postcond
  result = (xor (xor a b) c)
  -- !benchmark @end postcond


-- Proof content
theorem xor_shortcircuit_postcond_satisfied (a: Bool) (b: Bool) (c: Bool) (h_precond : xor_shortcircuit_precond (a) (b) (c)) :
    xor_shortcircuit_postcond (a) (b) (c) (xor_shortcircuit (a) (b) (c) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof