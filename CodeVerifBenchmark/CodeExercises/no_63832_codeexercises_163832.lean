import Mathlib

-- Precondition definitions
@[reducible, simp]
def nested_loop_triangle_precond (num_rows : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def nested_loop_triangle (num_rows : Nat) (h_precond : nested_loop_triangle_precond (num_rows)) : String :=
  -- !benchmark @start code
  match num_rows with
  | 0 => ""
  | n + 1 =>
    let rec outer_loop (i : Nat) (acc : String) : String :=
      match i with
      | 0 => acc
      | j + 1 =>
        let rec inner_loop (k : Nat) (row : String) : String :=
          match k with
          | 0 => row
          | m + 1 => inner_loop m (row ++ "*")
        let current_row := inner_loop (j + 1) ""
        let new_acc := if j = n then current_row else acc ++ "\n" ++ current_row
        outer_loop j new_acc
    outer_loop n ""
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def triangle_pattern (num_rows : Nat) : String :=
  match num_rows with
  | 0 => ""
  | n + 1 => 
    let rec build_row (row_num : Nat) (acc : String) : String :=
      match row_num with
      | 0 => acc
      | k + 1 => build_row k (acc ++ "*")
    let current_row := build_row (n + 1) ""
    if n = 0 then current_row else triangle_pattern n ++ "\n" ++ current_row

-- Postcondition definitions
@[reducible, simp]
def nested_loop_triangle_postcond (num_rows : Nat) (result: String) (h_precond : nested_loop_triangle_precond (num_rows)) : Prop :=
  -- !benchmark @start postcond
  result = triangle_pattern num_rows
  -- !benchmark @end postcond


-- Proof content
theorem nested_loop_triangle_postcond_satisfied (num_rows: Nat) (h_precond : nested_loop_triangle_precond (num_rows)) :
    nested_loop_triangle_postcond (num_rows) (nested_loop_triangle (num_rows) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof