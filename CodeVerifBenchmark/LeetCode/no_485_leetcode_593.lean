import Mathlib

namespace no_485_leetcode_593


-- Precondition auxiliary definitions
def pointLengthPrecond (p : List Int) : Prop :=
  p.length = 2

-- Precondition definitions
@[reducible, simp]
def isSquare_precond (p1 : List Int) (p2 : List Int) (p3 : List Int) (p4 : List Int) : Prop :=
  -- !benchmark @start precond
  pointLengthPrecond p1 ∧ pointLengthPrecond p2 ∧ pointLengthPrecond p3 ∧ pointLengthPrecond p4
  -- !benchmark @end precond


-- Code auxiliary definitions
def sqDist (p1 p2 : List Int) : Int :=
  (p1[0]! - p2[0]!)^2 + (p1[1]! - p2[1]!)^2

def sort6 (a b c d e f : Int) : List Int :=
  let ds := [a, b, c, d, e, f]
  ds.mergeSort (· ≤ ·)

-- Main function definitions
def isSquare (p1 : List Int) (p2 : List Int) (p3 : List Int) (p4 : List Int) (h_precond : isSquare_precond (p1) (p2) (p3) (p4)) : Bool :=
  -- !benchmark @start code
  let d1 := sqDist p1 p2
    let d2 := sqDist p1 p3
    let d3 := sqDist p1 p4
    let d4 := sqDist p2 p3
    let d5 := sqDist p2 p4
    let d6 := sqDist p3 p4
    let sortedDs := sort6 d1 d2 d3 d4 d5 d6
    (d1 > 0) && (sortedDs[0]! == sortedDs[1]!) && (sortedDs[1]! == sortedDs[2]!) && (sortedDs[2]! == sortedDs[3]!) && (sortedDs[4]! == sortedDs[5]!) && (sortedDs[0]! * 2 == sortedDs[4]!)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def isSquare_postcond_aux (p1 p2 p3 p4 : List Int) : Prop :=
  let d1 := sqDist p1 p2
  let d2 := sqDist p1 p3
  let d3 := sqDist p1 p4
  let d4 := sqDist p2 p3
  let d5 := sqDist p2 p4
  let d6 := sqDist p3 p4
  let ds := [d1, d2, d3, d4, d5, d6]
  let sortedDs := ds.mergeSort (· ≤ ·)
  -- There should be 4 equal smallest distances (sides) and 2 equal largest distances (diagonals)
  -- Also, the diagonals should be twice the sides (Pythagoras)
  (d1 > 0) ∧
  (sortedDs[0]! = sortedDs[1]!) ∧
  (sortedDs[1]! = sortedDs[2]!) ∧
  (sortedDs[2]! = sortedDs[3]!) ∧
  (sortedDs[4]! = sortedDs[5]!) ∧
  (sortedDs[0]! * 2 = sortedDs[4]!)

-- Postcondition definitions
@[reducible, simp]
def isSquare_postcond (p1 : List Int) (p2 : List Int) (p3 : List Int) (p4 : List Int) (result: Bool) (h_precond : isSquare_precond (p1) (p2) (p3) (p4)) : Prop :=
  -- !benchmark @start postcond
  result = isSquare_postcond_aux p1 p2 p3 p4
  -- !benchmark @end postcond


-- Proof content
theorem isSquare_postcond_satisfied (p1: List Int) (p2: List Int) (p3: List Int) (p4: List Int) (h_precond : isSquare_precond (p1) (p2) (p3) (p4)) :
    isSquare_postcond (p1) (p2) (p3) (p4) (isSquare (p1) (p2) (p3) (p4) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_485_leetcode_593