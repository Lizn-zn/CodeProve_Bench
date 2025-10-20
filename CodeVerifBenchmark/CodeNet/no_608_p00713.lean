import Mathlib

namespace no_608_p00713


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def maxPointsInCircle_precond (points : List (Float × Float)) : Prop :=
  -- !benchmark @start precond
  -- Points list is non-empty and contains valid coordinates
    points.length > 0 ∧ 
    points.length ≤ 300 ∧
    (∀ p ∈ points, 0.0 ≤ p.1 ∧ p.1 ≤ 10.0 ∧ 0.0 ≤ p.2 ∧ p.2 ≤ 10.0)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute the two possible circle centers given two points on the circle
def circleCenters (p1 p2 : Float × Float) : Option (List (Float × Float)) :=
  let x1 := p1.1
  let y1 := p1.2
  let x2 := p2.1
  let y2 := p2.2
  let xd := x2 - x1
  let yd := y2 - y1
  let d_sq := xd * xd + yd * yd
  -- If points are too far apart (> 2.0), no circle of radius 1 can contain both
  if d_sq > 4.0 then
    none
  else
    let d := Float.sqrt d_sq
    -- Avoid division by zero
    if d < 0.0001 then
      none
    else
      let k := Float.sqrt (4.0 - d_sq) / d / 2.0
      let xc := (x1 + x2) / 2.0
      let yc := (y1 + y2) / 2.0
      some [
        (xc - k * yd, yc + k * xd),
        (xc + k * yd, yc - k * xd)
      ]

-- Helper function to count points within distance threshold from a given point
def countInRange (points : List (Float × Float)) (center : Float × Float) (radius : Float) : Nat :=
  points.foldl (fun count p =>
    let dx := p.1 - center.1
    let dy := p.2 - center.2
    let dist_sq := dx * dx + dy * dy
    if dist_sq ≤ radius * radius then count + 1 else count
  ) 0

-- Main function definitions
def maxPointsInCircle (points : List (Float × Float)) (h_precond : maxPointsInCircle_precond (points)) : Nat :=
  -- !benchmark @start code
  -- Sort points by x-coordinate for optimization
    let sortedPoints := points.insertionSort (fun p1 p2 => p1.1 < p2.1)
    
    -- Try all pairs of points and find circle centers
    let rec tryAllPairs (i : Nat) (maxCount : Nat) : Nat :=
      if i >= sortedPoints.length then
        maxCount
      else
        let p_i := sortedPoints[i]!
        let rec tryPairsFrom (j : Nat) (currentMax : Nat) : Nat :=
          if j >= sortedPoints.length then
            currentMax
          else
            let p_j := sortedPoints[j]!
            -- Optimization: if x-distance > 2, skip
            if p_j.1 - p_i.1 > 2.0 then
              currentMax
            else
              let newMax := match circleCenters p_i p_j with
                | none => currentMax
                | some centers =>
                  centers.foldl (fun acc center =>
                    let count := countInRange sortedPoints center 1.0
                    max acc count
                  ) currentMax
              tryPairsFrom (j + 1) newMax
        
        let maxAfterI := tryPairsFrom (i + 1) maxCount
        tryAllPairs (i + 1) maxAfterI
    
    -- Also consider circles centered to contain single points
    let singlePointMax := sortedPoints.foldl (fun acc _ => max acc 1) 1
    
    tryAllPairs 0 singlePointMax
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to compute distance between two points
def distance (p1 p2 : Float × Float) : Float :=
  let dx := p1.1 - p2.1
  let dy := p1.2 - p2.2
  Float.sqrt (dx * dx + dy * dy)

-- Helper function to check if a point is enclosed by a circle (center, radius)
def isEnclosed (point : Float × Float) (center : Float × Float) (radius : Float) : Bool :=
  distance point center ≤ radius

-- Helper function to count points enclosed by a circle at a given center
def countEnclosed (points : List (Float × Float)) (center : Float × Float) (radius : Float) : Nat :=
  points.foldl (fun count p => if isEnclosed p center radius then count + 1 else count) 0

-- Check if there exists a circle of radius 1 that encloses exactly n points
def existsCircleEnclosingN (points : List (Float × Float)) (n : Nat) : Prop :=
  ∃ (center : Float × Float), countEnclosed points center 1.0 = n

-- Postcondition definitions
@[reducible, simp]
def maxPointsInCircle_postcond (points : List (Float × Float)) (result: Nat) (h_precond : maxPointsInCircle_precond (points)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the maximum number of points that can be enclosed by a circle of radius 1
    -- 1. The result is at least 1 (since we have at least one point)
    result ≥ 1 ∧
    -- 2. The result does not exceed the total number of points
    result ≤ points.length ∧
    -- 3. There exists a circle of radius 1 that encloses exactly 'result' points
    existsCircleEnclosingN points result ∧
    -- 4. No circle of radius 1 can enclose more than 'result' points
    (∀ n : Nat, n > result → ¬existsCircleEnclosingN points n)
  -- !benchmark @end postcond


-- Proof content
theorem maxPointsInCircle_postcond_satisfied (points: List (Float × Float)) (h_precond : maxPointsInCircle_precond (points)) :
    maxPointsInCircle_postcond (points) (maxPointsInCircle (points) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_608_p00713