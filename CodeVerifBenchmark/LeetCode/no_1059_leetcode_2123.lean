import Mathlib

-- Precondition auxiliary definitions
/-- A position in the grid, represented as a pair of natural numbers (row, column). -/
structure Pos where
  row : Nat
  col : Nat
deriving Repr, DecidableEq

/-- Checks whether two positions are 4-directionally adjacent (up, down, left, right). -/
def adjacent (p1 p2 : Pos) : Bool :=
  (p1.row = p2.row && (p1.col = p2.col + 1 || p1.col + 1 = p2.col)) ||
  (p1.col = p2.col && (p1.row = p2.row + 1 || p1.row + 1 = p2.row))

/-- Converts a list of lists into a function from positions to values, returning `none` for out-of-bounds access. -/
def gridLookup (grid : List (List Nat)) (pos : Pos) : Option Nat :=
  match grid.get? pos.row with
  | none => none
  | some row => row.get? pos.col

/-- Checks if a grid position is valid (within bounds). -/
def isValidPos (grid : List (List Nat)) (pos : Pos) : Bool :=
  pos.row < grid.length && pos.col < (grid.get! pos.row).length

/-- Generates all valid positions in the grid. -/
def allPositions (grid : List (List Nat)) : List Pos :=
  let rows := List.range grid.length
  let cols := match grid with
    | [] => []
    | _ => List.range (grid.get! 0).length
  rows.flatMap fun r => cols.map fun c => { row := r, col := c }

/-- Checks if a value at a position is 1. -/
def isOneAt (grid : List (List Nat)) (pos : Pos) : Bool :=
  gridLookup grid pos = some 1

/-- Finds all positions in the grid that contain a 1. -/
def onesInGrid (grid : List (List Nat)) : List Pos :=
  (allPositions grid).filter (fun p => isOneAt grid p)

/-- Checks if two 1-cells are conflicting (adjacent and both are 1). -/
def isConflictingPair (grid : List (List Nat)) (p1 p2 : Pos) : Bool :=
  isOneAt grid p1 && isOneAt grid p2 && (adjacent p1 p2)

/-- Checks if the grid is already well-isolated (no conflicting pairs). -/
def isWellIsolated (grid : List (List Nat)) : Prop :=
  let ones := onesInGrid grid
  ¬∃ p1 ∈ ones, ∃ p2 ∈ ones, isConflictingPair grid p1 p2

/-- Represents a conflict as an unordered pair of positions. -/
structure Conflict where
  pos1 : Pos
  pos2 : Pos
deriving Repr, DecidableEq

/-- Normalizes a conflict so that pos1 ≤ pos2 lexicographically. -/
def normalizeConflict (c : Conflict) : Conflict :=
  if c.pos1.row < c.pos2.row || (c.pos1.row = c.pos2.row && c.pos1.col <= c.pos2.col) then
    c
  else
    { pos1 := c.pos2, pos2 := c.pos1 }

/-- Extracts all unique conflicts (unordered pairs of adjacent 1s) from the grid. -/
def extractConflicts (grid : List (List Nat)) : List Conflict :=
  let ones := onesInGrid grid
  ones.flatMap fun p1 =>
    let adjacentOnes := (ones.filter (fun p2 => adjacent p1 p2))
    adjacentOnes.map (fun p2 => normalizeConflict { pos1 := p1, pos2 := p2 })
  |> List.eraseDups

/-- Checks if flipping a set of positions resolves all conflicts. -/
def resolvesAllConflicts (grid : List (List Nat)) (flips : List Pos) : Prop :=
  let flippedGrid := flips.foldl (fun g pos =>
    match g.get? pos.row with
    | none => g
    | some row =>
      let newRow := row.set pos.col 0
      g.set pos.row newRow
  ) grid
  isWellIsolated flippedGrid

/-- Verifies that all elements in flips are valid positions in the grid. -/
def validFlips (grid : List (List Nat)) (flips : List Pos) : Bool :=
  flips.all (fun pos => isValidPos grid pos)

