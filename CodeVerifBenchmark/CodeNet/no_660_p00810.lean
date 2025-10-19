import Mathlib

-- Precondition auxiliary definitions
-- Helper function to compute squared distance between two 3D points
def distSquared (p1 p2 : Float × Float × Float) : Float :=
  let (x1, y1, z1) := p1
  let (x2, y2, z2) := p2
  (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) + (z1 - z2) * (z1 - z2)

-- Helper function to check if all coordinates are within valid range [0.0, 100.0]
def validCoordinates (p : Float × Float × Float) : Prop :=
  let (x, y, z) := p
  0.0 ≤ x ∧ x ≤ 100.0 ∧ 0.0 ≤ y ∧ y ≤ 100.0 ∧ 0.0 ≤ z ∧ z ≤ 100.0

-- Helper function to check if two points are at least 0.01 apart
def minDistance (p1 p2 : Float × Float × Float) : Prop :=
  distSquared p1 p2 ≥ 0.01 * 0.01

-- Precondition definitions
@[reducible, simp]
def findSmallestSphereRadius_precond (stars : List (Float × Float × Float)) : Prop :=
  -- !benchmark @start precond
  -- The list must contain at least 4 points and at most 30 points
  stars.length ≥ 4 ∧ stars.length ≤ 30 ∧
  -- All coordinates must be within valid range
  (∀ p ∈ stars, validCoordinates p) ∧
  -- All points must be at least 0.01 apart from each other
  (∀ i j, i < stars.length → j < stars.length → i ≠ j → 
    minDistance stars[i]! stars[j]!)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to find the farthest star from a given center
def findFarthestStar (center : Float × Float × Float) (stars : List (Float × Float × Float)) : Nat × Float :=
  stars.enum.foldl (fun (maxIdx, maxDist) (idx, star) =>
    let dist := distSquared center star
    if dist > maxDist then (idx, dist) else (maxIdx, maxDist)
  ) (0, 0.0)

-- Helper function to move center towards a target point by a fraction
def moveTowards (center target : Float × Float × Float) (fraction : Float) : Float × Float × Float :=
  let (cx, cy, cz) := center
  let (tx, ty, tz) := target
  (cx - (cx - tx) * fraction, cy - (cy - ty) * fraction, cz - (cz - tz) * fraction)

-- Iterative optimization to find approximate center
def optimizeCenter (stars : List (Float × Float × Float)) (outerIters innerIters : Nat) : Float × Float × Float :=
  let rec innerLoop (center : Float × Float × Float) (move : Float) (remaining : Nat) : Float × Float × Float :=
    match remaining with
    | 0 => center
    | n + 1 =>
      let (farthestIdx, _) := findFarthestStar center stars
      let farthestStar := stars[farthestIdx]!
      let newCenter := moveTowards center farthestStar move
      innerLoop newCenter move n
  
  let rec outerLoop (center : Float × Float × Float) (move : Float) (remaining : Nat) : Float × Float × Float :=
    match remaining with
    | 0 => center
    | n + 1 =>
      let newCenter := innerLoop center move innerIters
      outerLoop newCenter (move / 2.0) n
  
  outerLoop (0.0, 0.0, 0.0) 0.5 outerIters

-- Compute maximum distance from center to any star
def computeMaxDistance (center : Float × Float × Float) (stars : List (Float × Float × Float)) : Float :=
  let (_, maxDistSq) := findFarthestStar center stars
  Float.sqrt maxDistSq

-- Main function definitions
def findSmallestSphereRadius (stars : List (Float × Float × Float)) (h_precond : findSmallestSphereRadius_precond (stars)) : Float :=
  -- !benchmark @start code
  -- Use iterative optimization similar to the Python code
    let center := optimizeCenter stars 500 100
    let radius := computeMaxDistance center stars
    radius
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to compute the maximum distance from a center to any star
def maxDistFromCenter (center : Float × Float × Float) (stars : List (Float × Float × Float)) : Float :=
  stars.foldl (fun acc star => max acc (Float.sqrt (distSquared center star))) 0.0

-- Helper predicate: all stars are contained in or on a sphere with given center and radius
def allStarsInSphere (center : Float × Float × Float) (radius : Float) (stars : List (Float × Float × Float)) : Prop :=
  ∀ star ∈ stars, Float.sqrt (distSquared center star) ≤ radius + 0.00001

-- Postcondition definitions
@[reducible, simp]
def findSmallestSphereRadius_postcond (stars : List (Float × Float × Float)) (result: Float) (h_precond : findSmallestSphereRadius_precond (stars)) : Prop :=
  -- !benchmark @start postcond
  -- The result must be non-negative
  result ≥ 0.0 ∧
  -- There exists a center point such that all stars are within distance result from it
  (∃ center : Float × Float × Float, allStarsInSphere center result stars) ∧
  -- For any smaller radius (by more than the error tolerance), 
  -- there is no center that contains all stars
  (∀ r : Float, r < result - 0.00001 → 
    ∀ center : Float × Float × Float, ¬(allStarsInSphere center r stars))
  -- !benchmark @end postcond


-- Proof content
theorem findSmallestSphereRadius_postcond_satisfied (stars: List (Float × Float × Float)) (h_precond : findSmallestSphereRadius_precond (stars)) :
    findSmallestSphereRadius_postcond (stars) (findSmallestSphereRadius (stars) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof