import Mathlib

-- Precondition definitions
@[reducible, simp]
def intersect_tuples_precond (athletes : List (String × Nat)) (teams : List (String × String × List (String × Nat))) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the implementation

-- Main function definitions
def intersect_tuples (athletes : List (String × Nat)) (teams : List (String × String × List (String × Nat))) (h_precond : intersect_tuples_precond athletes teams) : List (String × Nat × String × String) :=
  -- !benchmark @start code
  let result := teams.flatMap λ team =>
      let (team_name, location, team_athletes) := team
      team_athletes.filterMap λ athlete =>
        if athlete ∈ athletes then
          let (name, age) := athlete
          some (name, age, team_name, location)
        else
          none
  result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_member (athlete : String × Nat) (team : String × String × List (String × Nat)) : Prop :=
  let (team_name, location, team_athletes) := team
  athlete ∈ team_athletes

def is_in_athletes_list (athlete : String × Nat) (athletes : List (String × Nat)) : Prop :=
  athlete ∈ athletes

def result_entry_matches (entry : String × Nat × String × String) (athlete : String × Nat) (team : String × String × List (String × Nat)) : Prop :=
  let (name, age, team_name, location) := entry
  let (athlete_name, athlete_age) := athlete
  let (t_name, t_location, _) := team
  name = athlete_name ∧ age = athlete_age ∧ team_name = t_name ∧ location = t_location

-- Postcondition definitions
@[reducible, simp]
def intersect_tuples_postcond (athletes : List (String × Nat)) (teams : List (String × String × List (String × Nat))) (result: List (String × Nat × String × String)) (h_precond : intersect_tuples_precond athletes teams) : Prop :=
  -- !benchmark @start postcond
  ∀ (entry : String × Nat × String × String), entry ∈ result ↔ 
    ∃ (athlete : String × Nat) (team : String × String × List (String × Nat)), 
      athlete ∈ athletes ∧ team ∈ teams ∧ is_member athlete team ∧ result_entry_matches entry athlete team
  -- !benchmark @end postcond


-- Proof content
theorem intersect_tuples_postcond_satisfied (athletes: List (String × Nat)) (teams: List (String × String × List (String × Nat))) (h_precond : intersect_tuples_precond athletes teams) :
    intersect_tuples_postcond athletes teams (intersect_tuples athletes teams h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof