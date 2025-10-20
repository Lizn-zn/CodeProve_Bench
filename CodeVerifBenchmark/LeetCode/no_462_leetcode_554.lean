import Mathlib

namespace no_462_leetcode_554


-- Precondition auxiliary definitions
def wallWidth (wall : List (List Nat)) : Option Nat :=
  match wall with
  | [] => some 0
  | row :: _ => 
    let totalWidth := row.foldl (· + ·) 0
    if wall.all (fun r => r.foldl (· + ·) 0 = totalWidth) then
      some totalWidth
    else
      none

def isValidWall (wall : List (List Nat)) : Prop :=
  wall ≠ [] ∧
  wall.all (fun row => row ≠ [] ∧ row.all (· > 0)) ∧
  (wallWidth wall).isSome

-- Precondition definitions
@[reducible, simp]
def leastBricks_precond (wall : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  isValidWall wall
  -- !benchmark @end precond


-- Code auxiliary definitions
def countGapsAtPosition (wall : List (List Nat)) (pos : Nat) : Nat :=
  wall.foldl (fun count row =>
    let cumulativeWidths := row.scanl (· + ·) 0
    -- Check if `pos` is in the list of internal cumulative widths (gaps)
    -- We exclude the last cumulative width (which equals the total width)
    let rowWidth := row.foldl (· + ·) 0
    if cumulativeWidths.contains pos ∧ pos < rowWidth then
      count  -- This row has a gap at `pos`, so it's not crossed
    else
      count + 1  -- This row does not have a gap at `pos`, so it's crossed
  ) 0

def getAllGapPositions (wall : List (List Nat)) : List Nat :=
  let allCumulativeWidths := wall.flatMap (fun row =>
    let cumulativeWidths := row.scanl (· + ·) 0
    let rowWidth := row.foldl (· + ·) 0
    cumulativeWidths.filter (fun pos => pos > 0 ∧ pos < rowWidth)
  )
  allCumulativeWidths.eraseDups

-- Main function definitions
def leastBricks (wall : List (List Nat)) (h_precond : leastBricks_precond (wall)) : Nat :=
  -- !benchmark @start code
  match wallWidth wall with
    | none => 0  -- This case should not occur due to precondition
    | some width =>
      if width ≤ 1 then
        wall.length
      else
        let gapPositions := getAllGapPositions wall
        if gapPositions = [] then
          wall.length  -- No internal gaps, line must cross all bricks
        else
          let gapCrossCounts := gapPositions.map (fun pos => countGapsAtPosition wall pos)
          match gapCrossCounts.foldl (fun min_count count => 
                 match min_count with
                 | none => some count
                 | some m => some (min m count)) none with
          | none => wall.length
          | some minCrossed => minCrossed
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def countGaps (wall : List (List Nat)) (pos : Nat) : Nat :=
  wall.foldl (fun count row =>
    let cumulativeWidths := row.scanl (· + ·) 0
    let gaps := cumulativeWidths.filter (· < (row.foldl (· + ·) 0))
    if gaps.contains pos then
      count
    else
      count + 1
  ) 0

def maxGapAlignment (wall : List (List Nat)) : Nat :=
  match wallWidth wall with
  | none => 0
  | some width =>
    if width ≤ 1 then
      wall.length
    else
      let positions := List.range (width - 1)
      let gapCounts := positions.map (fun pos => 
        wall.foldl (fun count row =>
          let cumulativeWidths := row.scanl (· + ·) 0
          let gaps := cumulativeWidths.filter (· < (row.foldl (· + ·) 0))
          if gaps.contains (pos + 1) then
            count
          else
            count + 1
        ) 0
      )
      match gapCounts.foldl (fun min_count count => 
             match min_count with
             | none => some count
             | some m => some (min m count)) none with
      | none => wall.length
      | some minCrossed => minCrossed

-- Postcondition definitions
@[reducible, simp]
def leastBricks_postcond (wall : List (List Nat)) (result: Nat) (h_precond : leastBricks_precond (wall)) : Prop :=
  -- !benchmark @start postcond
  result = maxGapAlignment wall
  -- !benchmark @end postcond


-- Proof content
theorem leastBricks_postcond_satisfied (wall: List (List Nat)) (h_precond : leastBricks_precond (wall)) :
    leastBricks_postcond (wall) (leastBricks (wall) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_462_leetcode_554