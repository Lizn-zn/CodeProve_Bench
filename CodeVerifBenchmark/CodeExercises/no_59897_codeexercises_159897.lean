import Mathlib

-- Precondition definitions
@[reducible, simp]
def athlete_stats_precond (salary : Float) (points_per_game : Float) (minutes_played : Float) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def athlete_stats (salary : Float) (points_per_game : Float) (minutes_played : Float) (h_precond : athlete_stats_precond (salary) (points_per_game) (minutes_played)) : String :=
  -- !benchmark @start code
  if salary > 10000000.0 then
      if points_per_game > 30.0 then
        "Superstar"
      else
        "Star"
    else
      if points_per_game ≤ 10.0 then
        "Role Player"
      else
        "Benchwarmer"
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def athlete_stats_postcond (salary : Float) (points_per_game : Float) (minutes_played : Float) (result: String) (h_precond : athlete_stats_precond (salary) (points_per_game) (minutes_played)) : Prop :=
  -- !benchmark @start postcond
  if salary > 10000000.0 ∧ points_per_game > 30.0 then
    result = "Superstar"
  else if salary > 10000000.0 then
    result = "Star"
  else if salary ≤ 10000000.0 ∧ points_per_game ≤ 10.0 then
    result = "Role Player"
  else
    result = "Benchwarmer"
  -- !benchmark @end postcond


-- Proof content
theorem athlete_stats_postcond_satisfied (salary: Float) (points_per_game: Float) (minutes_played: Float) (h_precond : athlete_stats_precond (salary) (points_per_game) (minutes_played)) :
    athlete_stats_postcond (salary) (points_per_game) (minutes_played) (athlete_stats (salary) (points_per_game) (minutes_played) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

