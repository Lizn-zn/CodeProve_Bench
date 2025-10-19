import Mathlib

-- Precondition auxiliary definitions
def adjacencyMap (adjacentPairs : List (Int × Int)) : Std.HashMap Int (List Int) :=
  let addPair (map : Std.HashMap Int (List Int)) (u v : Int) : Std.HashMap Int (List Int) :=
    let map := map.insert u (v :: map.getD u [])
    map.insert v (u :: map.getD v [])
  adjacentPairs.foldl (fun map (u, v) => addPair map u v) Std.HashMap.empty

def isPath (adjacentPairs : List (Int × Int)) (path : List Int) : Prop :=
  let adjMap := adjacencyMap adjacentPairs
  ∀ i : Fin (path.length - 1), (adjMap.getD path[i] []) |> List.elem path[(i : ℕ) + 1]

def hasAllPairs (adjacentPairs : List (Int × Int)) (path : List Int) : Prop :=
  let edgeSet : Std.HashSet (Int × Int) := 
    adjacentPairs.foldl (fun set (u, v) => set.insert (u, v)) Std.HashSet.empty
  ∀ i : Fin (path.length - 1), edgeSet.contains (path[i], path[(i : ℕ) + 1]) ∨ edgeSet.contains (path[(i : ℕ) + 1], path[i])

def countNodesWithDegree (adjacentPairs : List (Int × Int)) (degree : Nat) : Nat :=
  let adjMap := adjacencyMap adjacentPairs
  adjMap.fold (fun count _ neighbors => if List.length neighbors = degree then count + 1 else count) 0

-- !benchmark @end precond_aux

-- Precondition definitions
@[reducible, simp]
def restoreArray_precond (adjacentPairs : List (Int × Int)) : Prop :=
  -- !benchmark @start precond
  adjacentPairs ≠ [] ∧
  let adjMap := adjacencyMap adjacentPairs
  adjMap ≠ Std.HashMap.empty ∧
  -- There are exactly two nodes with degree 1 (the endpoints)
  countNodesWithDegree adjacentPairs 1 = 2 ∧
  -- All other nodes have degree 2
  countNodesWithDegree adjacentPairs 2 = adjMap.size - 2
  
  -- !benchmark @end precond
  -- !benchmark @end precond


-- Code auxiliary definitions
def findStart (adjMap : Std.HashMap Int (List Int)) : Int :=
  adjMap.fold (fun start node neighbors => 
    if List.length neighbors = 1 then node else start) 0

def buildPath (adjMap : Std.HashMap Int (List Int)) (start : Int) (length : Nat) : List Int :=
  let rec loop (current : Int) (prev : Int) (acc : List Int) (remaining : Nat) : List Int :=
    if remaining = 0 then
      acc.reverse
    else
      let neighbors := adjMap.getD current []
      let next := (neighbors.filter (· ≠ prev)).head!
      loop next current (next :: acc) (remaining - 1)
  loop start 0 [start] (length - 1)

-- Main function definitions
def restoreArray (adjacentPairs : List (Int × Int)) (h_precond : restoreArray_precond (adjacentPairs)) : List Int :=
  -- !benchmark @start code
  let adjMap := adjacencyMap adjacentPairs
  let start := findStart adjMap
  buildPath adjMap start (adjacentPairs.length + 1)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- !benchmark @end postcond_aux

-- Postcondition definitions
@[reducible, simp]
def restoreArray_postcond (adjacentPairs : List (Int × Int)) (result: List Int) (h_precond : restoreArray_precond (adjacentPairs)) : Prop :=
  -- !benchmark @start postcond
  result.length = adjacentPairs.length + 1 ∧
  isPath adjacentPairs result ∧
  hasAllPairs adjacentPairs result
  
  -- !benchmark @end postcond
  -- !benchmark @end postcond


-- Proof content
theorem restoreArray_postcond_satisfied (adjacentPairs: List (Int × Int)) (h_precond : restoreArray_precond (adjacentPairs)) :
    restoreArray_postcond (adjacentPairs) (restoreArray (adjacentPairs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof