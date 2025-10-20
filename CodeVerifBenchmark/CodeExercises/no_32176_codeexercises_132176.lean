import Mathlib

namespace no_32176_codeexercises_132176


-- Precondition definitions
@[reducible, simp]
def add_new_animal_precond (farmer_list : List String) (animal : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def add_new_animal (farmer_list : List String) (animal : String) (h_precond : add_new_animal_precond (farmer_list) (animal)) : Sum (List String) String :=
  -- !benchmark @start code
  if animal ∈ farmer_list then
    Sum.inr "Animal already exists"
  else
    Sum.inl (farmer_list ++ [animal])
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def add_new_animal_postcond (farmer_list : List String) (animal : String) (result: Sum (List String) String) (h_precond : add_new_animal_precond (farmer_list) (animal)) : Prop :=
  -- !benchmark @start postcond
  match result with
  | Sum.inl updated_list => 
      (animal ∉ farmer_list) ∧ 
      (updated_list = farmer_list ++ [animal])
  | Sum.inr msg => 
      (animal ∈ farmer_list) ∧ 
      (msg = "Animal already exists")
  -- !benchmark @end postcond


-- Proof content
theorem add_new_animal_postcond_satisfied (farmer_list: List String) (animal: String) (h_precond : add_new_animal_precond (farmer_list) (animal)) :
    add_new_animal_postcond (farmer_list) (animal) (add_new_animal (farmer_list) (animal) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_32176_codeexercises_132176