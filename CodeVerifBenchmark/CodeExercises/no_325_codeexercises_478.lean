import Mathlib

namespace no_325_codeexercises_478


-- Precondition definitions
@[reducible, simp]
def return_color_data_precond (color : String) : Prop :=
  -- !benchmark @start precond
  color = "red" ∨ color = "green" ∨ color = "blue"
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple function

-- Main function definitions
def return_color_data (color : String) (h_precond : return_color_data_precond color) : Nat × Nat × Nat :=
  -- !benchmark @start code
  if h : color = "red" then
    (255, 0, 0)
  else if h : color = "green" then
    (0, 255, 0)
  else
    (0, 0, 255)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def return_color_data_postcond (color : String) (result : Nat × Nat × Nat) (h_precond : return_color_data_precond color) : Prop :=
  -- !benchmark @start postcond
  match color with
  | "red" => result = (255, 0, 0)
  | "green" => result = (0, 255, 0)
  | "blue" => result = (0, 0, 255)
  | _ => False
  -- !benchmark @end postcond


-- Proof content
theorem return_color_data_postcond_satisfied (color: String) (h_precond : return_color_data_precond color) :
    return_color_data_postcond color (return_color_data color h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_325_codeexercises_478