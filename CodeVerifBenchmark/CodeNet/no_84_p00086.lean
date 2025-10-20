import Mathlib

namespace no_84_p00086


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def checkPatrolRoute_precond (edges : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  -- The input is a list of edges where each edge connects two intersections
    -- Intersection 1 is the start point, intersection 2 is the goal point
    -- All edges should connect valid intersection numbers (positive natural numbers)
    edges.all (fun (a, b) => a > 0 && b > 0)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to count the degree of a single vertex
def countDegree (edges : List (Nat × Nat)) (n : Nat) : Nat :=
  edges.foldl (fun acc (a, b) => 
    acc + (if a = n then 1 else 0) + (if b = n then 1 else 0)) 0

-- Helper function to check if all degrees in range 3-100 are even
def checkOtherDegreesEven (edges : List (Nat × Nat)) : Bool :=
  let rec check (i : Nat) : Bool :=
    if i > 100 then true
    else
      let deg := countDegree edges i
      if deg % 2 = 0 then check (i + 1)
      else false
  termination_by (101 - i)
  decreasing_by sorry
  check 3

-- Main function definitions
def checkPatrolRoute (edges : List (Nat × Nat)) (h_precond : checkPatrolRoute_precond (edges)) : String :=
  -- !benchmark @start code
  let deg1 := countDegree edges 1
    let deg2 := countDegree edges 2
    let otherDegreesEven := checkOtherDegreesEven edges
    
    if deg1 % 2 = 1 && deg2 % 2 = 1 && otherDegreesEven then
      "OK"
    else
      "NG"
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to count the degree of each vertex
def countDegrees (edges : List (Nat × Nat)) : Nat → Nat
  | n => edges.foldl (fun acc (a, b) => 
      acc + (if a = n then 1 else 0) + (if b = n then 1 else 0)) 0

-- Helper function to check if all degrees in a range satisfy a predicate
def allDegreesInRange (edges : List (Nat × Nat)) (start : Nat) (end_ : Nat) (pred : Nat → Bool) : Bool :=
  List.range (end_ - start + 1) |>.all (fun i => pred (countDegrees edges (start + i)))

-- Postcondition definitions
@[reducible, simp]
def checkPatrolRoute_postcond (edges : List (Nat × Nat)) (result: String) (h_precond : checkPatrolRoute_precond (edges)) : Prop :=
  -- !benchmark @start postcond
  -- The result is "OK" if and only if the three samurai honor conditions are met:
    -- 1. The degree of intersection 1 (start) must be odd
    -- 2. The degree of intersection 2 (goal) must be odd  
    -- 3. The degrees of all other intersections (3-100) must be even
    let deg1 := countDegrees edges 1
    let deg2 := countDegrees edges 2
    let otherDegreesEven := allDegreesInRange edges 3 100 (fun d => d % 2 = 0)
    
    result = "OK" ↔ (deg1 % 2 = 1 && deg2 % 2 = 1 && otherDegreesEven = true)
  -- !benchmark @end postcond


-- Proof content
theorem checkPatrolRoute_postcond_satisfied (edges: List (Nat × Nat)) (h_precond : checkPatrolRoute_precond (edges)) :
    checkPatrolRoute_postcond (edges) (checkPatrolRoute (edges) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_84_p00086