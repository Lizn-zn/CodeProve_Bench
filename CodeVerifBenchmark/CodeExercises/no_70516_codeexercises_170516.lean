import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_unexplored_planets_precond (planets : List (String × Bool)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the implementation

-- Main function definitions
def find_unexplored_planets (planets : List (String × Bool)) (h_precond : find_unexplored_planets_precond (planets)) : List String :=
  -- !benchmark @start code
  (planets.filter (λ p => ¬p.2)).map (λ p => p.1)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_unexplored (planet : String × Bool) : Bool :=
  match planet with
  | (_, explored) => ¬explored

def get_planet_name (planet : String × Bool) : String :=
  planet.1

-- Postcondition definitions
@[reducible, simp]
def find_unexplored_planets_postcond (planets : List (String × Bool)) (result: List String) (h_precond : find_unexplored_planets_precond (planets)) : Prop :=
  -- !benchmark @start postcond
  result = (planets.filter is_unexplored).map get_planet_name
  -- !benchmark @end postcond


-- Proof content
theorem find_unexplored_planets_postcond_satisfied (planets: List (String × Bool)) (h_precond : find_unexplored_planets_precond (planets)) :
    find_unexplored_planets_postcond (planets) (find_unexplored_planets (planets) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

