import Mathlib

namespace no_53026_codeexercises_153026


-- Precondition definitions
@[reducible, simp]
def get_plate_numbers_precond (license_plates : List (String × String)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def get_plate_numbers (license_plates : List (String × String)) (h_precond : get_plate_numbers_precond (license_plates)) : List String :=
  -- !benchmark @start code
  license_plates.foldl (fun plate_numbers plate => plate_numbers ++ [plate.1]) []
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def get_plate_numbers_postcond (license_plates : List (String × String)) (result: List String) (h_precond : get_plate_numbers_precond (license_plates)) : Prop :=
  -- !benchmark @start postcond
  result = license_plates.map Prod.fst
  -- !benchmark @end postcond


-- Proof content
theorem get_plate_numbers_postcond_satisfied (license_plates: List (String × String)) (h_precond : get_plate_numbers_precond (license_plates)) :
    get_plate_numbers_postcond (license_plates) (get_plate_numbers (license_plates) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_53026_codeexercises_153026