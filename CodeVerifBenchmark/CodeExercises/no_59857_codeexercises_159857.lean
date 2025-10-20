import Mathlib

namespace no_59857_codeexercises_159857


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def update_events_precond (events_list : List String) (new_events : List String) : Prop :=
  -- !benchmark @start precond
  List.length new_events ≤ List.length events_list
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for code implementation

-- Main function definitions
def update_events (events_list : List String) (new_events : List String) (h_precond : update_events_precond (events_list) (new_events)) : List String :=
  -- !benchmark @start code
  match new_events with
  | [] => events_list
  | h::t => 
    match events_list with
    | [] => []
    | _::rest => h :: update_events rest t (by
        simp [update_events_precond] at h_precond ⊢
        omega)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Auxiliary definition to model the update operation
def update_list_at_indices (original : List String) (new_elements : List String) : List String :=
  match new_elements with
  | [] => original
  | hd::tl => 
    match original with
    | [] => []
    | _::rest => hd :: update_list_at_indices rest tl

-- Postcondition definitions
@[reducible, simp]
def update_events_postcond (events_list : List String) (new_events : List String) (result: List String) (h_precond : update_events_precond (events_list) (new_events)) : Prop :=
  -- !benchmark @start postcond
  result = update_list_at_indices events_list new_events
  -- !benchmark @end postcond


-- Proof content
theorem update_events_postcond_satisfied (events_list: List String) (new_events: List String) (h_precond : update_events_precond (events_list) (new_events)) :
    update_events_postcond (events_list) (new_events) (update_events (events_list) (new_events) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_59857_codeexercises_159857