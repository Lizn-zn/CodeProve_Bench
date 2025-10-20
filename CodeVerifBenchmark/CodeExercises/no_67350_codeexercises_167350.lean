import Mathlib

namespace no_67350_codeexercises_167350


-- Precondition definitions
@[reducible, simp]
def modify_photographer_details_precond (photographer : List (String × String)) (name : String) (new_city : String) : Prop :=
  -- !benchmark @start precond
  photographer.length = 4 ∧
    (∃ name_entry city_entry age_entry exp_entry, 
      photographer = [("name", name_entry), ("city", city_entry), ("age", age_entry), ("experience", exp_entry)] ∧
      age_entry.toNat? ≠ none ∧ exp_entry.toNat? ≠ none)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def modify_photographer_details (photographer : List (String × String)) (name : String) (new_city : String) (h_precond : modify_photographer_details_precond (photographer) (name) (new_city)) : List (String × String) :=
  -- !benchmark @start code
  match photographer with
  | [("name", _), ("city", _), ("age", age), ("experience", exp)] => 
    [("name", name), ("city", new_city), ("age", age), ("experience", exp)]
  | _ => photographer
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def update_photographer_details (photographer : List (String × String)) (name : String) (new_city : String) : List (String × String) :=
  match photographer with
  | [("name", _), ("city", _), ("age", age), ("experience", exp)] => 
    [("name", name), ("city", new_city), ("age", age), ("experience", exp)]
  | _ => photographer

-- Postcondition definitions
@[reducible, simp]
def modify_photographer_details_postcond (photographer : List (String × String)) (name : String) (new_city : String) (result: List (String × String)) (h_precond : modify_photographer_details_precond (photographer) (name) (new_city)) : Prop :=
  -- !benchmark @start postcond
  result = update_photographer_details photographer name new_city
  -- !benchmark @end postcond


-- Proof content
theorem modify_photographer_details_postcond_satisfied (photographer: List (String × String)) (name: String) (new_city: String) (h_precond : modify_photographer_details_precond (photographer) (name) (new_city)) :
    modify_photographer_details_postcond (photographer) (name) (new_city) (modify_photographer_details (photographer) (name) (new_city) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_67350_codeexercises_167350