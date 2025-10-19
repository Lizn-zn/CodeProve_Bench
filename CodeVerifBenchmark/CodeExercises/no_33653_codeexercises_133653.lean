import Mathlib

-- Precondition definitions
@[reducible, simp]
def check_tour_precond (location : String) (schedule : List (String × String)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def check_tour (location : String) (schedule : List (String × String)) (h_precond : check_tour_precond (location) (schedule)) : Bool :=
  -- !benchmark @start code
  match schedule with
    | [] => false
    | (loc, _) :: rest => 
      if loc == location then true
      else check_tour location rest h_precond
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def check_tour_postcond (location : String) (schedule : List (String × String)) (result: Bool) (h_precond : check_tour_precond (location) (schedule)) : Prop :=
  -- !benchmark @start postcond
  result = (∃ (concert : String × String), concert ∈ schedule ∧ concert.1 = location)
  -- !benchmark @end postcond


-- Proof content
theorem check_tour_postcond_satisfied (location: String) (schedule: List (String × String)) (h_precond : check_tour_precond (location) (schedule)) :
    check_tour_postcond (location) (schedule) (check_tour (location) (schedule) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

