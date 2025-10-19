import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_highest_grade_precond (students : List (Prod String Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_highest_grade (students : List (Prod String Nat)) (h_precond : find_highest_grade_precond (students)) : Nat :=
  -- !benchmark @start code
  match students with
  | [] => 0
  | (_, grade) :: rest =>
      let rec helper (current_max : Nat) (remaining : List (Prod String Nat)) : Nat :=
        match remaining with
        | [] => current_max
        | (_, g) :: tail =>
            if g > current_max then
              helper g tail
            else
              helper current_max tail
      helper grade rest
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def find_highest_grade_max (students : List (Prod String Nat)) : Nat :=
  match students with
  | [] => 0
  | (_, grade) :: rest => 
      let max_rest := find_highest_grade_max rest
      if grade > max_rest then grade else max_rest

-- Postcondition definitions
@[reducible, simp]
def find_highest_grade_postcond (students : List (Prod String Nat)) (result: Nat) (h_precond : find_highest_grade_precond (students)) : Prop :=
  -- !benchmark @start postcond
  result = find_highest_grade_max students
  -- !benchmark @end postcond


-- Proof content
theorem find_highest_grade_postcond_satisfied (students: List (Prod String Nat)) (h_precond : find_highest_grade_precond (students)) :
    find_highest_grade_postcond (students) (find_highest_grade (students) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

