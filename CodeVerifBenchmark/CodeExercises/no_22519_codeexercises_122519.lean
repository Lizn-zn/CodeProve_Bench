import Mathlib

namespace no_22519_codeexercises_122519


-- Precondition definitions
@[reducible, simp]
def habitable_areas_precond (animals : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def habitable_areas (animals : List String) (h_precond : habitable_areas_precond (animals)) : List String :=
  -- !benchmark @start code
  let rec process_animals (i : Nat) (processed : List String) (result : List String) : List String :=
    if h : i < animals.length then
      let animal := animals.get ⟨i, h⟩
      if ¬(processed.contains animal) then
        let count := (animals.filter (λ a => a = animal)).length
        let new_processed := processed ++ [animal]
        let new_result := if count > 1 then result ++ [animal] else result
        process_animals (i + 1) new_processed new_result
      else
        process_animals (i + 1) processed result
    else
      result
  process_animals 0 [] []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_duplicate (animals : List String) (animal : String) : Bool :=
  (animals.filter (λ a => a = animal)).length > 1

def duplicates (animals : List String) : List String :=
  animals.dedup.filter (λ animal => is_duplicate animals animal)

-- Postcondition definitions
@[reducible, simp]
def habitable_areas_postcond (animals : List String) (result: List String) (h_precond : habitable_areas_precond (animals)) : Prop :=
  -- !benchmark @start postcond
  result = duplicates animals
  -- !benchmark @end postcond


-- Proof content
theorem habitable_areas_postcond_satisfied (animals: List String) (h_precond : habitable_areas_precond (animals)) :
    habitable_areas_postcond (animals) (habitable_areas (animals) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_22519_codeexercises_122519