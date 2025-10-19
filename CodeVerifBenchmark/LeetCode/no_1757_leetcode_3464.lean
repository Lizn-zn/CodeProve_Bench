import Mathlib

-- Precondition auxiliary definitions
/-- Checks whether a point lies on the boundary of a square with given side length. -/
def on_boundary (side : Nat) (p : Nat × Nat) : Prop :=
  let (x, y) := p
  (x = 0 ∧ y ≤ side) ∨ (x = side ∧ y ≤ side) ∨ (y = 0 ∧ x ≤ side) ∨ (y = side ∧ x ≤ side)

/-- Checks if all points in a list lie on the boundary of a square. -/
def all_on_boundary (side : Nat) (points : List (Nat × Nat)) : Prop :=
  ∀ p ∈ points, on_boundary side p

/-- Checks if all points in a list are unique. -/
def unique_points (points : List (Nat × Nat)) : Prop :=
  ∀ p ∈ points, ∀ q ∈ points, p = q → p = q

/-- Computes Manhattan distance between two points. -/
def manhattan_dist (p1 p2 : Nat × Nat) : Nat :=
  let (x1, y1) := p1
  let (x2, y2) := p2
  (if x1 ≥ x2 then x1 - x2 else x2 - x1) + (if y1 ≥ y2 then y1 - y2 else y2 - y1)

/-- Checks if a selection of k points satisfies a minimum distance constraint. -/
def has_min_distance (k : Nat) (selected : List (Nat × Nat)) (d : Nat) : Prop :=
  selected.length = k ∧
  (∀ i j, i < selected.length → j < selected.length → i ≠ j →
    manhattan_dist (selected.get ⟨i, by sorry⟩) (selected.get ⟨j, by sorry⟩) ≥ d)

/-- Generates all combinations of k points from the list. -/
def combinations (l : List α) (k : Nat) : List (List α) :=
  if k = 0 then [[]] else
  match l with
  | [] => []
  | x :: xs =>
    let with_x := List.map (fun sub => x :: sub) (combinations xs (k-1))
    let without_x := combinations xs k
    with_x ++ without_x

-- Precondition definitions
def maximize_minimum_manhattan_distance_precond (side : Nat) (points : List (Nat × Nat)) (k : Nat) : Prop :=
  -- !benchmark @start precond
  side > 0 ∧
  points.length ≥ 4 ∧
  k ≥ 4 ∧
  k ≤ points.length ∧
  k ≤ 25 ∧
  all_on_boundary side points ∧
  unique_points points
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Sorts a list of natural numbers in descending order. -/
def sort_desc (l : List Nat) : List Nat :=
  l.mergeSort (· ≥ ·)

/-- Binary search to find the maximum feasible distance. -/
def binary_search_max_distance (points : List (Nat × Nat)) (k : Nat) (low : Nat) (high : Nat) [DecidableEq (Nat × Nat)] [∀ (mid : Nat), Decidable (∃ selected ⊆ points, selected.length = k ∧ has_min_distance k selected mid)] : Nat :=
  if low ≥ high then
    high
  else
    let mid := (low + high + 1) / 2
    if ∃ selected ⊆ points, selected.length = k ∧ has_min_distance k selected mid then
      binary_search_max_distance points k mid high
    else
      binary_search_max_distance points k low (mid - 1)

-- Main function definitions
def maximize_minimum_manhattan_distance (side : Nat) (points : List (Nat × Nat)) (k : Nat) (h_precond : maximize_minimum_manhattan_distance_precond side points k) [DecidableEq (Nat × Nat)] [∀ (mid : Nat), Decidable (∃ selected ⊆ points, selected.length = k ∧ has_min_distance k selected mid)] : Nat :=
  -- !benchmark @start code
  let distances := points.flatMap (fun p1 => List.map (manhattan_dist p1) points)
  let sorted_distances := sort_desc distances
  let max_feasible_distance := sorted_distances.head!
  binary_search_max_distance points k 0 max_feasible_distance
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Verifies that result is the maximum achievable minimum distance. -/
def is_maximum_min_distance (side : Nat) (points : List (Nat × Nat)) (k : Nat) (result : Nat) : Prop :=
  -- There exists a selection of k points achieving this distance
  (∃ selected ⊆ points, selected.length = k ∧ has_min_distance k selected result) ∧
  -- No larger distance is achievable
  (∀ d, d > result → ¬ (∃ selected ⊆ points, selected.length = k ∧ has_min_distance k selected d))

-- Postcondition definitions
def maximize_minimum_manhattan_distance_postcond (side : Nat) (points : List (Nat × Nat)) (k : Nat) (result: Nat) (h_precond : maximize_minimum_manhattan_distance_precond side points k) : Prop :=
  -- !benchmark @start postcond
  is_maximum_min_distance side points k result
  -- !benchmark @end postcond


-- Proof content
theorem maximize_minimum_manhattan_distance_postcond_satisfied (side: Nat) (points: List (Nat × Nat)) (k: Nat) (h_precond : maximize_minimum_manhattan_distance_precond side points k) [DecidableEq (Nat × Nat)] [∀ (mid : Nat), Decidable (∃ selected ⊆ points, selected.length = k ∧ has_min_distance k selected mid)] :
    maximize_minimum_manhattan_distance_postcond side points k (maximize_minimum_manhattan_distance side points k h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

instance (points : List (Nat × Nat)) (k : Nat) (mid : Nat) : Decidable (∃ selected ⊆ points, selected.length = k ∧ has_min_distance k selected mid) := by
  sorry