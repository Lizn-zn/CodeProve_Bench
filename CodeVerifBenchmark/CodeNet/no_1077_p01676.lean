import Mathlib

-- Precondition auxiliary definitions
-- Helper function to build adjacency list from edges
def buildGraph (n : Nat) (edges : List (Nat × Nat)) : Array (Array Nat) :=
  let rec addEdge (g : Array (Array Nat)) (e : Nat × Nat) : Array (Array Nat) :=
    match e with
    | (s, t) => 
      let idx := s
      if idx < g.size then
        g.set! idx (t :: g[idx]!.toList).toArray
      else g
  edges.foldl addEdge (Array.mkArray n #[])

-- Helper to check if all nodes are reachable from a given node
def isReachableFrom (g : Array (Array Nat)) (start : Nat) : Array Bool :=
  let rec bfs (queue : List Nat) (visited : Array Bool) (fuel : Nat) : Array Bool :=
    match fuel with
    | 0 => visited
    | fuel' + 1 =>
      match queue with
      | [] => visited
      | v :: rest =>
        if v >= g.size then bfs rest visited fuel'
        else
          let neighbors := g[v]!.toList
          let (newQueue, newVisited) := neighbors.foldl
            (fun (acc : List Nat × Array Bool) w =>
              if w < acc.2.size && !acc.2[w]! then
                (acc.1 ++ [w], acc.2.set! w true)
              else acc)
            (rest, visited)
          bfs newQueue newVisited fuel'
  bfs [start] ((Array.mkArray g.size false).set! start true) (g.size * g.size)

-- Precondition definitions
@[reducible, simp]
def treeReconstruction_precond (n : Nat) (edges : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  -- n is positive
    n > 0 ∧
    -- All edges are valid (nodes are in range [0, n))
    edges.all (fun e => e.1 < n ∧ e.2 < n) ∧
    -- No self-loops
    edges.all (fun e => e.1 ≠ e.2) ∧
    -- No duplicate edges
    edges.Nodup
  -- !benchmark @end precond


-- Code auxiliary definitions
-- BFS implementation to find connected components
def bfsComponent (g : Array (Array Nat)) (start : Nat) (visited : Array Bool) : Array Bool :=
  let rec bfs (queue : List Nat) (vis : Array Bool) (fuel : Nat) : Array Bool :=
    match fuel with
    | 0 => vis
    | fuel' + 1 =>
      match queue with
      | [] => vis
      | v :: rest =>
        if v >= g.size then bfs rest vis fuel'
        else
          let neighbors := g[v]!.toList
          let (newQueue, newVis) := neighbors.foldl
            (fun (acc : List Nat × Array Bool) w =>
              if w < acc.2.size && !acc.2[w]! then
                (acc.1 ++ [w], acc.2.set! w true)
              else acc)
            (rest, vis)
          bfs newQueue newVis fuel'
  if start >= visited.size then visited
  else bfs [start] (visited.set! start true) (g.size * g.size)

-- Build adjacency list as Array of Arrays for better performance
def buildGraphArray (n : Nat) (edges : List (Nat × Nat)) : Array (Array Nat) :=
  let rec addEdge (g : Array (Array Nat)) (e : Nat × Nat) : Array (Array Nat) :=
    match e with
    | (s, t) => 
      if s < g.size then
        g.set! s ((g[s]!).push t)
      else g
  edges.foldl addEdge (Array.mkArray n #[])

-- Main function definitions
def treeReconstruction (n : Nat) (edges : List (Nat × Nat)) (h_precond : treeReconstruction_precond (n) (edges)) : Nat :=
  -- !benchmark @start code
  -- Build adjacency list
    let g := buildGraphArray n edges
    
    -- Find all connected components using BFS
    let rec findComponents (idx : Nat) (visited : Array Bool) (acc : Nat) : Nat :=
      if idx >= n then acc
      else if visited[idx]! then findComponents (idx + 1) visited acc
      else
        let newVisited := bfsComponent g idx visited
        findComponents (idx + 1) newVisited (acc + 1)
    
    let numComponents := findComponents 0 (Array.mkArray n false) 0
    
    -- Calculate answer: for each node, we need (out_degree - 1) edges, plus 1 per component
    -- This equals: sum of (out_degree - 1) + num_components = total_edges - n + num_components
    let totalEdges := edges.length
    let answer := totalEdges - n + numComponents
    
    answer
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Count number of connected components using BFS
def countComponents (g : Array (Array Nat)) : Nat :=
  let rec helper (visited : Array Bool) (idx : Nat) (count : Nat) : Nat :=
    if idx >= g.size then count
    else if visited[idx]! then helper visited (idx + 1) count
    else
      let reachable := isReachableFrom g idx
      let newVisited := List.range g.size |>.foldl
        (fun acc i => if reachable[i]! then acc.set! i true else acc)
        visited
      helper newVisited (idx + 1) (count + 1)
  helper (Array.mkArray g.size false) 0 0

-- Calculate the minimum number of edges needed
def minEdgesNeeded (n : Nat) (edges : List (Nat × Nat)) : Nat :=
  let g := buildGraph n edges
  let components := countComponents g
  -- For each component, we need (number of nodes in component - 1) + 1 edges
  -- This simplifies to: total_edges - (nodes_with_edges - components)
  let nodesWithEdges := List.range n |>.filter (fun i => 
    (g[i]!.size > 0) || edges.any (fun e => e.2 = i))
  edges.length - (nodesWithEdges.length - components)

-- Postcondition definitions
@[reducible, simp]
def treeReconstruction_postcond (n : Nat) (edges : List (Nat × Nat)) (result: Nat) (h_precond : treeReconstruction_precond (n) (edges)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the minimum number of edges that need to be kept
    -- to recover all edge values using flow conservation
    result = minEdgesNeeded n edges ∧
    -- The result should not exceed the total number of edges
    result ≤ edges.length
  -- !benchmark @end postcond


-- Proof content
theorem treeReconstruction_postcond_satisfied (n: Nat) (edges: List (Nat × Nat)) (h_precond : treeReconstruction_precond (n) (edges)) :
    treeReconstruction_postcond (n) (edges) (treeReconstruction (n) (edges) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof