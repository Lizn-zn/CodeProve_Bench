import Mathlib

-- Precondition auxiliary definitions
-- Helper function to check if a grid is well-formed
def isWellFormedGrid (H : Nat) (W : Nat) (grid : List (List String)) : Prop :=
  grid.length = H ∧ 
  (∀ row ∈ grid, row.length = W) ∧
  (∀ row ∈ grid, ∀ s ∈ row, s.length = 5)

-- Helper function to count occurrences of "snuke" in the grid
def countSnuke (grid : List (List String)) : Nat :=
  grid.foldl (fun acc row => acc + row.foldl (fun acc' s => acc' + if s = "snuke" then 1 else 0) 0) 0

-- Precondition definitions
@[reducible, simp]
def findSnukePosition_precond (H : Nat) (W : Nat) (grid : List (List String)) : Prop :=
  -- !benchmark @start precond
  1 ≤ H ∧ H ≤ 26 ∧
    1 ≤ W ∧ W ≤ 26 ∧
    isWellFormedGrid H W grid ∧
    countSnuke grid = 1
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to convert column index to letter (0-based)
def colToLetter (col : Nat) : Char :=
  Char.ofNat (65 + col)

-- Helper function to find snuke position by iterating through the grid
def findSnukeHelper (grid : List (List String)) (row : Nat) (col : Nat) (H : Nat) (W : Nat) : Option (Nat × Nat) :=
  if row >= H then
    none
  else if col >= W then
    findSnukeHelper grid (row + 1) 0 H W
  else
    let currentRow := grid[row]!
    let currentCell := currentRow[col]!
    if currentCell = "snuke" then
      some (row, col)
    else
      findSnukeHelper grid row (col + 1) H W

-- Helper function to format the result
def formatPosition (row : Nat) (col : Nat) : String :=
  String.mk [colToLetter col] ++ toString (row + 1)

-- Main function definitions
def findSnukePosition (H : Nat) (W : Nat) (grid : List (List String)) (h_precond : findSnukePosition_precond (H) (W) (grid)) : String :=
  -- !benchmark @start code
  match findSnukeHelper grid 0 0 H W with
    | some (row, col) => formatPosition row col
    | none => ""
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if result matches the expected format and position
def isValidResult (H : Nat) (W : Nat) (grid : List (List String)) (result : String) : Prop :=
  ∃ (row : Nat) (col : Nat),
    row < H ∧
    col < W ∧
    (∃ (h_row : row < grid.length) (h_col : col < (grid[row]).length),
      grid[row][col] = "snuke") ∧
    result = String.mk [colToLetter col] ++ toString (row + 1)

-- Postcondition definitions
@[reducible, simp]
def findSnukePosition_postcond (H : Nat) (W : Nat) (grid : List (List String)) (result: String) (h_precond : findSnukePosition_precond (H) (W) (grid)) : Prop :=
  -- !benchmark @start postcond
  isValidResult H W grid result
  -- !benchmark @end postcond


-- Proof content
theorem findSnukePosition_postcond_satisfied (H: Nat) (W: Nat) (grid: List (List String)) (h_precond : findSnukePosition_precond (H) (W) (grid)) :
    findSnukePosition_postcond (H) (W) (grid) (findSnukePosition (H) (W) (grid) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof