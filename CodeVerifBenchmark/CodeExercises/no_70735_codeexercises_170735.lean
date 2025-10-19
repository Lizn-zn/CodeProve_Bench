import Mathlib

-- Precondition definitions
@[reducible, simp]
def calculate_zoologist_range_operation_precond (start : ℂ) (end_val : ℂ) (operation : String) : Prop :=
  -- !benchmark @start precond
  operation = "+" ∨ operation = "-" ∨ operation = "*"
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def calculate_zoologist_range_operation (start : ℂ) (end_val : ℂ) (operation : String) (h_precond : calculate_zoologist_range_operation_precond start end_val operation) : ℂ :=
  -- !benchmark @start code
  match operation with
  | "+" => start + end_val
  | "-" => start - end_val
  | "*" => start * end_val
  | _ => 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def range_operation_result (start : ℂ) (end_val : ℂ) (op : String) : ℂ :=
  match op with
  | "+" => start + end_val
  | "-" => start - end_val
  | "*" => start * end_val
  | _ => 0

-- Postcondition definitions
@[reducible, simp]
def calculate_zoologist_range_operation_postcond (start : ℂ) (end_val : ℂ) (operation : String) (result: ℂ) (h_precond : calculate_zoologist_range_operation_precond start end_val operation) : Prop :=
  -- !benchmark @start postcond
  result = range_operation_result start end_val operation
  -- !benchmark @end postcond


-- Proof content
theorem calculate_zoologist_range_operation_postcond_satisfied (start: ℂ) (end_val: ℂ) (operation: String) (h_precond : calculate_zoologist_range_operation_precond start end_val operation) :
    calculate_zoologist_range_operation_postcond start end_val operation (calculate_zoologist_range_operation start end_val operation h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof