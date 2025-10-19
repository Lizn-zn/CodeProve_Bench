import Mathlib

-- Precondition definitions
@[reducible, simp]
def countBlackCellsInSubrectangles_precond (H : Nat) (W : Nat) (blackCells : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  H ≥ 3 ∧ W ≥ 3 ∧ 
    blackCells.length ≤ min 100000 (H * W) ∧
    (∀ cell ∈ blackCells, 1 ≤ cell.1 ∧ cell.1 ≤ H ∧ 1 ≤ cell.2 ∧ cell.2 ≤ W) ∧
    blackCells.Pairwise (· ≠ ·)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- HashMap implementation for efficient counting
structure HashMap (α β : Type) where
  data : Array (α × β)

def HashMap.empty : HashMap α β := ⟨#[]⟩

def HashMap.insert [BEq α] (m : HashMap α β) (k : α) (v : β) : HashMap α β :=
  let idx := m.data.findIdx? (fun p => p.1 == k)
  match idx with
  | some i => ⟨m.data.set! i (k, v)⟩
  | none => ⟨m.data.push (k, v)⟩

def HashMap.find? [BEq α] (m : HashMap α β) (k : α) : Option β :=
  m.data.find? (fun p => p.1 == k) |>.map (·.2)

def HashMap.getD [BEq α] (m : HashMap α β) (k : α) (default : β) : β :=
  match m.find? k with
  | some v => v
  | none => default

def HashMap.toList (m : HashMap α β) : List (α × β) :=
  m.data.toList

-- Increment counter for a key
def HashMap.increment [BEq α] (m : HashMap (α × α) Nat) (k : α × α) : HashMap (α × α) Nat :=
  let current := m.getD k 0
  m.insert k (current + 1)

-- Main function definitions
def countBlackCellsInSubrectangles (H : Nat) (W : Nat) (blackCells : List (Nat × Nat)) (h_precond : countBlackCellsInSubrectangles_precond (H) (W) (blackCells)) : Array Nat :=
  -- !benchmark @start code
  -- Build a counter of how many black cells each valid top-left corner has
  Id.run do
    let mut cornerCounts : HashMap (Nat × Nat) Nat := HashMap.empty
    
    -- For each black cell, increment the count for all 3x3 subrectangles that contain it
    for cell in blackCells do
      let (x, y) := cell
      -- A black cell at (x, y) is contained in subrectangles with top-left corners at
      -- (x-dx, y-dy) where dx, dy ∈ {0, 1, 2}
      for dx in [0:3] do
        for dy in [0:3] do
          let nx := x - dx
          let ny := y - dy
          -- Check if this is a valid top-left corner
          if nx >= 1 && ny >= 1 && nx + 2 <= H && ny + 2 <= W then
            cornerCounts := cornerCounts.increment (nx, ny)
    
    -- Count how many corners have each count value
    let mut countOfCounts : Array Nat := Array.mkArray 10 0
    for (_, count) in cornerCounts.toList do
      if count < 10 then
        countOfCounts := countOfCounts.set! count (countOfCounts[count]! + 1)
    
    -- Total number of 3x3 subrectangles
    let totalSubrects := (H - 2) * (W - 2)
    
    -- Subrectangles with 0 black cells = total - those with at least 1
    let sumNonZero := (List.range 9).foldl (fun acc i => acc + countOfCounts[i + 1]!) 0
    countOfCounts := countOfCounts.set! 0 (totalSubrects - sumNonZero)
    
    return countOfCounts
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Check if a cell is in the black cells list
def isBlackCell (blackCells : List (Nat × Nat)) (row col : Nat) : Bool :=
  blackCells.any (fun cell => cell.1 == row && cell.2 == col)

-- Count black cells in a 3x3 subrectangle with top-left corner at (row, col)
def countBlackInSubrect (blackCells : List (Nat × Nat)) (row col : Nat) : Nat :=
  let cells := [(row, col), (row, col+1), (row, col+2),
                (row+1, col), (row+1, col+1), (row+1, col+2),
                (row+2, col), (row+2, col+1), (row+2, col+2)]
  cells.filter (fun cell => isBlackCell blackCells cell.1 cell.2) |>.length

-- Get all valid 3x3 subrectangles (top-left corners)
def validSubrects (H W : Nat) : List (Nat × Nat) :=
  (List.range (H - 2)).flatMap (fun i =>
    (List.range (W - 2)).map (fun j => (i + 1, j + 1)))

-- Count how many subrectangles have exactly j black cells
def countSubrectsWithJBlacks (H W : Nat) (blackCells : List (Nat × Nat)) (j : Nat) : Nat :=
  (validSubrects H W).filter (fun corner =>
    countBlackInSubrect blackCells corner.1 corner.2 == j) |>.length

-- Postcondition definitions
@[reducible, simp]
def countBlackCellsInSubrectangles_postcond (H : Nat) (W : Nat) (blackCells : List (Nat × Nat)) (result: Array Nat) (h_precond : countBlackCellsInSubrectangles_precond (H) (W) (blackCells)) : Prop :=
  -- !benchmark @start postcond
  result.size = 10 ∧
    (∀ j : Nat, j < 10 → result[j]! = countSubrectsWithJBlacks H W blackCells j)
  -- !benchmark @end postcond


-- Proof content
theorem countBlackCellsInSubrectangles_postcond_satisfied (H: Nat) (W: Nat) (blackCells: List (Nat × Nat)) (h_precond : countBlackCellsInSubrectangles_precond (H) (W) (blackCells)) :
    countBlackCellsInSubrectangles_postcond (H) (W) (blackCells) (countBlackCellsInSubrectangles (H) (W) (blackCells) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof