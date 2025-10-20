import Mathlib

namespace no_2150_p03130


-- Precondition definitions
@[reducible, simp]
def canVisitAllTowns_precond (roads : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  roads.length = 3 ∧
    -- Each road connects two different towns numbered 1-4
    (∀ road ∈ roads, let (a, b) := road; 1 ≤ a ∧ a ≤ 4 ∧ 1 ≤ b ∧ b ≤ 4 ∧ a ≠ b) ∧
    -- No two roads connect the same pair of towns
    (∀ i j, i < roads.length → j < roads.length → i ≠ j →
      let (a1, b1) := roads[i]!
      let (a2, b2) := roads[j]!
      ¬((a1 = a2 ∧ b1 = b2) ∨ (a1 = b2 ∧ b1 = a2)))
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to count the degree of each town
def computeDegrees (roads : List (Nat × Nat)) : List Nat :=
  let degrees := [0, 0, 0, 0]
  roads.foldl (fun acc (a, b) =>
    let acc' := acc.set (a - 1) (acc[a - 1]! + 1)
    acc'.set (b - 1) (acc'[b - 1]! + 1)
  ) degrees

-- Main function definitions
def canVisitAllTowns (roads : List (Nat × Nat)) (h_precond : canVisitAllTowns_precond (roads)) : String :=
  -- !benchmark @start code
  let degrees := computeDegrees roads
    -- Check if any town has degree 3
    let hasDegree3 := degrees.any (fun d => d == 3)
    if hasDegree3 then
      "NO"
    else
      "YES"
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Compute the degree of each town (how many roads connect to it)
def townDegree (roads : List (Nat × Nat)) (town : Nat) : Nat :=
  roads.foldl (fun acc (a, b) => acc + (if a = town then 1 else 0) + (if b = town then 1 else 0)) 0

-- Check if there exists an Eulerian path in the graph
-- An Eulerian path exists if and only if the graph has exactly 0 or 2 vertices of odd degree
def hasEulerianPath (roads : List (Nat × Nat)) : Bool :=
  let degrees := [1, 2, 3, 4].map (townDegree roads)
  let oddDegreeCount := degrees.filter (fun d => d % 2 = 1) |>.length
  oddDegreeCount = 0 || oddDegreeCount = 2

-- Postcondition definitions
@[reducible, simp]
def canVisitAllTowns_postcond (roads : List (Nat × Nat)) (result: String) (h_precond : canVisitAllTowns_precond (roads)) : Prop :=
  -- !benchmark @start postcond
  -- The result is "YES" if and only if we can traverse all roads exactly once visiting all towns
    -- This is equivalent to checking if there exists an Eulerian path in the graph
    -- Since we have 4 towns and 3 roads, and the graph is connected (given in constraints),
    -- an Eulerian path exists iff no town has degree 3 (which would mean odd degree > 2)
    result = "YES" ↔ hasEulerianPath roads
  -- !benchmark @end postcond


-- Proof content
theorem canVisitAllTowns_postcond_satisfied (roads: List (Nat × Nat)) (h_precond : canVisitAllTowns_precond (roads)) :
    canVisitAllTowns_postcond (roads) (canVisitAllTowns (roads) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2150_p03130