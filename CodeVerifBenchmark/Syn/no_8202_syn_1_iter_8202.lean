import Mathlib

namespace no_8202_syn_1_iter_8202


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def extract_chars_from_coords_precond (grid : Array (Array Int)) (coords : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  ∀ i, i < grid.size → ∀ j, j < (grid[i]!).size → (grid[i]!)[j]! ≥ 0 ∧ (grid[i]!)[j]! ≤ 255
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the main function

-- Main function definitions
def extract_chars_from_coords (grid : Array (Array Int)) (coords : List (Nat × Nat)) (h_precond : extract_chars_from_coords_precond (grid) (coords)) : Array Char :=
  -- !benchmark @start code
  coords.foldl (λ (result : Array Char) coord => 
    let (i, j) := coord
    if h : i < grid.size then
      let row := grid[i]!
      if h' : j < row.size then
        let val := row[j]!
        -- Use the precondition to ensure val is within valid character range
        have h_precond_specific := h_precond i h j (by
          simp [row] at h' ⊢
          exact h')
        have h_val_nonneg : val ≥ 0 := h_precond_specific.left
        have h_val_le_max : val ≤ 255 := h_precond_specific.right
        let char_val := Char.ofNat val.toNat
        result.push char_val
      else
        result
    else
      result
  ) (Array.mkEmpty coords.length)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Auxiliary function to check if coordinates are within bounds
def valid_coord (grid : Array (Array Int)) (coord : Nat × Nat) : Bool :=
  let (i, j) := coord
  i < grid.size && j < (grid.get! i).size

-- Auxiliary function to get character from grid at valid coordinate
def get_char_at_coord (grid : Array (Array Int)) (coord : Nat × Nat) : Option Char :=
  let (i, j) := coord
  if h1 : i < grid.size then
    let row := grid[i]!
    if h2 : j < row.size then
      let val := row[j]!
      if h3 : val ≥ 0 ∧ val ≤ 255 then
        some (Char.ofNat val.toNat)
      else
        none
    else
      none
  else
    none

-- Function to collect valid characters from coordinates
def collect_valid_chars (grid : Array (Array Int)) (coords : List (Nat × Nat)) : Array Char :=
  coords.foldl (λ acc coord => 
    match get_char_at_coord grid coord with
    | some c => acc.push c
    | none => acc
  ) (Array.mkEmpty coords.length)

-- Postcondition definitions
@[reducible, simp]
def extract_chars_from_coords_postcond (grid : Array (Array Int)) (coords : List (Nat × Nat)) (result: Array Char) (h_precond : extract_chars_from_coords_precond (grid) (coords)) : Prop :=
  -- !benchmark @start postcond
  result = collect_valid_chars grid coords
  -- !benchmark @end postcond


-- Proof content
theorem extract_chars_from_coords_postcond_satisfied (grid: Array (Array Int)) (coords: List (Nat × Nat)) (h_precond : extract_chars_from_coords_precond (grid) (coords)) :
    extract_chars_from_coords_postcond (grid) (coords) (extract_chars_from_coords (grid) (coords) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_8202_syn_1_iter_8202