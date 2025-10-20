import Mathlib

namespace no_1576_p02447


-- Precondition definitions
@[reducible, simp]
def sortPairs_precond (points : List (Int × Int)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Comparison function for sorting by x then y
def comparePoints (p1 p2 : Int × Int) : Bool :=
  let (x1, y1) := p1
  let (x2, y2) := p2
  x1 < x2 || (x1 == x2 && y1 < y2)

-- Main function definitions
def sortPairs (points : List (Int × Int)) (h_precond : sortPairs_precond (points)) : List (Int × Int) :=
  -- !benchmark @start code
  -- Sort the points using merge sort with our comparison function
    points.mergeSort comparePoints
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if a list is sorted by the given criteria
def isSortedByXThenY : List (Int × Int) → Bool
  | [] => true
  | [_] => true
  | (x1, y1) :: (x2, y2) :: rest =>
    (x1 < x2 || (x1 == x2 && y1 ≤ y2)) && isSortedByXThenY ((x2, y2) :: rest)

-- Helper function to check if two lists contain the same elements (multiset equality)
def sameElements (l1 l2 : List (Int × Int)) : Prop :=
  ∀ p, l1.count p = l2.count p

-- Postcondition definitions
@[reducible, simp]
def sortPairs_postcond (points : List (Int × Int)) (result: List (Int × Int)) (h_precond : sortPairs_precond (points)) : Prop :=
  -- !benchmark @start postcond
  -- The result is sorted first by x-coordinate, then by y-coordinate
    isSortedByXThenY result = true ∧
    -- The result contains exactly the same elements as the input
    sameElements result points
  -- !benchmark @end postcond


-- Proof content
theorem sortPairs_postcond_satisfied (points: List (Int × Int)) (h_precond : sortPairs_precond (points)) :
    sortPairs_postcond (points) (sortPairs (points) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1576_p02447