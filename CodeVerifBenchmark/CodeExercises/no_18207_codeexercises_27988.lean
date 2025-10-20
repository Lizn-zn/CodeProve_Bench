import Mathlib

namespace no_18207_codeexercises_27988


-- Precondition auxiliary definitions
def light_year_to_parsec : Float := 0.306601
def light_year_to_au : Float := 63241.1

-- Precondition definitions
@[reducible, simp]
def calculate_distance_between_stars_precond (star1_distance : Option Float) (star2_distance : Option Float) (unit : Option String) : Prop :=
  -- !benchmark @start precond
  star1_distance.isSome ∧ star2_distance.isSome ∧ unit.isSome ∧
  ∃ s1, star1_distance = some s1 ∧ s1 ≥ 0 ∧
  ∃ s2, star2_distance = some s2 ∧ s2 ≥ 0 ∧
  ∃ u, unit = some u ∧ (u = "light years" ∨ u = "parsecs" ∨ u = "astronomical units")
  -- !benchmark @end precond


-- Code auxiliary definitions
def convert_distance (distance_ly : Float) (unit : String) : Float :=
  match unit with
  | "light years" => distance_ly
  | "parsecs" => distance_ly * light_year_to_parsec
  | "astronomical units" => distance_ly * light_year_to_au
  | _ => 0

-- Main function definitions
def calculate_distance_between_stars (star1_distance : Option Float) (star2_distance : Option Float) (unit : Option String) (h_precond : calculate_distance_between_stars_precond (star1_distance) (star2_distance) (unit)) : Option Float :=
  -- !benchmark @start code
  match star1_distance, star2_distance, unit with
  | some s1, some s2, some u =>
    let distance_ly := Float.abs (s1 - s2)
    some (convert_distance distance_ly u)
  | _, _, _ => none
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- (convert_distance is now defined above and can be used in postcondition)

-- Postcondition definitions
@[reducible, simp]
def calculate_distance_between_stars_postcond (star1_distance : Option Float) (star2_distance : Option Float) (unit : Option String) (result: Option Float) (h_precond : calculate_distance_between_stars_precond (star1_distance) (star2_distance) (unit)) : Prop :=
  -- !benchmark @start postcond
  ∃ s1, star1_distance = some s1 ∧
  ∃ s2, star2_distance = some s2 ∧
  ∃ u, unit = some u ∧
  ∃ dist, result = some dist ∧ dist = convert_distance (Float.abs (s1 - s2)) u
  -- !benchmark @end postcond


-- Proof content
theorem calculate_distance_between_stars_postcond_satisfied (star1_distance: Option Float) (star2_distance: Option Float) (unit: Option String) (h_precond : calculate_distance_between_stars_precond (star1_distance) (star2_distance) (unit)) :
    calculate_distance_between_stars_postcond (star1_distance) (star2_distance) (unit) (calculate_distance_between_stars (star1_distance) (star2_distance) (unit) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_18207_codeexercises_27988