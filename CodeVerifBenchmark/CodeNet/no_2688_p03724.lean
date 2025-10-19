import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def canFormTree_precond (n : Nat) (m : Nat) (queries : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  n ≥ 2 ∧ m ≥ 1 ∧ 
    queries.length = m ∧
    (∀ (q : Nat × Nat), q ∈ queries → 
      1 ≤ q.1 ∧ q.1 ≤ n ∧ 
      1 ≤ q.2 ∧ q.2 ≤ n ∧ 
      q.1 ≠ q.2)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to count occurrences of a vertex in queries
def countOccurrences (v : Nat) (queries : List (Nat × Nat)) : Nat :=
  queries.foldl (fun acc q => 
    acc + (if q.1 = v then 1 else 0) + (if q.2 = v then 1 else 0)) 0

-- Helper function to get all unique vertices from queries
def getVertices (queries : List (Nat × Nat)) : List Nat :=
  let rec aux (qs : List (Nat × Nat)) (acc : List Nat) : List Nat :=
    match qs with
    | [] => acc
    | (a, b) :: rest => 
      let acc' := if acc.contains a then acc else a :: acc
      let acc'' := if acc'.contains b then acc' else b :: acc'
      aux rest acc''
  aux queries []

-- Main function definitions
def canFormTree (n : Nat) (m : Nat) (queries : List (Nat × Nat)) (h_precond : canFormTree_precond (n) (m) (queries)) : Bool :=
  -- !benchmark @start code
  -- Get all vertices that appear in queries
    let vertices := getVertices queries
    -- Check if all vertices have even degree
    vertices.all (fun v => countOccurrences v queries % 2 = 0)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Count how many times a vertex appears in the queries
def countVertexOccurrences (v : Nat) (queries : List (Nat × Nat)) : Nat :=
  queries.foldl (fun acc q => 
    acc + (if q.1 = v then 1 else 0) + (if q.2 = v then 1 else 0)) 0

-- Check if all vertices that appear in queries have even degree
def allVerticesHaveEvenDegree (queries : List (Nat × Nat)) : Bool :=
  let vertices := queries.foldl (fun acc q => acc.insert q.1 |>.insert q.2) (∅ : Std.HashSet Nat)
  vertices.all (fun v => countVertexOccurrences v queries % 2 = 0)

-- Postcondition definitions
@[reducible, simp]
def canFormTree_postcond (n : Nat) (m : Nat) (queries : List (Nat × Nat)) (result: Bool) (h_precond : canFormTree_precond (n) (m) (queries)) : Prop :=
  -- !benchmark @start postcond
  -- The result is YES (true) if and only if every vertex that appears in the queries
  -- has an even degree (appears an even number of times across all queries).
  -- This is because in a tree, each edge on a path from a to b is traversed exactly once.
  -- For all edge weights to be even after all queries, each vertex must be an endpoint
  -- of an even number of paths.
  result = allVerticesHaveEvenDegree queries
  -- !benchmark @end postcond


-- Proof content
theorem canFormTree_postcond_satisfied (n: Nat) (m: Nat) (queries: List (Nat × Nat)) (h_precond : canFormTree_precond (n) (m) (queries)) :
    canFormTree_postcond (n) (m) (queries) (canFormTree (n) (m) (queries) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

