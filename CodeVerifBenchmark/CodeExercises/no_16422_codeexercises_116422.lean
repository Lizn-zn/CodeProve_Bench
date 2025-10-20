import Mathlib

namespace no_16422_codeexercises_116422


-- Precondition definitions
@[reducible, simp]
def find_common_species_precond (species_1 : List String) (species_2 : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple intersection operation

-- Main function definitions
def find_common_species (species_1 : List String) (species_2 : List String) (h_precond : find_common_species_precond (species_1) (species_2)) : List String :=
  -- !benchmark @start code
  species_1.filter (λ s => species_2.contains s)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def find_common_species_postcond (species_1 : List String) (species_2 : List String) (result: List String) (h_precond : find_common_species_precond (species_1) (species_2)) : Prop :=
  -- !benchmark @start postcond
  result = species_1 ∩ species_2
  -- !benchmark @end postcond


-- Proof content
theorem find_common_species_postcond_satisfied (species_1: List String) (species_2: List String) (h_precond : find_common_species_precond (species_1) (species_2)) :
    find_common_species_postcond (species_1) (species_2) (find_common_species (species_1) (species_2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_16422_codeexercises_116422