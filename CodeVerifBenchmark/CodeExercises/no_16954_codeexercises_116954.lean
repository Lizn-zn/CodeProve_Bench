import Mathlib

namespace no_16954_codeexercises_116954


-- Precondition definitions
@[reducible, simp]
def farmer_animals_precond (animals : List (List String)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def farmer_animals (animals : List (List String)) (h_precond : farmer_animals_precond (animals)) : List String :=
  -- !benchmark @start code
  match animals with
  | [] => []
  | hd::tl => hd ++ farmer_animals tl h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def flatten (lists : List (List α)) : List α :=
  lists.foldl (fun acc list => acc ++ list) []

-- Postcondition definitions
@[reducible, simp]
def farmer_animals_postcond (animals : List (List String)) (result: List String) (h_precond : farmer_animals_precond (animals)) : Prop :=
  -- !benchmark @start postcond
  result = flatten animals
  -- !benchmark @end postcond


-- Proof content
theorem farmer_animals_postcond_satisfied (animals: List (List String)) (h_precond : farmer_animals_precond (animals)) :
    farmer_animals_postcond (animals) (farmer_animals (animals) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_16954_codeexercises_116954