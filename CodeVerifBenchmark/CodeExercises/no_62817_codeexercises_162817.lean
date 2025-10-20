import Mathlib

namespace no_62817_codeexercises_162817


-- Precondition definitions
@[reducible, simp]
def fix_exercise_data_precond (data : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def fix_exercise_data (data : List String) (h_precond : fix_exercise_data_precond (data)) : List String :=
  -- !benchmark @start code
  match data with
  | [] => []
  | x :: xs => 
    if x = "X" then "Y" :: fix_exercise_data xs h_precond
    else x :: fix_exercise_data xs h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def replace_X_with_Y : List String → List String
  | [] => []
  | x :: xs => 
    if x = "X" then "Y" :: replace_X_with_Y xs
    else x :: replace_X_with_Y xs

-- Postcondition definitions
@[reducible, simp]
def fix_exercise_data_postcond (data : List String) (result: List String) (h_precond : fix_exercise_data_precond (data)) : Prop :=
  -- !benchmark @start postcond
  result = replace_X_with_Y data
  -- !benchmark @end postcond


-- Proof content
theorem fix_exercise_data_postcond_satisfied (data: List String) (h_precond : fix_exercise_data_precond (data)) :
    fix_exercise_data_postcond (data) (fix_exercise_data (data) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_62817_codeexercises_162817