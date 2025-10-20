import Mathlib

namespace no_186_leetcode_218


-- Precondition auxiliary definitions
/-- Represents a single building with left, right, and height coordinates. -/
structure Building where
  left : Int
  right : Int
  height : Int
deriving Repr, DecidableEq

/-- Converts a list of three integers into a Building. Returns none if the list does not have exactly three elements. -/
def listToBuilding (l : List Int) : Option Building :=
  match l with
  | [left, right, height] => some { left := left, right := right, height := height }
  | _ => none

/-- Checks if a building is valid: left < right and height > 0. -/
def isValidBuilding (b : Building) : Bool :=
  b.left < b.right ∧ b.height > 0

/-- Checks if a list of buildings is sorted by their left coordinate. -/
def sortedByLeft (buildings : List Building) : Bool :=
  match buildings with
  | [] => true
  | [b] => true
  | b₁ :: b₂ :: bs => b₁.left ≤ b₂.left ∧ sortedByLeft (b₂ :: bs)

/-- Checks if a point [x, y] is valid: both x and y are non-negative integers. -/
def isValidPoint (p : List Int) : Bool :=
  match p with
  | [x, y] => x ≥ 0 ∧ y ≥ 0
  | _ => false

/-- Checks if a list of points is sorted by their x-coordinate. -/
def sortedByX (points : List (List Int)) : Bool :=
  match points with
  | [] => true
  | [p] => true
  | p₁ :: p₂ :: ps =>
    match p₁, p₂ with
    | [x1, _], [x2, _] => x1 ≤ x2 ∧ sortedByX (p₂ :: ps)
    | _, _ => false

/-- Checks if there are no consecutive horizontal lines of equal height in the skyline. -/
def noConsecutiveEqualHeights (skyline : List (List Int)) : Bool :=
  match skyline with
  | [] => true
  | [_] => true
  | [p1, p2] =>
    match p1, p2 with
    | [_, y1], [_, y2] => y1 ≠ y2
    | _, _ => true
  | p1 :: p2 :: rest =>
    match p1, p2 with
    | [_, y1], [_, y2] => y1 ≠ y2 ∧ noConsecutiveEqualHeights (p2 :: rest)
    | _, _ => noConsecutiveEqualHeights (p2 :: rest)

/-- Checks if the skyline starts and ends correctly. -/
def validStartEnd (skyline : List (List Int)) : Bool :=
  match skyline with
  | [] => true
  | [p] => match p with | [_, 0] => true | _ => false
  | p_first :: _ =>
    match p_first with
    | [_, y] => y > 0
    | _ => false
  && match skyline.getLast? with
     | some p_last => match p_last with | [_, 0] => true | _ => false
     | none => true

/-- Checks if all points in the skyline are valid. -/
def allPointsValid (skyline : List (List Int)) : Bool :=
  skyline.all (fun p => isValidPoint p)

/-- Checks if the skyline alternates correctly between buildings and ground. -/
def validTransitions (skyline : List (List Int)) : Bool :=
  match skyline with
  | [] => true
  | [_] => true
  | p1 :: p2 :: rest =>
    match p1, p2 with
    | [x1, y1], [x2, y2] =>
      x1 < x2 &&
      (if y1 > 0 then y2 ≥ 0 else true) &&
      (if y1 = 0 then y2 > 0 else true) &&
      validTransitions (p2 :: rest)
    | _, _ => validTransitions (p2 :: rest)

/-- Computes the maximum x-coordinate among all buildings. -/
def maxRight (buildings : List Building) : Int :=
  match buildings with
  | [] => 0
  | b :: bs =>
    let rec maxHelper (acc : Int) (remaining : List Building) : Int :=
      match remaining with
      | [] => acc
      | b' :: bs' => maxHelper (max acc b'.right) bs'
    maxHelper b.right bs

/-- Computes the critical x-coordinates where the skyline might change. -/
def criticalPoints (buildings : List Building) : List Int :=
  let lefts := buildings.map (·.left)
  let rights := buildings.map (·.right)
  (lefts ++ rights).eraseDups.mergeSort (· ≤ ·)

/-- Evaluates the maximum height at a given x-coordinate. -/
def maxHeightAt (buildings : List Building) (x : Int) : Int :=
  let activeBuildings := buildings.filter (fun b => b.left ≤ x ∧ x < b.right)
  match activeBuildings with
  | [] => 0
  | bs => bs.map (·.height) |>.foldl max 0

/-- Generates the expected skyline from the buildings. -/
def expectedSkyline (buildings : List Building) : List (List Int) :=
  let points := criticalPoints buildings
  let heights := points.map (maxHeightAt buildings ·)
  -- Pair up points and heights
  let paired := List.zip points heights
  -- Remove consecutive points with the same height
  let rec removeConsecutiveSameHeight (acc : List (List Int)) (remaining : List (Int × Int)) : List (List Int) :=
    match remaining with
    | [] => acc.reverse
    | [(x, h)] => (([x, h] : List Int)) :: acc.reverse
    | (x1, h1) :: (x2, h2) :: rest =>
      if h1 = h2 then
        removeConsecutiveSameHeight acc ((x1, h1) :: rest)
      else
        removeConsecutiveSameHeight (([x1, h1] : List Int) :: acc) ((x2, h2) :: rest)
  removeConsecutiveSameHeight [] (paired.map (fun (x, h) => (x, h)))

-- Precondition definitions
@[reducible, simp]
def get_skyline_precond (buildings : List (List Int)) : Prop :=
  -- !benchmark @start precond
  -- Buildings list is not empty, each building has exactly 3 elements,
  -- all buildings are valid (left < right, height > 0),
  -- and buildings are sorted by left coordinate.
  match buildings with
  | [] => False
  | bs =>
    let buildingsOption := bs.map listToBuilding
    let validBuildings := bs.all (fun b => b.length = 3)
    let buildingsParsed := buildingsOption.all (fun b => b.isSome)
    let buildingsExtracted := buildingsOption.map (Option.getD · {left := 0, right := 0, height := 0})
    validBuildings ∧ buildingsParsed ∧
    (let bs' := buildingsExtracted;
     bs'.all (fun b => isValidBuilding b) ∧ sortedByLeft bs')
  -- !benchmark @end precond


-- Main function definitions
def get_skyline (buildings : List (List Int)) (h_precond : get_skyline_precond (buildings)) : List (List Int) :=
  -- !benchmark @start code
  -- Convert input buildings to a list of Building structures
  let buildingsParsed := (buildings.map listToBuilding).map (Option.getD · {left := 0, right := 0, height := 0});
  -- Compute and return the skyline
  expectedSkyline buildingsParsed
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def get_skyline_postcond (buildings : List (List Int)) (result: List (List Int)) (h_precond : get_skyline_precond (buildings)) : Prop :=
  -- !benchmark @start postcond
  -- Convert input buildings to a list of Building structures
  let buildingsParsed := (buildings.map listToBuilding).map (Option.getD · {left := 0, right := 0, height := 0});
  -- Compute the expected skyline
  let expected := expectedSkyline buildingsParsed;
  -- Check that the result matches the expected skyline
  result = expected ∧
  -- Validate properties of the result
  sortedByX result ∧
  noConsecutiveEqualHeights result ∧
  validStartEnd result ∧
  allPointsValid result ∧
  validTransitions result
  -- !benchmark @end postcond


-- Proof content
theorem get_skyline_postcond_satisfied (buildings: List (List Int)) (h_precond : get_skyline_precond (buildings)) :
    get_skyline_postcond (buildings) (get_skyline (buildings) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_186_leetcode_218