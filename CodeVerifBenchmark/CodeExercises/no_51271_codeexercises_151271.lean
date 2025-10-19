import Mathlib

-- Precondition definitions
@[reducible, simp]
def calculate_temperature_change_precond (temperature_data : Array (Array (Array Float))) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def calculate_temperature_change (temperature_data : Array (Array (Array Float))) (h_precond : calculate_temperature_change_precond (temperature_data)) : Float :=
  -- !benchmark @start code
  let rec loop_i (i : Nat) (total : Float) : Float :=
    if h : i < temperature_data.size then
      let row := temperature_data[i]
      let rec loop_j (j : Nat) (total' : Float) : Float :=
        if h' : j < row.size then
          let inner_row := row[j]
          let rec loop_k (k : Nat) (total'' : Float) : Float :=
            if h'' : k < inner_row.size then
              let change := inner_row[k]
              let new_total := total'' + (if change > 0.0 then change else 0.0)
              loop_k (k + 1) new_total
            else
              total''
          let new_total' := loop_j (j + 1) (loop_k 0 total')
          new_total'
        else
          total'
      let new_total := loop_i (i + 1) (loop_j 0 total)
      new_total
    else
      total
  loop_i 0 0.0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sum_positive_changes (data : Array (Array (Array Float))) : Float :=
  let rec loop_i (i : Nat) (total : Float) : Float :=
    if h : i < data.size then
      let row := data[i]
      let rec loop_j (j : Nat) (total' : Float) : Float :=
        if h' : j < row.size then
          let inner_row := row[j]
          let rec loop_k (k : Nat) (total'' : Float) : Float :=
            if h'' : k < inner_row.size then
              let change := inner_row[k]
              let new_total := total'' + (if change > 0.0 then change else 0.0)
              loop_k (k + 1) new_total
            else
              total''
          let new_total' := loop_j (j + 1) (loop_k 0 total')
          new_total'
        else
          total'
      let new_total := loop_i (i + 1) (loop_j 0 total)
      new_total
    else
      total
  loop_i 0 0.0

-- Postcondition definitions
@[reducible, simp]
def calculate_temperature_change_postcond (temperature_data : Array (Array (Array Float))) (result: Float) (h_precond : calculate_temperature_change_precond (temperature_data)) : Prop :=
  -- !benchmark @start postcond
  result = sum_positive_changes temperature_data
  -- !benchmark @end postcond


-- Proof content
theorem calculate_temperature_change_postcond_satisfied (temperature_data: Array (Array (Array Float))) (h_precond : calculate_temperature_change_precond (temperature_data)) :
    calculate_temperature_change_postcond (temperature_data) (calculate_temperature_change (temperature_data) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof