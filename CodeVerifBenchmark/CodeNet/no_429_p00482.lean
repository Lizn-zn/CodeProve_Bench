import Mathlib

namespace no_429_p00482


-- Precondition definitions
@[reducible, simp]
def countGoodFlags_precond (M : Nat) (N : Nat) (grid : List (List Char)) : Prop :=
  -- !benchmark @start precond
  M ≥ 2 ∧ N ≥ 2 ∧ M ≤ 20 ∧ N ≤ 20 ∧
    grid.length = M ∧
    (∀ row ∈ grid, row.length = N) ∧
    (∀ row ∈ grid, ∀ c ∈ row, c = 'J' ∨ c = 'O' ∨ c = 'I' ∨ c = '?')
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to convert a grid to a flat list
def gridToFlat (grid : List (List Char)) : List Char :=
  List.flatten grid

-- Helper function to check if a specific position has the JOI pattern
def hasJOIPatternAt (flat : List Char) (N : Nat) (idx : Nat) : Bool :=
  idx + N < flat.length && idx + 1 < flat.length &&
  flat[idx]! = 'J' && flat[idx + 1]! = 'O' && flat[idx + N]! = 'I'

-- Check if any assignment with current filled positions can have JOI pattern
def canHaveJOIPattern (M N : Nat) (flat : List Char) : Bool :=
  List.range (M - 1) |>.any fun i =>
    List.range (N - 1) |>.any fun j =>
      hasJOIPatternAt flat N (i * N + j)

-- Count assignments recursively with pruning
def countAssignments (M N : Nat) (flat : List Char) (idx : Nat) (hasPattern : Bool) : Nat :=
  if idx ≥ flat.length then
    if hasPattern then 1 else 0
  else
    let c := flat[idx]!
    if c = '?' then
      let tryChar (ch : Char) : Nat :=
        let newFlat := flat.set idx ch
        let newHasPattern := hasPattern || canHaveJOIPattern M N newFlat
        countAssignments M N newFlat (idx + 1) newHasPattern
      (tryChar 'J') + (tryChar 'O') + (tryChar 'I')
    else
      let newHasPattern := hasPattern || canHaveJOIPattern M N flat
      countAssignments M N flat (idx + 1) newHasPattern

-- Main function definitions
def countGoodFlags (M : Nat) (N : Nat) (grid : List (List Char)) (h_precond : countGoodFlags_precond (M) (N) (grid)) : Nat :=
  -- !benchmark @start code
  let flat := gridToFlat grid
    let count := countAssignments M N flat 0 false
    count % 100000
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Check if a grid contains the JOI pattern (J with O to its right and I below J)
def hasJOIPattern (M N : Nat) (grid : List (List Char)) : Bool :=
  let flatGrid := List.flatten grid
  List.range (M - 1) |>.any fun i =>
    List.range (N - 1) |>.any fun j =>
      let idx := i * N + j
      flatGrid[idx]! = 'J' && flatGrid[idx + 1]! = 'O' && flatGrid[idx + N]! = 'I'

-- Count the number of '?' characters in the grid
def countQuestionMarks (grid : List (List Char)) : Nat :=
  grid.foldl (fun acc row => acc + row.count '?') 0

-- Check if a character assignment is compatible with the template
def isCompatible (template : List (List Char)) (filled : List (List Char)) : Bool :=
  template.length = filled.length ∧
  (List.zip template filled).all fun (tRow, fRow) =>
    tRow.length = fRow.length ∧
    (List.zip tRow fRow).all fun (tc, fc) =>
      tc = '?' ∨ tc = fc

-- Generate all possible ways to fill '?' with 'J', 'O', or 'I'
def fillGrid (grid : List (List Char)) : List (List (List Char)) :=
  let rec fillHelper (flat : List Char) : List (List Char) :=
    match flat with
    | [] => [[]]
    | c :: rest =>
      let restFilled := fillHelper rest
      if c = '?' then
        List.flatMap (fun r => [('J' :: r), ('O' :: r), ('I' :: r)]) restFilled
      else
        restFilled.map (c :: ·)
  let M := grid.length
  let N := if M > 0 then grid.head!.length else 0
  let flat := List.flatten grid
  let allFilled := fillHelper flat
  allFilled.map fun f =>
    List.range M |>.map fun i =>
      List.range N |>.map fun j =>
        f[i * N + j]!

-- Count valid flags: those that have the JOI pattern
def countValidFlags (M N : Nat) (grid : List (List Char)) : Nat :=
  let allGrids := fillGrid grid
  let validGrids := allGrids.filter (hasJOIPattern M N)
  validGrids.length

-- Postcondition definitions
@[reducible, simp]
def countGoodFlags_postcond (M : Nat) (N : Nat) (grid : List (List Char)) (result: Nat) (h_precond : countGoodFlags_precond (M) (N) (grid)) : Prop :=
  -- !benchmark @start postcond
  result = countValidFlags M N grid % 100000
  -- !benchmark @end postcond


-- Proof content
theorem countGoodFlags_postcond_satisfied (M: Nat) (N: Nat) (grid: List (List Char)) (h_precond : countGoodFlags_precond (M) (N) (grid)) :
    countGoodFlags_postcond (M) (N) (grid) (countGoodFlags (M) (N) (grid) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_429_p00482