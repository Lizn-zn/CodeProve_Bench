import Mathlib

-- Precondition auxiliary definitions
-- The precondition is simple and doesn't require auxiliary definitions

-- Precondition definitions
@[reducible, simp]
def calculate_average_precond (students_grades : Std.HashMap String (List Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the implementation

-- Main function definitions
def calculate_average (students_grades : Std.HashMap String (List Nat)) (h_precond : calculate_average_precond students_grades) : Float :=
  -- !benchmark @start code
  let total_sum := students_grades.fold (λ acc _ grades => acc + grades.sum) 0
  let total_count := students_grades.fold (λ acc _ grades => acc + grades.length) 0
  if total_count = 0 then
    0.0
  else
    (Float.ofNat total_sum) / (Float.ofNat total_count)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Auxiliary definitions for calculating the average
private def sum_grades (students_grades : Std.HashMap String (List Nat)) : Nat :=
  students_grades.fold (λ acc _ grades => acc + grades.sum) 0

private def count_grades (students_grades : Std.HashMap String (List Nat)) : Nat :=
  students_grades.fold (λ acc _ grades => acc + grades.length) 0

-- Postcondition definitions
@[reducible, simp]
def calculate_average_postcond (students_grades : Std.HashMap String (List Nat)) (result: Float) (h_precond : calculate_average_precond students_grades) : Prop :=
  -- !benchmark @start postcond
  let total_sum := sum_grades students_grades
  let total_count := count_grades students_grades
  total_count > 0 ∧ result = (Float.ofNat total_sum) / (Float.ofNat total_count)
  -- !benchmark @end postcond


-- Proof content
theorem calculate_average_postcond_satisfied (students_grades: Std.HashMap String (List Nat)) (h_precond : calculate_average_precond students_grades) :
    calculate_average_postcond students_grades (calculate_average students_grades h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof