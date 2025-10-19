import Mathlib

-- Precondition definitions
@[reducible, simp]
def calculate_total_distance_precond (stars : List Float) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def calculate_total_distance (stars : List Float) (h_precond : calculate_total_distance_precond (stars)) : Float :=
  -- !benchmark @start code
  match stars with
    | [] => 0.0
    | hd :: tl => hd + calculate_total_distance tl h_precond
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def calculate_total_distance_postcond (stars : List Float) (result: Float) (h_precond : calculate_total_distance_precond (stars)) : Prop :=
  -- !benchmark @start postcond
  result = stars.sum
  -- !benchmark @end postcond


-- Proof content
theorem calculate_total_distance_postcond_satisfied (stars: List Float) (h_precond : calculate_total_distance_precond (stars)) :
    calculate_total_distance_postcond (stars) (calculate_total_distance (stars) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

