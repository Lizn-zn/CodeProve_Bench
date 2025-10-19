import Mathlib

-- Precondition auxiliary definitions
structure MyMatrix (α : Type) where
  data : List (List α)

def MyMatrix.rows {α : Type} (m : MyMatrix α) : Nat := m.data.length

def MyMatrix.cols {α : Type} (m : MyMatrix α) : Nat := 
  match m.data with
  | [] => 0
  | (r :: _) => r.length

def MyMatrix.valid (m : MyMatrix Nat) : Prop :=
  m.data.length > 0 ∧ m.data.length < 1000 ∧
  m.cols > 0 ∧ m.cols < 1000 ∧
  m.data.length * m.cols ≥ 4 ∧ m.data.length * m.cols ≤ 100000 ∧
  ∀ r ∈ m.data, r.length = m.cols ∧ ∀ x ∈ r, x > 0 ∧ x ≤ 1000000

-- Precondition definitions
@[reducible, simp]
def maxMoves_precond (grid : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  MyMatrix.valid ⟨grid⟩
  -- !benchmark @end precond


-- Code auxiliary definitions
def Array2D (α : Type) [Inhabited α] := List (List α)

def Array2D.get! {α : Type} [Inhabited α] (arr : Array2D α) (row col : Nat) : α :=
  List.get! (List.get! arr row) col

def Array2D.rows {α : Type} [Inhabited α] (arr : Array2D α) : Nat := arr.length

def Array2D.cols {α : Type} [Inhabited α] (arr : Array2D α) : Nat := 
  match arr with
  | [] => 0
  | (r :: _) => r.length

def maxOfList : List Nat → Nat
  | [] => 0
  | xs => xs.foldl max 0

-- Main function definitions
def maxMoves (grid : List (List Nat)) (h_precond : maxMoves_precond (grid)) : Nat :=
  -- !benchmark @start code
  match grid with
    | [] => 0
    | _ =>
      let rows := grid.length
      let cols := (List.get! grid 0).length
      
      -- Create a DP table where dp[i][j] represents the maximum moves from cell (i,j)
      -- Initialize all values to 0
      let dp : List (List Nat) := List.replicate rows (List.replicate cols 0)
      
      -- Fill the DP table from right to left (column by column)
      let result_dp := 
        if cols > 1 then
          let mut_dp := Id.run do
            let mut current_dp := dp
            for colIdx in [1:cols] do
              for rowIdx in [0:rows] do
                let currentValue := (List.get! grid rowIdx).get! (cols - colIdx)
                let mut maxMovesFromHere := 0
                
                -- Check the three possible moves to the next column
                let nextCol := cols - colIdx + 1
                if nextCol < cols then
                  -- Check row-1, col+1
                  if rowIdx > 0 then
                    let nextValue := (List.get! grid (rowIdx - 1)).get! nextCol
                    if nextValue > currentValue then
                      maxMovesFromHere := max maxMovesFromHere ((List.get! current_dp (rowIdx - 1)).get! nextCol + 1)
                  
                  -- Check row, col+1
                  let nextValue := (List.get! grid rowIdx).get! nextCol
                  if nextValue > currentValue then
                    maxMovesFromHere := max maxMovesFromHere ((List.get! current_dp rowIdx).get! nextCol + 1)
                  
                  -- Check row+1, col+1
                  if rowIdx + 1 < rows then
                    let nextValue := (List.get! grid (rowIdx + 1)).get! nextCol
                    if nextValue > currentValue then
                      maxMovesFromHere := max maxMovesFromHere ((List.get! current_dp (rowIdx + 1)).get! nextCol + 1)
                
                current_dp := List.set current_dp rowIdx (List.set (List.get! current_dp rowIdx) (cols - colIdx) maxMovesFromHere)
            pure current_dp
          mut_dp
        else
          dp
      
      -- The answer is the maximum value in the first column
      let firstColMoves := List.range rows |>.map (fun row => (List.get! result_dp row).get! 0)
      maxOfList firstColMoves
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- A path is a sequence of coordinates (row, col)
-- A valid path must:
-- 1. Start from any cell in the first column (col = 0)
-- 2. Each step moves to (row-1, col+1), (row, col+1), or (row+1, col+1)
-- 3. Each next cell's value must be strictly greater than the current cell's value
-- 4. All coordinates must be within bounds

-- The maximum number of moves equals the maximum length of such a path minus 1

inductive MyPath : MyMatrix Nat → List (Nat × Nat) → Prop
  | start (grid : MyMatrix Nat) (r : Nat) (hr : r < grid.data.length) :
    MyPath grid [(r, 0)]
  | step (grid : MyMatrix Nat) (p : List (Nat × Nat)) (r c r' c' : Nat) :
    MyPath grid p →
    p = (r, c) :: _ →
    c' = c + 1 →
    (r' = r - 1 ∨ r' = r ∨ r' = r + 1) →
    r' < grid.data.length →
    c' < (MyMatrix.cols grid) →
    (grid.data.get! r').get! c' > (grid.data.get! r).get! c →
    MyPath grid ((r', c') :: p)

def Path.length (p : List (Nat × Nat)) : Nat := p.length - 1

def maxMovesOfPaths (grid : MyMatrix Nat) : Nat :=
  match grid.data with
  | [] => 0
  | _ =>
    let paths := List.range grid.data.length
    let allPaths := generateAllPaths grid.data paths
    match allPaths with
    | [] => 0
    | ps => (ps.map Path.length).foldr max 0

where
  generateAllPaths (grid : List (List Nat)) (currentRows : List Nat) : List (List (Nat × Nat)) :=
    let initialPaths := currentRows.map fun r => [(r, 0)]
    extendAllPaths grid initialPaths []
  
  extendAllPaths (grid : List (List Nat)) (currentPaths : List (List (Nat × Nat))) (acc : List (List (Nat × Nat))) : List (List (Nat × Nat)) :=
    match currentPaths with
    | [] => acc
    | p :: ps =>
      let extensions := extendPath grid p
      if extensions.isEmpty then
        extendAllPaths grid ps (p :: acc)
      else
        extendAllPaths grid ps (extensions ++ acc)
  
  extendPath (grid : List (List Nat)) (p : List (Nat × Nat)) : List (List (Nat × Nat)) :=
    match p with
    | [] => []
    | (r, c) :: _ =>
      let gridCols := match grid with | [] => 0 | (row::_) => row.length
      if c + 1 ≥ gridCols then []
      else
        let candidates := [
          (r - 1, c + 1),
          (r, c + 1),
          (r + 1, c + 1)
        ]
        let validNexts := candidates.filter fun (r', c') =>
          r' < grid.length ∧
          c' < gridCols ∧
          (List.get! (List.get! grid r') c') > (List.get! (List.get! grid r) c)
        validNexts.map fun (r', c') => (r', c') :: p

-- Postcondition definitions
@[reducible, simp]
def maxMoves_postcond (grid : List (List Nat)) (result: Nat) (h_precond : maxMoves_precond (grid)) : Prop :=
  -- !benchmark @start postcond
  result = maxMovesOfPaths ⟨grid⟩
  -- !benchmark @end postcond


-- Proof content
theorem maxMoves_postcond_satisfied (grid: List (List Nat)) (h_precond : maxMoves_precond (grid)) :
    maxMoves_postcond (grid) (maxMoves (grid) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof