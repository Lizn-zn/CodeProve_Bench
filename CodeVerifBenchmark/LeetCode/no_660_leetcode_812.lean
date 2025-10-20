import Mathlib

namespace no_660_leetcode_812


-- Precondition auxiliary definitions
def triangleArea (p1 p2 p3 : Int × Int) : Float :=
  let (x1, y1) := p1
  let (x2, y2) := p2
  let (x3, y3) := p3
  Float.abs (Float.ofInt (x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2))) / 2

-- Precondition definitions
@[reducible, simp]
def largestTriangleArea_precond (points : List (Int × Int)) : Prop :=
  -- !benchmark @start precond
  3 ≤ points.length ∧ points.length ≤ 50 ∧ points.all (fun p => -50 ≤ p.1 ∧ p.1 ≤ 50 ∧ -50 ≤ p.2 ∧ p.2 ≤ 50)
  -- !benchmark @end precond


-- Code auxiliary definitions
def allTriangleAreas (points : List (Int × Int)) : List Float :=
  let pointList := points.toArray
  let n := pointList.size
  List.flatten (List.map (fun i => List.flatten (List.map (fun j => List.map (fun k => triangleArea pointList[i]! pointList[j]! pointList[k]!) (List.filter (fun k => i < j ∧ j < k) (List.range n))) (List.range n))) (List.range n))

-- Main function definitions
def largestTriangleArea (points : List (Int × Int)) (h_precond : largestTriangleArea_precond (points)) : Float :=
  -- !benchmark @start code
  let areas := allTriangleAreas points
  areas.foldl (max) 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def allTriangleAreas_post (points : List (Int × Int)) : List Float :=
  let pointList := points.toArray
  let n := pointList.size
  List.flatten (List.map (fun i => List.flatten (List.map (fun j => List.map (fun k => triangleArea pointList[i]! pointList[j]! pointList[k]!) (List.filter (fun k => i < j ∧ j < k) (List.range n))) (List.range n))) (List.range n))

-- Postcondition definitions
@[reducible, simp]
def largestTriangleArea_postcond (points : List (Int × Int)) (result: Float) (h_precond : largestTriangleArea_precond (points)) : Prop :=
  -- !benchmark @start postcond
  let expected := (allTriangleAreas_post points).foldl (max) 0
  result ≥ expected - 1e-5 ∧ result ≤ expected + 1e-5
  -- !benchmark @end postcond


-- Proof content
theorem largestTriangleArea_postcond_satisfied (points: List (Int × Int)) (h_precond : largestTriangleArea_precond (points)) :
    largestTriangleArea_postcond (points) (largestTriangleArea (points) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_660_leetcode_812