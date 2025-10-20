import Mathlib

namespace no_2461_codeexercises_102461


-- Precondition auxiliary definitions
structure Animal where
  isSick : Bool
  deriving Repr

-- Precondition definitions
@[reducible, simp]
def find_sick_animals_precond (animal_list : List Animal) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_sick_animals (animal_list : List Animal) (h_precond : find_sick_animals_precond (animal_list)) : List Animal :=
  -- !benchmark @start code
  match animal_list with
  | [] => []
  | a :: as => 
    if a.isSick then
      a :: find_sick_animals as h_precond
    else
      []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def takeWhileSick : List Animal → List Animal
  | [] => []
  | a :: as => if a.isSick then a :: takeWhileSick as else []

-- Postcondition definitions
@[reducible, simp]
def find_sick_animals_postcond (animal_list : List Animal) (result: List Animal) (h_precond : find_sick_animals_precond (animal_list)) : Prop :=
  -- !benchmark @start postcond
  result = takeWhileSick animal_list
  -- !benchmark @end postcond


-- Proof content
theorem find_sick_animals_postcond_satisfied (animal_list: List Animal) (h_precond : find_sick_animals_precond (animal_list)) :
    find_sick_animals_postcond (animal_list) (find_sick_animals (animal_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2461_codeexercises_102461