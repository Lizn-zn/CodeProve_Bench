import Mathlib

namespace no_95930_codeexercises_195930


-- Precondition definitions
@[reducible, simp]
def get_athlete_details_precond (athlete_id : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
structure AthleteDetails where
  name : String
  sport : String
  age : Nat
  country : String
  deriving Repr

def athlete_database : Nat → Option AthleteDetails := λ
  | 1 => some ⟨"John Doe", "Basketball", 25, "USA"⟩
  | 2 => some ⟨"Jane Smith", "Swimming", 22, "Canada"⟩
  | 3 => some ⟨"Bob Johnson", "Running", 28, "UK"⟩
  | _ => none

-- Main function definitions
def get_athlete_details (athlete_id : Nat) (h_precond : get_athlete_details_precond (athlete_id)) : List (String × String) :=
  -- !benchmark @start code
  match athlete_database athlete_id with
  | some details => 
    [("name", details.name), ("sport", details.sport), ("age", toString details.age), ("country", details.country)]
  | none => []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- No additional auxiliary definitions needed

-- Postcondition definitions
@[reducible, simp]
def get_athlete_details_postcond (athlete_id : Nat) (result: List (String × String)) (h_precond : get_athlete_details_precond (athlete_id)) : Prop :=
  -- !benchmark @start postcond
  match athlete_database athlete_id with
  | some details => 
    result = [("name", details.name), ("sport", details.sport), ("age", toString details.age), ("country", details.country)]
  | none => result = []
  -- !benchmark @end postcond


-- Proof content
theorem get_athlete_details_postcond_satisfied (athlete_id: Nat) (h_precond : get_athlete_details_precond (athlete_id)) :
    get_athlete_details_postcond (athlete_id) (get_athlete_details (athlete_id) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_95930_codeexercises_195930