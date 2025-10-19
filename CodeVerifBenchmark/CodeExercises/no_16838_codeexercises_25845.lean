import Mathlib

-- Precondition definitions
@[reducible, simp]
def check_appointments_precond (vet_schedule : List (String × String × String)) (day : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def check_appointments (vet_schedule : List (String × String × String)) (day : String) (h_precond : check_appointments_precond (vet_schedule) (day)) : List String :=
  -- !benchmark @start code
  let result : List String :=
    vet_schedule.foldl (λ acc appointment =>
      match appointment with
      | (appt_day, _, pet_name) =>
        if appt_day ≠ day then
          pet_name :: acc
        else
          acc) []
  result.reverse
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_appointment_not_on_day (appointment : String × String × String) (day : String) : Bool :=
  match appointment with
  | (appt_day, _, _) => appt_day ≠ day

-- Postcondition definitions
@[reducible, simp]
def check_appointments_postcond (vet_schedule : List (String × String × String)) (day : String) (result: List String) (h_precond : check_appointments_precond (vet_schedule) (day)) : Prop :=
  -- !benchmark @start postcond
  result = (vet_schedule.filter (λ appt => is_appointment_not_on_day appt day)).map (λ appt => match appt with | (_, _, pet_name) => pet_name)
  -- !benchmark @end postcond


-- Proof content
theorem check_appointments_postcond_satisfied (vet_schedule: List (String × String × String)) (day: String) (h_precond : check_appointments_precond (vet_schedule) (day)) :
    check_appointments_postcond (vet_schedule) (day) (check_appointments (vet_schedule) (day) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof