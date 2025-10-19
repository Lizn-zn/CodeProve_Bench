import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def find_closest_animal_precond (weight : Float) (animals : List (String × Float)) : Prop :=
  -- !benchmark @start precond
  animals ≠ [] ∧ ∀ (animal : String × Float), animal ∈ animals → animal.snd ≥ 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the main implementation

-- Main function definitions
def find_closest_animal (weight : Float) (animals : List (String × Float)) (h_precond : find_closest_animal_precond (weight) (animals)) : String :=
  -- !benchmark @start code
  match animals with
  | [] => by
    exfalso
    exact h_precond.left rfl
  | (name, w) :: rest =>
    let (closest_name, _) := rest.foldl (λ (best : String × Float) (current : String × Float) =>
      let current_diff := Float.abs (current.snd - weight)
      let best_diff := Float.abs (best.snd - weight)
      if current_diff < best_diff then current else best) (name, w)
    closest_name
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def find_closest_animal_aux (weight : Float) (animals : List (String × Float)) : String :=
  match animals with
  | [] => ""
  | (name, w) :: rest =>
    let (closest_name, _) := rest.foldl (λ (best : String × Float) (current : String × Float) =>
      let current_diff := Float.abs (current.snd - weight)
      let best_diff := Float.abs (best.snd - weight)
      if current_diff < best_diff then current else best) (name, w)
    closest_name

-- Postcondition definitions
@[reducible, simp]
def find_closest_animal_postcond (weight : Float) (animals : List (String × Float)) (result: String) (h_precond : find_closest_animal_precond (weight) (animals)) : Prop :=
  -- !benchmark @start postcond
  ∃ (animal : String × Float), 
    animal ∈ animals ∧ 
    animal.fst = result ∧ 
    ∀ (other : String × Float), 
      other ∈ animals → 
      Float.abs (animal.snd - weight) ≤ Float.abs (other.snd - weight)
  -- !benchmark @end postcond


-- Proof content
theorem find_closest_animal_postcond_satisfied (weight: Float) (animals: List (String × Float)) (h_precond : find_closest_animal_precond (weight) (animals)) :
    find_closest_animal_postcond (weight) (animals) (find_closest_animal (weight) (animals) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

