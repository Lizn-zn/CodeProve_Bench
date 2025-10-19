import Mathlib

-- Precondition definitions
@[reducible, simp]
def call_for_help_precond (fire_location : String) (smoke_detected : Bool) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def call_for_help (fire_location : String) (smoke_detected : Bool) (h_precond : call_for_help_precond (fire_location) (smoke_detected)) : String :=
  -- !benchmark @start code
  match smoke_detected with
  | true => s!"Calling for backup at {fire_location}. Evacuate immediately due to smoke detection."
  | false => s!"Calling for backup at {fire_location}. No smoke detected, proceed with caution."
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def call_for_help_postcond (fire_location : String) (smoke_detected : Bool) (result: String) (h_precond : call_for_help_precond (fire_location) (smoke_detected)) : Prop :=
  -- !benchmark @start postcond
  match smoke_detected with
  | true => result = s!"Calling for backup at {fire_location}. Evacuate immediately due to smoke detection."
  | false => result = s!"Calling for backup at {fire_location}. No smoke detected, proceed with caution."
  -- !benchmark @end postcond


-- Proof content
theorem call_for_help_postcond_satisfied (fire_location: String) (smoke_detected: Bool) (h_precond : call_for_help_precond (fire_location) (smoke_detected)) :
    call_for_help_postcond (fire_location) (smoke_detected) (call_for_help (fire_location) (smoke_detected) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