/-- Verifies that all flips target cells that are originally 1. -/
def flipsOnlyOnes (grid : List (List Nat)) (flips : List Pos) : Bool :=
  flips.all (fun pos => isOneAt grid pos)

-- Precondition definitions
@[reducible, simp]
def minOperationsToWellIsolate_precond (grid : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Converts a grid cell to a vertex index for graph algorithms. -/
def posToVertex (grid : List (List Nat)) (pos : Pos) : Option Nat :=
  if pos.row < grid.length && pos.col < (grid.get! 0).length then
    some (pos.row * (grid.get! 0).length + pos.col)
  else
    none

/-- Converts a vertex index back to a grid position. -/
def vertexToPos (grid : List (List Nat)) (v : Nat) : Pos :=
  let cols := (grid.get! 0).length
  { row := v / cols, col := v % cols }

/-- Builds a graph where vertices are 1-cells and edges connect conflicting pairs. -/
def buildConflictGraph (grid : List (List Nat)) : List (Nat × Nat) :=
  let conflicts := extractConflicts grid
  let edges := conflicts.map fun c =>
    match posToVertex grid c.pos1, posToVertex grid c.pos2 with
    | some v1, some v2 => (v1, v2)
    | _, _ => (0, 0)
  edges.filter (fun (v1, v2) => v1 ≠ v2)

/-- Finds a maximum matching in a bipartite graph using a greedy approach. -/
def maxMatching (edges : List (Nat × Nat)) : List (Nat × Nat) :=
  let sortedEdges := edges.mergeSort (fun (u1, v1) (u2, v2) => u1 < u2 || (u1 = u2 && v1 < v2))
  let rec go (es : List (Nat × Nat)) (matched : List (Nat × Nat)) (used : List Nat) : List (Nat × Nat) :=
    match es with
    | [] => matched
    | (u, v) :: es' =>
      if used.contains u || used.contains v then
        go es' matched used
      else
        go es' ((u, v) :: matched) (u :: v :: used)
  go sortedEdges [] []

/-- Computes the minimum vertex cover size for a bipartite graph using Kőnig's theorem. -/
def minVertexCoverSize (edges : List (Nat × Nat)) : Nat :=
  (maxMatching edges).length

-- Main function definitions
def minOperationsToWellIsolate (grid : List (List Nat)) (h_precond : minOperationsToWellIsolate_precond (grid)) : Nat :=
  -- !benchmark @start code
  let conflicts := extractConflicts grid
  let edges := conflicts.map fun c =>
    match posToVertex grid c.pos1, posToVertex grid c.pos2 with
    | some v1, some v2 => (v1, v2)
    | _, _ => (0, 0)
  let filteredEdges := edges.filter (fun (v1, v2) => v1 ≠ v2)
  minVertexCoverSize filteredEdges
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Checks if a solution (number of operations) is valid by ensuring it equals the size of some valid flip set. -/
def isValidSolution (grid : List (List Nat)) (k : Nat) : Prop :=
  ∃ flips : List Pos,
    flips.length = k ∧
    validFlips grid flips ∧
    flipsOnlyOnes grid flips ∧
    resolvesAllConflicts grid flips

/-- Alternative characterization: the result must be the minimal k such that a valid solution exists. -/
def isMinimalValidSolution (grid : List (List Nat)) (k : Nat) : Prop :=
  isValidSolution grid k ∧
  ∀ k' < k, ¬isValidSolution grid k'

-- Postcondition definitions
@[reducible, simp]
def minOperationsToWellIsolate_postcond (grid : List (List Nat)) (result: Nat) (h_precond : minOperationsToWellIsolate_precond (grid)) : Prop :=
  -- !benchmark @start postcond
  isMinimalValidSolution grid result
  -- !benchmark @end postcond


-- Proof content
theorem minOperationsToWellIsolate_postcond_satisfied (grid: List (List Nat)) (h_precond : minOperationsToWellIsolate_precond (grid)) :
    minOperationsToWellIsolate_postcond (grid) (minOperationsToWellIsolate (grid) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof