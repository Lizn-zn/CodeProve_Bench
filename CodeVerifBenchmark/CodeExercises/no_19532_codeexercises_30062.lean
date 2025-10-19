import Mathlib

-- Precondition definitions
@[reducible, simp]
def get_actors_precond (actors_string : String) : Prop :=
  -- !benchmark @start precond
  actors_string.startsWith "[" ∧ actors_string.endsWith "]" ∧ actors_string.length > 2
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed beyond what's already provided in postcond_aux

-- Main function definitions
def get_actors (actors_string : String) (h_precond : get_actors_precond (actors_string)) : List String :=
  -- !benchmark @start code
  let inner := actors_string.drop 1 |>.dropRight 1
  let names := inner.splitOn ", " |>.map (fun name => name.trim) |>.filter (· ≠ "")
  names.eraseDup
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def extractNames (s : String) : List String :=
  let inner := s.drop 1 |>.dropRight 1
  inner.splitOn ", " |>.map (fun name => name.trim) |>.filter (· ≠ "")

-- Postcondition definitions
@[reducible, simp]
def get_actors_postcond (actors_string : String) (result: List String) (h_precond : get_actors_precond (actors_string)) : Prop :=
  -- !benchmark @start postcond
  let names := extractNames actors_string
  result = names.eraseDup ∧ result.length ≤ names.length
  -- !benchmark @end postcond


-- Proof content
theorem get_actors_postcond_satisfied (actors_string: String) (h_precond : get_actors_precond (actors_string)) :
    get_actors_postcond (actors_string) (get_actors (actors_string) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof