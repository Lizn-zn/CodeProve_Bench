import Mathlib

namespace no_84677_codeexercises_184677


-- Precondition definitions
@[reducible, simp]
def calculate_total_distance_precond (therapy_sessions : List Float) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def calculate_total_distance (therapy_sessions : List Float) (h_precond : calculate_total_distance_precond (therapy_sessions)) : Float :=
  -- !benchmark @start code
  match therapy_sessions with
  | [] => 0.0
  | h :: t => h + calculate_total_distance t h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sum_list (l : List Float) : Float :=
  match l with
  | [] => 0.0
  | h :: t => h + sum_list t

-- Postcondition definitions
@[reducible, simp]
def calculate_total_distance_postcond (therapy_sessions : List Float) (result: Float) (h_precond : calculate_total_distance_precond (therapy_sessions)) : Prop :=
  -- !benchmark @start postcond
  result = sum_list therapy_sessions
  -- !benchmark @end postcond


-- Proof content
theorem calculate_total_distance_postcond_satisfied (therapy_sessions: List Float) (h_precond : calculate_total_distance_precond (therapy_sessions)) :
    calculate_total_distance_postcond (therapy_sessions) (calculate_total_distance (therapy_sessions) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_84677_codeexercises_184677