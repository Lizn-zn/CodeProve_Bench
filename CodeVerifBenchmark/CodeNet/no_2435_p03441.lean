import Mathlib

-- Precondition auxiliary definitions
-- Helper to check if a list of edges forms a valid tree
def isValidTree (n : Nat) (edges : List (Nat × Nat)) : Prop :=
  edges.length = n - 1 ∧ 
  (∀ edge ∈ edges, edge.1 < n ∧ edge.2 < n)

-- Helper to compute distance between vertices in a tree
def treeDistance (n : Nat) (edges : List (Nat × Nat)) (u v : Nat) : Nat :=
  sorry -- Distance computation in tree

-- Helper to check if all distance vectors are distinct
def allDistanceVectorsDistinct (n : Nat) (edges : List (Nat × Nat)) (antennas : List Nat) : Prop :=
  ∀ u v : Nat, u < n → v < n → u ≠ v →
    ∃ k ∈ antennas, treeDistance n edges k u ≠ treeDistance n edges k v

-- Helper to check if K antennas suffice
def kAntennasSuffice (n : Nat) (edges : List (Nat × Nat)) (k : Nat) : Prop :=
  ∃ antennas : List Nat, 
    antennas.length = k ∧ 
    (∀ x ∈ antennas, x < n) ∧
    antennas.Nodup ∧
    allDistanceVectorsDistinct n edges antennas

-- Precondition definitions
@[reducible, simp]
def minAntennas_precond (n : Nat) (edges : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  n ≥ 2 ∧ isValidTree n edges
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Build adjacency list from edges
def buildGraph (n : Nat) (edges : List (Nat × Nat)) : Array (List Nat) :=
  edges.foldl (fun g edge =>
    let a := edge.1
    let b := edge.2
    let g := g.modify a (fun l => b :: l)
    g.modify b (fun l => a :: l)
  ) (Array.mkArray n [])

-- Find a vertex with degree > 2, or return none if all vertices have degree ≤ 2
def findBranchVertex (n : Nat) (edges : List (Nat × Nat)) : Option Nat :=
  let graph := buildGraph n edges
  (List.range n).find? (fun v => (graph.get! v).length > 2)

-- DFS to count the minimum antennas needed
partial def countAntennas (graph : Array (List Nat)) (visited : Array Bool) (x : Nat) : Nat :=
  let neighbors := graph.get! x
  let unvisitedNeighbors := neighbors.filter (fun v => !(visited.get! v))
  
  let (totalAntennas, leafCount) := unvisitedNeighbors.foldl (fun (acc_total, acc_leaves) v =>
    let newVisited := visited.set! v true
    let subtreeAntennas := countAntennas graph newVisited v
    let isLeaf := if subtreeAntennas == 0 then 1 else 0
    (acc_total + subtreeAntennas, acc_leaves + isLeaf)
  ) (0, 0)
  
  if leafCount > 1 then
    totalAntennas + (leafCount - 1)
  else
    totalAntennas

-- Main function definitions
def minAntennas (n : Nat) (edges : List (Nat × Nat)) (h_precond : minAntennas_precond (n) (edges)) : Nat :=
  -- !benchmark @start code
  match findBranchVertex n edges with
    | none => 1  -- Path graph or single edge
    | some root =>
      let graph := buildGraph n edges
      let visited := (Array.mkArray n false).set! root true
      countAntennas graph visited root
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper to check if result is minimum
def isMinimumAntennas (n : Nat) (edges : List (Nat × Nat)) (k : Nat) : Prop :=
  kAntennasSuffice n edges k ∧ 
  (∀ k' : Nat, k' < k → ¬kAntennasSuffice n edges k')

-- Postcondition definitions
@[reducible, simp]
def minAntennas_postcond (n : Nat) (edges : List (Nat × Nat)) (result: Nat) (h_precond : minAntennas_precond (n) (edges)) : Prop :=
  -- !benchmark @start postcond
  1 ≤ result ∧ 
    result ≤ n ∧ 
    isMinimumAntennas n edges result
  -- !benchmark @end postcond


-- Proof content
theorem minAntennas_postcond_satisfied (n: Nat) (edges: List (Nat × Nat)) (h_precond : minAntennas_precond (n) (edges)) :
    minAntennas_postcond (n) (edges) (minAntennas (n) (edges) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof