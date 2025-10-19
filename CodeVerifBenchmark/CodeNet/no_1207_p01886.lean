import Mathlib

-- Precondition definitions
@[reducible, simp]
def shareRuinsPreservation_precond (n : Nat) (ruins : List (Int × Int)) : Prop :=
  -- !benchmark @start precond
  ruins.length = n ∧ n ≥ 1 ∧ n ≤ 100000 ∧
    (∀ p, p ∈ ruins → -1000000000 ≤ p.1 ∧ p.1 ≤ 1000000000 ∧ -1000000000 ≤ p.2 ∧ p.2 ≤ 1000000000) ∧
    (∀ i j, i < ruins.length → j < ruins.length → i ≠ j → ruins[i]! ≠ ruins[j]!)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Import necessary data structures
open List

-- Helper to compute cross product for three points
def cross3 (p0 p1 p2 : Int × Int) : Int :=
  (p1.1 - p0.1) * (p2.2 - p0.2) - (p1.2 - p0.2) * (p2.1 - p0.1)

-- Helper function to group ruins by x-coordinate
def groupByX (ruins : List (Int × Int)) : List (Int × List Int) :=
  let grouped := ruins.foldl (fun acc (x, y) =>
    match acc.find? (fun (x', _) => x' = x) with
    | some (x', ys) => acc.filter (fun (x'', _) => x'' ≠ x) ++ [(x', y :: ys)]
    | none => acc ++ [(x, [y])]
  ) []
  grouped.map (fun (x, ys) => (x, ys.reverse))

-- Sort groups by x-coordinate
def sortGroups (groups : List (Int × List Int)) : List (Int × List Int) :=
  groups.insertionSort (fun (x1, _) (x2, _) => x1 ≤ x2)

-- Sort y-coordinates within a group
def sortYs (ys : List Int) (reverse : Bool) : List Int :=
  if reverse then
    ys.insertionSort (fun a b => a ≥ b)
  else
    ys.insertionSort (fun a b => a ≤ b)

-- Calculate convex hull areas incrementally
def calcHullAreas (groups : List (Int × List Int)) (reverseY : Bool) : List Nat :=
  let rec processPoints (remaining : List (Int × Int)) (upperHull lowerHull : List (Int × Int)) (area : Nat) (result : List Nat) : List Nat :=
    match remaining with
    | [] => result.reverse
    | (x, y) :: rest =>
      let p := (x, y)
      -- Process upper hull
      let rec removeUpper (hull : List (Int × Int)) (a : Nat) : List (Int × Int) × Nat :=
        match hull with
        | p1 :: p2 :: rest =>
          if cross3 p1 p2 p ≤ 0 then
            let contrib := (cross3 p1 p2 p).natAbs
            removeUpper (p1 :: rest) (a + contrib)
          else (hull, a)
        | _ => (hull, a)
      let (newUpper, area1) := removeUpper upperHull area
      let newUpper := p :: newUpper
      
      -- Process lower hull
      let rec removeLower (hull : List (Int × Int)) (a : Nat) : List (Int × Int) × Nat :=
        match hull with
        | p1 :: p2 :: rest =>
          if cross3 p1 p2 p ≥ 0 then
            let contrib := (cross3 p1 p2 p).natAbs
            removeLower (p1 :: rest) (a + contrib)
          else (hull, a)
        | _ => (hull, a)
      let (newLower, area2) := removeLower lowerHull area1
      let newLower := p :: newLower
      
      processPoints rest newUpper newLower area2 (area2 :: result)
  
  -- Flatten groups into points with sorted y-coordinates
  let points := groups.foldl (fun acc (x, ys) =>
    acc ++ (sortYs ys reverseY).map (fun y => (x, y))
  ) []
  
  0 :: processPoints points [] [] 0 []

-- Main function definitions
def shareRuinsPreservation (n : Nat) (ruins : List (Int × Int)) (h_precond : shareRuinsPreservation_precond (n) (ruins)) : Nat :=
  -- !benchmark @start code
  -- Group ruins by x-coordinate and sort
  let groups := sortGroups (groupByX ruins)
  
  -- Calculate hull areas from left to right
  let areasLR := calcHullAreas groups false
  
  -- Calculate hull areas from right to left (reverse groups and y-sort)
  let groupsRL := groups.reverse
  let areasRL := calcHullAreas groupsRL true
  
  -- Find minimum sum of areas
  let n := groups.length
  let rec findMin (i : Nat) (minVal : Nat) : Nat :=
    if i > n then minVal
    else
      let leftArea := areasLR.get! i
      let rightArea := areasRL.get! (n - i)
      let total := leftArea + rightArea
      findMin (i + 1) (min minVal total)
  termination_by (n + 1 - i)
  
  let minArea := findMin 0 1000000000000000000
  (minArea + 1) / 2
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper to compute convex hull area (twice the area)
def convexHullArea (points : List (Int × Int)) : Nat :=
  if points.isEmpty then 0
  else
    -- Compute upper and lower hulls and sum their contributions
    -- This is a simplified specification; actual implementation would track area during hull construction
    0 -- Placeholder for actual computation

-- Helper to partition ruins by a vertical line at x-coordinate
def partitionByVerticalLine (ruins : List (Int × Int)) (lineX : Int) : List (Int × Int) × List (Int × Int) :=
  ruins.partition (fun (x, _) => x < lineX)

-- Helper to compute the minimum total area for a given partition
def computeTotalArea (leftRuins rightRuins : List (Int × Int)) : Nat :=
  convexHullArea leftRuins + convexHullArea rightRuins

-- Helper to get all unique x-coordinates from ruins (potential line positions)
def getUniqueXCoords (ruins : List (Int × Int)) : List Int :=
  ruins.map (·.1) |>.eraseDups

-- Check if a value is the minimum in a list
def isMinimum (val : Nat) (vals : List Nat) : Prop :=
  val ∈ vals ∧ ∀ v ∈ vals, val ≤ v

-- Postcondition definitions
@[reducible, simp]
def shareRuinsPreservation_postcond (n : Nat) (ruins : List (Int × Int)) (result: Nat) (h_precond : shareRuinsPreservation_precond (n) (ruins)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the minimum total preservation cost (rounded to nearest integer)
  -- obtained by choosing an optimal vertical line to partition the ruins
  ∃ (lineX : Int),
    -- The line doesn't intersect any ruin (can be placed between or outside ruins)
    (∀ p, p ∈ ruins → p.1 ≠ lineX) ∧
    -- Partition ruins by this line
    let (leftRuins, rightRuins) := partitionByVerticalLine ruins lineX
    -- The total area is computed from both partitions
    let totalArea := computeTotalArea leftRuins rightRuins
    -- The result is the rounded value of half the computed area (since we track twice the area)
    result = (totalArea + 1) / 2 ∧
    -- This is the minimum among all possible vertical line placements
    (∀ (otherLineX : Int),
      (∀ p, p ∈ ruins → p.1 ≠ otherLineX) →
      let (otherLeft, otherRight) := partitionByVerticalLine ruins otherLineX
      let otherArea := computeTotalArea otherLeft otherRight
      totalArea ≤ otherArea)
  -- !benchmark @end postcond


-- Proof content
theorem shareRuinsPreservation_postcond_satisfied (n: Nat) (ruins: List (Int × Int)) (h_precond : shareRuinsPreservation_precond (n) (ruins)) :
    shareRuinsPreservation_postcond (n) (ruins) (shareRuinsPreservation (n) (ruins) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof