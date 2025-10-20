import Mathlib

namespace no_58104_codeexercises_158104


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def compute_distance_precond (celestial_objects : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Postcondition auxiliary definitions
-- Define a mapping from celestial object names to their distances from Earth
def celestial_distances : List (String × Nat) := [
  ("Moon", 384400),
  ("Sun", 149600000),
  ("Mars", 78340000),
  ("Venus", 41400000),
  ("Mercury", 91691000),
  ("Jupiter", 628730000),
  ("Saturn", 1275000000),
  ("Uranus", 2723950000),
  ("Neptune", 4351400000)
]

-- Helper function to lookup distance for a celestial object
def get_distance (obj : String) : Option Nat :=
  celestial_distances.lookup obj


-- Code auxiliary definitions
-- No additional auxiliary definitions needed beyond what's already provided

-- Main function definitions
def compute_distance (celestial_objects : List String) (h_precond : compute_distance_precond (celestial_objects)) : List Nat :=
  -- !benchmark @start code
  celestial_objects.map fun obj => 
    match get_distance obj with
    | some d => d
    | none => 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def compute_distance_postcond (celestial_objects : List String) (result: List Nat) (h_precond : compute_distance_precond (celestial_objects)) : Prop :=
  -- !benchmark @start postcond
  result.length = celestial_objects.length ∧
  ∀ i : Fin celestial_objects.length, 
    let obj := celestial_objects[i]!
    let dist := result[i]!
    ∃ (d : Nat), get_distance obj = some d ∧ dist = d
  -- !benchmark @end postcond


-- Proof content
theorem compute_distance_postcond_satisfied (celestial_objects: List String) (h_precond : compute_distance_precond (celestial_objects)) :
    compute_distance_postcond (celestial_objects) (compute_distance (celestial_objects) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_58104_codeexercises_158104