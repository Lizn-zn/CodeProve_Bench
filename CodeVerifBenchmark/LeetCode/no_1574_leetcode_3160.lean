import Mathlib

namespace no_1574_leetcode_3160


-- Precondition auxiliary definitions
def validBallLabel (limit : Nat) (ball : Nat) : Prop :=
  ball ≤ limit

def validColor (color : Nat) : Prop :=
  color ≠ 0

def validQuery (limit : Nat) (query : Nat × Nat) : Prop :=
  validBallLabel limit query.1 ∧ validColor query.2

-- Precondition definitions
@[reducible, simp]
def countDistinctColors_precond (limit : Nat) (queries : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  ∀ q ∈ queries, validQuery limit q
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- A map from ball labels to their current colors -/
def BallColoring := Nat → Nat

/-- An empty coloring where all balls are uncolored (color 0) -/
def emptyColoring : BallColoring := fun _ => 0

/-- Update the coloring by setting ball `ball` to `newColor` -/
def updateColoring (coloring : BallColoring) (ball : Nat) (newColor : Nat) : BallColoring :=
  fun b => if b = ball then newColor else coloring b

/-- A map from colors to their count (how many balls have this color) -/
def ColorCount := Nat → Nat

/-- An empty color count where no colors are present -/
def emptyColorCount : ColorCount := fun _ => 0

/-- Add a color to the count, incrementing its count by 1 -/
def addColor (colorCount : ColorCount) (color : Nat) : ColorCount :=
  if color = 0 then colorCount  -- Don't count uncolored balls
  else fun c => if c = color then colorCount c + 1 else colorCount c

/-- Remove a color from the count, decrementing its count by 1 -/
def removeColor (colorCount : ColorCount) (color : Nat) : ColorCount :=
  if color = 0 then colorCount  -- Uncolored balls aren't tracked
  else fun c => if c = color then
    if colorCount c > 0 then colorCount c - 1 else 0
  else colorCount c

/-- Count how many distinct colors are present (colors with count > 0) -/
def countDistinct (colorCount : ColorCount) (limit : Nat) : Nat :=
  -- We only need to check up to the maximum possible color.
  -- However, since we don't know the max color, we can't iterate finitely this way.
  -- A better approach is to maintain the distinct count dynamically.
  -- This placeholder definition will be replaced by dynamic counting.
  0 -- This is a placeholder

/-- Process a single query, updating the coloring and color count -/
def processQuery (limit : Nat) (state : BallColoring × ColorCount × Nat) (query : Nat × Nat) :
    BallColoring × ColorCount × Nat :=
  let (coloring, colorCount, distinctCount) := state
  let (ball, newColor) := query
  let oldColor := coloring ball
  -- Remove the old color's contribution
  let colorCount1 := removeColor colorCount oldColor
  let distinctCount1 := if oldColor ≠ 0 ∧ colorCount1 oldColor = 0 then distinctCount - 1 else distinctCount
  -- Add the new color's contribution
  let colorCount2 := addColor colorCount1 newColor
  let distinctCount2 := if newColor ≠ 0 ∧ colorCount1 newColor = 0 then distinctCount1 + 1 else distinctCount1
  -- Update the coloring
  let newColoring := updateColoring coloring ball newColor
  (newColoring, colorCount2, distinctCount2)

-- Main function definitions
def countDistinctColors (limit : Nat) (queries : List (Nat × Nat)) (h_precond : countDistinctColors_precond limit queries) : List Nat :=
  -- !benchmark @start code
  let initialState := (emptyColoring, emptyColorCount, 0)
  -- Collect the results by processing queries and keeping track of distinct counts
  let (_, _, results) := queries.foldl (fun (triple : BallColoring × ColorCount × List Nat) query =>
    let (coloring, colorCount, acc) := triple
    let (newColoring, newColorCount, newDistinctCount) := processQuery limit (coloring, colorCount, 0) query
    (newColoring, newColorCount, acc ++ [newDistinctCount])
  ) (emptyColoring, emptyColorCount, [])
  results
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def updateColoring' (coloring : Nat → Nat) (ball : Nat) (newColor : Nat) : Nat → Nat :=
  fun b => if b = ball then newColor else coloring b

def countColors (coloring : Nat → Nat) (limit : Nat) : Nat :=
  let colors := List.range (limit + 1) |>.map coloring |>.filter (· ≠ 0)
  colors.eraseDup.length

def simulateColoring (limit : Nat) (queries : List (Nat × Nat)) : List Nat :=
  let initialColoring : Nat → Nat := fun _ => 0
  let (_, results) := queries.foldl (fun (coloring, acc) (ball, color) =>
    let newColoring := updateColoring' coloring ball color
    let count := countColors newColoring limit
    (newColoring, acc ++ [count])
  ) (initialColoring, [])
  results

-- Postcondition definitions
@[reducible, simp]
def countDistinctColors_postcond (limit : Nat) (queries : List (Nat × Nat)) (result: List Nat) (h_precond : countDistinctColors_precond limit queries) : Prop :=
  -- !benchmark @start postcond
  result = simulateColoring limit queries
  -- !benchmark @end postcond


-- Proof content
theorem countDistinctColors_postcond_satisfied (limit: Nat) (queries: List (Nat × Nat)) (h_precond : countDistinctColors_precond limit queries) :
    countDistinctColors_postcond limit queries (countDistinctColors limit queries h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1574_leetcode_3160