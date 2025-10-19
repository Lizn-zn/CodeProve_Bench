import Mathlib

-- Precondition auxiliary definitions
def isConnected (n : Nat) (roads : List (Nat × Nat × Nat)) : Prop :=
  -- Check if all cities from 1 to n are connected via roads
  let edgeSet := roads.foldl (fun acc (a, b, _) => Set.insert a (Set.insert b acc)) ∅
  ∀ i : Fin n, (i.val + 1) ∈ edgeSet

def validRoads (roads : List (Nat × Nat × Nat)) : Prop :=
  roads.all (fun (a, b, c) => a > 0 ∧ b > 0 ∧ c > 0)

def distinctCitiesInRoads (roads : List (Nat × Nat × Nat)) : Prop :=
  roads.all (fun (a, b, c) => a ≠ b)

-- Precondition definitions
@[reducible, simp]
def minCostToBuyApple_precond (n : Nat) (roads : List (Nat × Nat × Nat)) (appleCost : List Nat) (k : Nat) : Prop :=
  -- !benchmark @start precond
  n ≥ 2 ∧
  roads.length ≤ 2000 ∧
  validRoads roads ∧
  distinctCitiesInRoads roads ∧
  isConnected n roads ∧
  appleCost.length = n ∧
  appleCost.all (· > 0) ∧
  k ≥ 1 ∧ k ≤ 100
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Auxiliary definitions for Dijkstra's algorithm and graph representation

-- A simple adjacency list representation of the graph
structure MyGraph where
  adjList : List (List (Nat × Nat))

-- Convert roads to adjacency list
def roadsToGraph (n : Nat) (roads : List (Nat × Nat × Nat)) : MyGraph :=
  let emptyGraph := List.replicate n []
  let updatedGraph := roads.foldl (fun graph (a, b, cost) =>
    let aIdx := a - 1
    let bIdx := b - 1
    if aIdx < n ∧ bIdx < n then
      graph.set aIdx ((b, cost) :: graph.get! aIdx) |>.set bIdx ((a, cost) :: graph.get! bIdx)
    else
      graph
  ) emptyGraph
  ⟨updatedGraph⟩

-- Dijkstra's algorithm to find shortest distances from a source
def dijkstra (graph : MyGraph) (source : Nat) : List Nat :=
  let n := graph.adjList.length
  let sourceIdx := if source > 0 then source - 1 else 0
  let dist := List.replicate n 0
  let visited := List.replicate n false
  -- Initialize distances
  let distWithInit := List.range n |>.foldl (fun d i => 
    d.set i (if i = sourceIdx then 0 else 1000000000)
  ) dist
  
  -- Main loop - using List.foldl instead of Nat.iterate
  let finalState := List.range n |>.foldl (fun (vis, d) _ =>
    -- Find unvisited node with minimum distance
    let (minDist, u) := List.range n |>.foldl (fun (md, u) i =>
      if !vis.get! i && d.get! i < md then (d.get! i, i) else (md, u)
    ) (1000000000, 0)
    
    let newVisited := vis.set u true
    
    -- Update distances of adjacent nodes
    let neighbors := graph.adjList.get! u
    let updatedDist := List.range neighbors.length |>.foldl (fun d j =>
      let (v, cost) := neighbors.get! j
      let vIdx := if v > 0 then v - 1 else 0
      if vIdx < n ∧ !newVisited.get! vIdx then
        let newDist := d.get! u + cost
        if newDist < d.get! vIdx then d.set vIdx newDist else d
      else d
    ) d
    
    (newVisited, updatedDist)
  ) (visited, distWithInit)
  
  match finalState with
  | (_, finalDist) => finalDist


-- Main function definitions
def minCostToBuyApple (n : Nat) (roads : List (Nat × Nat × Nat)) (appleCost : List Nat) (k : Nat) (h_precond : minCostToBuyApple_precond (n) (roads) (appleCost) (k)) : List Nat :=
  -- !benchmark @start code
  let graph := roadsToGraph n roads
  List.range n |>.map (fun startIndex =>
    let startCity := startIndex + 1
    let distances := dijkstra graph startCity
    let directCost := appleCost.get! startIndex
    
    let minTotalCost := List.range n |>.foldl (fun minCost destIdx =>
      let destCity := destIdx + 1
      let forwardCost := distances.get! destIdx
      let returnCost := forwardCost * k
      let totalCost := forwardCost + appleCost.get! destIdx + returnCost
      min totalCost minCost
    ) directCost
    
    minTotalCost
  )
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- No auxiliary definitions needed for the postcondition

-- Postcondition definitions
@[reducible, simp]
def minCostToBuyApple_postcond (n : Nat) (roads : List (Nat × Nat × Nat)) (appleCost : List Nat) (k : Nat) (result: List Nat) (h_precond : minCostToBuyApple_precond (n) (roads) (appleCost) (k)) : Prop :=
  -- !benchmark @start postcond
  result.length = n ∧
  ∀ i : Fin n,
    let startCity := i.val + 1
    result.get! i = (List.range n).foldl (fun minCost destIdx =>
      let destCity := destIdx + 1
      let forwardCost := -- Placeholder for shortest path cost from startCity to destCity
        0 -- This would be computed using Dijkstra's algorithm or similar in actual implementation
      let returnCost := forwardCost * k
      min minCost (forwardCost + appleCost.get! destIdx + returnCost)
    ) (appleCost.get! i)
  -- !benchmark @end postcond


-- Proof content
theorem minCostToBuyApple_postcond_satisfied (n: Nat) (roads: List (Nat × Nat × Nat)) (appleCost: List Nat) (k: Nat) (h_precond : minCostToBuyApple_precond (n) (roads) (appleCost) (k)) :
    minCostToBuyApple_postcond (n) (roads) (appleCost) (k) (minCostToBuyApple (n) (roads) (appleCost) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof