import Mathlib

namespace no_4085_codeexercises_6218


-- Precondition definitions
@[reducible, simp]
def create_unique_animal_set_precond (animal_list : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def create_unique_animal_set (animal_list : List String) (h_precond : create_unique_animal_set_precond (animal_list)) : Set String :=
  -- !benchmark @start code
  let unique_animals : List String := animal_list.eraseDups
  {x | x ∈ unique_animals}
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def create_unique_animal_set_postcond (animal_list : List String) (result: Set String) (h_precond : create_unique_animal_set_precond (animal_list)) : Prop :=
  -- !benchmark @start postcond
  result = {x | x ∈ animal_list}
  -- !benchmark @end postcond


-- Proof content
theorem create_unique_animal_set_postcond_satisfied (animal_list: List String) (h_precond : create_unique_animal_set_precond (animal_list)) :
    create_unique_animal_set_postcond (animal_list) (create_unique_animal_set (animal_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_4085_codeexercises_6218