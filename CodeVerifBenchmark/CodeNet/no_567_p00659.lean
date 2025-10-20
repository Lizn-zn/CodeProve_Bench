import Mathlib

namespace no_567_p00659


-- Postcondition auxiliary definitions
-- Calculate how many characters appear at a given time
def countAtTime (characters : List (String × List Nat)) (time : Nat) : Nat :=
  characters.foldl (fun count (_, times) => if times.contains time then count + 1 else count) 0

-- Calculate the total points for a character
def calculatePoints (n : Nat) (characters : List (String × List Nat)) (name : String) (times : List Nat) : Nat :=
  times.foldl (fun total time =>
    let numAtTime := countAtTime characters time
    total + (n - numAtTime + 1)
  ) 0

-- Calculate points for all characters in a test case
def calculateAllPoints (n : Nat) (characters : List (String × List Nat)) : List (Nat × String) :=
  characters.map fun (name, times) => (calculatePoints n characters name times, name)

-- Find the minimum point holder (min points, then lexicographically smallest name)
def findMinimum (points : List (Nat × String)) : Option (Nat × String) :=
  points.foldl (fun acc curr =>
    match acc with
    | none => some curr
    | some (minPts, minName) =>
        if curr.1 < minPts then some curr
        else if curr.1 = minPts ∧ curr.2 < minName then some curr
        else acc
  ) none

-- Precondition definitions
@[reducible, simp]
def popularityEstimation_precond (testCases : List (Nat × List (String × List Nat))) : Prop :=
  -- !benchmark @start precond
  -- Each test case has n characters where 2 ≤ n ≤ 20
    testCases.all fun (n, characters) =>
      n ≥ 2 ∧ n ≤ 20 ∧
      -- The number of characters matches n
      characters.length = n ∧
      -- Each character has a valid name and appearance times
      characters.all fun (name, times) =>
        -- Name is non-empty, contains only letters, and has length ≤ 10
        name.length > 0 ∧ name.length ≤ 10 ∧
        name.all (fun c => c.isAlpha) ∧
        -- Number of appearance times is between 0 and 30
        times.length ≤ 30 ∧
        -- All appearance times are in range [0, 30) and are distinct
        times.all (· < 30) ∧
        times.Nodup
  -- !benchmark @end precond


-- Main function definitions
def popularityEstimation (testCases : List (Nat × List (String × List Nat))) (h_precond : popularityEstimation_precond (testCases)) : List (Nat × String) :=
  -- !benchmark @start code
  testCases.map fun (n, characters) =>
      -- Calculate points for each character
      let allPoints := calculateAllPoints n characters
      -- Find the minimum
      match findMinimum allPoints with
      | some result => result
      | none => (0, "") -- This case should never happen given the preconditions
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def popularityEstimation_postcond (testCases : List (Nat × List (String × List Nat))) (result: List (Nat × String)) (h_precond : popularityEstimation_precond (testCases)) : Prop :=
  -- !benchmark @start postcond
  -- Result has the same length as test cases
    result.length = testCases.length ∧
    -- For each test case, the result is the character with minimum points
    (testCases.zip result).all fun ((n, characters), (pts, name)) =>
      -- Calculate points for all characters
      let allPoints := calculateAllPoints n characters
      -- The result should be the minimum
      findMinimum allPoints = some (pts, name) ∧
      -- Verify the character exists in the input
      characters.any (fun (charName, _) => charName = name)
  -- !benchmark @end postcond


-- Proof content
theorem popularityEstimation_postcond_satisfied (testCases: List (Nat × List (String × List Nat))) (h_precond : popularityEstimation_precond (testCases)) :
    popularityEstimation_postcond (testCases) (popularityEstimation (testCases) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_567_p00659