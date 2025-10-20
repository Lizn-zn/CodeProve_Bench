import Mathlib

namespace no_1480_leetcode_2959


-- Precondition auxiliary definitions
def reachable (n : Nat) (roads : List (Nat × Nat × Nat)) : Prop :=
  -- Create adjacency list representation
  let adjList := List.range n |> List.map (fun i => (i, ([] : List (Nat × Nat))))
  let adjListWithEdges := roads.foldl (fun acc (u, v, w) =>
    if u < n ∧ v < n then
      let updateU := (u, (v, w) :: (acc.lookup u |>.getD [])) :: acc.filter (fun (x, _) => x ≠ u)
      let updateV := (v, (u, w) :: (acc.lookup v |>.getD [])) :: updateU.filter (fun (x, _) => x ≠ v)
      updateV ++ acc.filter (fun (x, _) => x ≠ u ∧ x ≠ v)
    else acc
  ) adjList

  -- Check if all nodes are reachable using BFS
  let bfs (start : Nat) (visited : List Nat) : List Nat :=
    let rec bfsHelper (queue : List Nat) (visited : List Nat) : List Nat :=
      match queue with
      | [] => visited
      | node :: rest =>
        let neighbors := adjListWithEdges.lookup node |>.getD []
        let unvisitedNeighbors := neighbors.filter (fun (neighbor, _) => ¬(visited.contains neighbor)) |>.map (Prod.fst)
        bfsHelper (rest ++ unvisitedNeighbors) (visited ++ unvisitedNeighbors)
    decreasing_by sorry
    bfsHelper [start] [start]

  -- Check reachability from node 0
  let reachableNodes := bfs 0 []
  reachableNodes.length = n

-- Floyd-Warshall algorithm implementation for shortest paths
def floydWarshall (n : Nat) (roads : List (Nat × Nat × Nat)) (active : List Nat) : Array (Array Nat) :=
  -- Initialize distance matrix with infinity
  let dist := Array.mk (List.range n |> List.map (fun _ => 
    Array.mk (List.range n |> List.map (fun _ => 1000000))))

  -- Set diagonal to 0
  let dist := List.range n |> List.foldl (fun d i => 
    if active.contains i then d.set! i ((d.get! i).set! i 0) else d) dist

  -- Update with direct edges
  let dist := roads.foldl (fun d (u, v, w) =>
    if active.contains u ∧ active.contains v then
      let currentDist := (d.get! u).get! v
      let newDist := Nat.min currentDist w
      (d.set! u ((d.get! u).set! v newDist)).set! v ((d.get! v).set! u newDist)
    else d
  ) dist

  -- Floyd-Warshall main loop
  List.range n |> List.foldl (fun dist k =>
    if active.contains k then
      List.range n |> List.foldl (fun dist i =>
        if active.contains i then
          List.range n |> List.foldl (fun dist j =>
            if active.contains j then
              let dik := (dist.get! i).get! k
              let dkj := (dist.get! k).get! j
              let dij := (dist.get! i).get! j
              if dik + dkj < dij then
                dist.set! i ((dist.get! i).set! j (dik + dkj))
              else dist
            else dist
          ) dist
        else dist
      ) dist
    else dist
  ) dist

-- Check if all active branches are within maxDistance of each other
def isValidSet (n : Nat) (maxDistance : Nat) (roads : List (Nat × Nat × Nat)) (active : List Nat) : Bool :=
  if active.length ≤ 1 then true
  else
    let distances := floydWarshall n roads active
    active.all (fun i =>
      active.all (fun j =>
        if i = j then true
        else (distances.get! i).get! j ≤ maxDistance
      )
    )

-- Postcondition auxiliary definitions
def countValidSubsets (n : Nat) (maxDistance : Nat) (roads : List (Nat × Nat × Nat)) : Nat :=
  -- Generate all possible subsets of branches to close
  let allSubsets := List.range (2^n) |> List.map (fun mask =>
    List.range n |> List.filter (fun i => ((mask >>> i) &&& 1) = 1)
  )
  
  -- Convert to active branches (not closed)
  let activeSubsets := allSubsets |> List.map (fun closed =>
    List.range n |> List.filter (fun i => ¬(closed.contains i))
  )
  
  -- Count valid subsets
  activeSubsets |> List.filter (isValidSet n maxDistance roads) |> List.length

-- Precondition definitions
@[reducible, simp]
def countValidBranchClosingSets_precond (n : Nat) (maxDistance : Nat) (roads : List (Nat × Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  n ≥ 1 ∧ n ≤ 10 ∧ 
  maxDistance ≥ 1 ∧ maxDistance ≤ 100000 ∧
  roads.length ≤ 1000 ∧
  roads.all (fun (u, v, w) => u < n ∧ v < n ∧ u ≠ v ∧ w ≥ 1 ∧ w ≤ 1000) ∧
  reachable n roads
  -- !benchmark @end precond

-- Main function definitions
def countValidBranchClosingSets (n : Nat) (maxDistance : Nat) (roads : List (Nat × Nat × Nat)) (h_precond : countValidBranchClosingSets_precond n maxDistance roads) : Nat :=
  -- !benchmark @start code
  countValidSubsets n maxDistance roads
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def countValidBranchClosingSets_postcond (n : Nat) (maxDistance : Nat) (roads : List (Nat × Nat × Nat)) (result: Nat) (h_precond : countValidBranchClosingSets_precond n maxDistance roads) : Prop :=
  -- !benchmark @start postcond
  result = countValidSubsets n maxDistance roads
  -- !benchmark @end postcond

-- Proof content
theorem countValidBranchClosingSets_postcond_satisfied (n: Nat) (maxDistance: Nat) (roads: List (Nat × Nat × Nat)) (h_precond : countValidBranchClosingSets_precond n maxDistance roads) :
    countValidBranchClosingSets_postcond n maxDistance roads (countValidBranchClosingSets n maxDistance roads h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1480_leetcode_2959