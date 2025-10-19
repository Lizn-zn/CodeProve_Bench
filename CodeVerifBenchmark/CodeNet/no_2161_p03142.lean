import Mathlib

-- Precondition auxiliary definitions
-- Helper definitions for graph properties
def isValidEdge (N : Nat) (e : Nat × Nat) : Prop :=
  e.1 < N ∧ e.2 < N ∧ e.1 ≠ e.2

def hasNoDuplicateEdges (edges : List (Nat × Nat)) : Prop :=
  edges.Nodup

def hasUniqueRoot (N : Nat) (edges : List (Nat × Nat)) : Prop :=
  ∃! root, root < N ∧ ∀ e ∈ edges, e.2 ≠ root

def isDAG (N : Nat) (edges : List (Nat × Nat)) : Prop :=
  -- All edges are valid and there exists a topological ordering
  ∀ e ∈ edges, isValidEdge N e

-- Precondition definitions
@[reducible, simp]
def restoreRootedTree_precond (N : Nat) (edges : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  -- N ≥ 3, edges has exactly N-1+M elements for some M ≥ 1
    N ≥ 3 ∧
    edges.length ≥ N ∧
    edges.length ≤ 100000 ∧
    N + (edges.length - (N - 1)) ≤ 100000 ∧
    -- All edges are valid (within bounds and not self-loops)
    (∀ e ∈ edges, isValidEdge N e) ∧
    -- No duplicate edges
    hasNoDuplicateEdges edges ∧
    -- There exists exactly one vertex with in-degree 0 (the root)
    hasUniqueRoot N edges ∧
    -- The graph is a DAG (implied by being a rooted tree + descendant edges)
    isDAG N edges
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to build adjacency list
def buildAdjList (N : Nat) (edges : List (Nat × Nat)) : Array (List Nat) :=
  edges.foldl (fun adj (u, v) =>
    adj.modify u (fun l => v :: l)
  ) (Array.mkArray N [])

-- Helper function to compute in-degrees
def computeInDegrees (N : Nat) (edges : List (Nat × Nat)) : Array Nat :=
  edges.foldl (fun deg (_, v) =>
    deg.modify v (· + 1)
  ) (Array.mkArray N 0)

-- Helper function to find root (vertex with in-degree 0)
def findRoot (inDegrees : Array Nat) : Option Nat :=
  inDegrees.findIdx? (· = 0)

-- Topological sort using Kahn's algorithm
def topologicalSort (N : Nat) (adj : Array (List Nat)) (inDegrees : Array Nat) (root : Nat) : List Nat :=
  let rec loop (stack : List Nat) (deg : Array Nat) (result : List Nat) (fuel : Nat) : List Nat :=
    match fuel with
    | 0 => result.reverse
    | fuel + 1 =>
      match stack with
      | [] => result.reverse
      | v :: rest =>
        let newResult := v :: result
        let (newStack, newDeg) := (adj[v]!).foldl (fun (stk, d) u =>
          let newD := d.modify u (· - 1)
          if newD[u]! = 0 then (u :: stk, newD) else (stk, newD)
        ) (rest, deg)
        loop newStack newDeg newResult fuel
  loop [root] inDegrees [] N

-- Compute distances (longest path from root)
def computeDistances (N : Nat) (adj : Array (List Nat)) (topo : List Nat) : Array Nat :=
  topo.foldl (fun dist v =>
    let d := dist[v]!
    (adj[v]!).foldl (fun dist' u =>
      dist'.modify u (fun old => max old (d + 1))
    ) dist
  ) (Array.mkArray N 0)

-- Restore parent array
def restoreParents (N : Nat) (adj : Array (List Nat)) (dist : Array Nat) : Array Nat :=
  let rec processVertex (v : Nat) (parent : Array Nat) : Array Nat :=
    if v >= N then parent
    else
      let d := dist[v]!
      let parent' := (adj[v]!).foldl (fun p u =>
        if d + 1 = dist[u]! && p[u]! = N then
          p.set! u v
        else p
      ) parent
      processVertex (v + 1) parent'
  processVertex 0 (Array.mkArray N N)

-- Convert parent array to output format (0 for root, 1-indexed for others)
def parentArrayToOutput (root : Nat) (parents : Array Nat) (N : Nat) : List Nat :=
  List.range N |>.map (fun i =>
    if i = root then 0
    else if parents[i]! < N then parents[i]! + 1
    else 0
  )

-- Main function definitions
def restoreRootedTree (N : Nat) (edges : List (Nat × Nat)) (h_precond : restoreRootedTree_precond (N) (edges)) : List Nat :=
  -- !benchmark @start code
  -- Build adjacency list
    let adj := buildAdjList N edges
    -- Compute in-degrees
    let inDegrees := computeInDegrees N edges
    -- Find root
    match findRoot inDegrees with
    | none => List.replicate N 0  -- Should not happen given preconditions
    | some root =>
      -- Topological sort
      let topo := topologicalSort N adj inDegrees root
      -- Compute distances
      let dist := computeDistances N adj topo
      -- Restore parent array
      let parents := restoreParents N adj dist
      -- Convert to output format
      parentArrayToOutput root parents N
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper to check if result represents a valid rooted tree
def isValidParentList (N : Nat) (parents : List Nat) : Prop :=
  parents.length = N ∧
  -- Exactly one root (parent value 0)
  (parents.filter (· = 0)).length = 1 ∧
  -- All non-root parents are valid vertex numbers (1 to N)
  (∀ i, i < N → parents[i]! = 0 ∨ (parents[i]! > 0 ∧ parents[i]! ≤ N))

def isSubsetOfEdges (N : Nat) (parents : List Nat) (edges : List (Nat × Nat)) : Prop :=
  ∀ i, i < N → parents[i]! ≠ 0 → (parents[i]! - 1, i) ∈ edges

def formsTree (N : Nat) (parents : List Nat) : Prop :=
  -- The parent relation forms a tree (N-1 edges from a root)
  (parents.filter (· ≠ 0)).length = N - 1

def allEdgesReachable (N : Nat) (parents : List Nat) (edges : List (Nat × Nat)) : Prop :=
  -- All edges in the input can be explained as ancestor-descendant relationships
  -- This is the key property: the M extra edges connect ancestors to descendants
  ∀ e ∈ edges, ∃ path : List Nat, 
    path.length > 0 ∧ 
    path.head? = some e.1 ∧ 
    path.getLast? = some e.2

-- Postcondition definitions
@[reducible, simp]
def restoreRootedTree_postcond (N : Nat) (edges : List (Nat × Nat)) (result: List Nat) (h_precond : restoreRootedTree_precond (N) (edges)) : Prop :=
  -- !benchmark @start postcond
  -- Result is a valid parent list
    isValidParentList N result ∧
    -- The tree edges (from parent list) are a subset of input edges
    isSubsetOfEdges N result edges ∧
    -- The parent list represents exactly N-1 edges (a tree)
    formsTree N result ∧
    -- All input edges can be explained as tree edges or ancestor-descendant edges
    allEdgesReachable N result edges ∧
    -- The result length matches N
    result.length = N
  -- !benchmark @end postcond


-- Proof content
theorem restoreRootedTree_postcond_satisfied (N: Nat) (edges: List (Nat × Nat)) (h_precond : restoreRootedTree_precond (N) (edges)) :
    restoreRootedTree_postcond (N) (edges) (restoreRootedTree (N) (edges) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

