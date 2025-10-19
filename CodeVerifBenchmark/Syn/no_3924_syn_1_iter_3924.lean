import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def find_max_coordinates_precond (matrix : Array (Array Nat)) : Prop :=
  -- !benchmark @start precond
  ∃ (i : Nat) (j : Nat), i < matrix.size ∧ j < (matrix.get! i).size
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Auxiliary function to find maximum coordinates
def find_max_coordinates_aux (matrix : Array (Array Nat)) : Prod Nat Nat :=
  let rec find_row_max (row : Nat) (current_max : Nat) (max_coords : Prod Nat Nat) : Prod Nat Nat :=
    if h : row < matrix.size then
      let row_array := matrix.get! row
      let rec find_col_max (col : Nat) (current_max : Nat) (max_coords : Prod Nat Nat) : Prod Nat Nat :=
        if h' : col < row_array.size then
          let value := row_array.get! col
          if value > current_max then
            find_col_max (col + 1) value ⟨row, col⟩
          else
            find_col_max (col + 1) current_max max_coords
        else
          max_coords
      let new_max_coords := find_col_max 0 current_max max_coords
      let new_current_max := 
        match new_max_coords with
        | ⟨r, c⟩ => (matrix.get! r).get! c
      find_row_max (row + 1) new_current_max new_max_coords
    else
      max_coords
  find_row_max 0 0 ⟨0, 0⟩

-- Main function definitions
def find_max_coordinates (matrix : Array (Array Nat)) (h_precond : find_max_coordinates_precond (matrix)) : Prod Nat Nat :=
  -- !benchmark @start code
  find_max_coordinates_aux matrix
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Auxiliary definitions for postcondition
def is_max_coordinate (matrix : Array (Array Nat)) (row col : Nat) : Prop :=
  row < matrix.size ∧ col < (matrix.get! row).size ∧
  ∀ (i : Nat) (j : Nat), i < matrix.size → j < (matrix.get! i).size → 
    (matrix.get! i).get! j ≤ (matrix.get! row).get! col

def is_first_occurrence (matrix : Array (Array Nat)) (row col : Nat) : Prop :=
  ∀ (i : Nat) (j : Nat), i < matrix.size → j < (matrix.get! i).size → 
    (i < row ∨ (i = row ∧ j < col)) → (matrix.get! i).get! j < (matrix.get! row).get! col

-- Postcondition definitions
@[reducible, simp]
def find_max_coordinates_postcond (matrix : Array (Array Nat)) (result: Prod Nat Nat) (h_precond : find_max_coordinates_precond (matrix)) : Prop :=
  -- !benchmark @start postcond
  let (max_row, max_col) := result
  is_max_coordinate matrix max_row max_col ∧ is_first_occurrence matrix max_row max_col
  -- !benchmark @end postcond


-- Proof content
theorem find_max_coordinates_postcond_satisfied (matrix: Array (Array Nat)) (h_precond : find_max_coordinates_precond (matrix)) :
    find_max_coordinates_postcond matrix (find_max_coordinates matrix h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof