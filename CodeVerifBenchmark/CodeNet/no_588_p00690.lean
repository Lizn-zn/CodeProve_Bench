import Mathlib

namespace no_588_p00690


-- Precondition auxiliary definitions
-- Helper to check if a route is valid
def validRoute (numStations : Nat) (route : Nat × Nat × Nat) : Prop :=
  let (s1, s2, d) := route
  1 ≤ s1 ∧ s1 ≤ numStations ∧
  1 ≤ s2 ∧ s2 ≤ numStations ∧
  s1 ≠ s2 ∧ d ≥ 1

-- Helper to check if all routes are valid
def allRoutesValid (numStations : Nat) (routes : List (Nat × Nat × Nat)) : Prop :=
  ∀ r ∈ routes, validRoute numStations r

-- Helper to check if routes are unique (no duplicate edges)
def uniqueRoutes (routes : List (Nat × Nat × Nat)) : Prop :=
  ∀ i j, i < routes.length → j < routes.length → i ≠ j →
    let (s1i, s2i, _) := routes[i]!
    let (s1j, s2j, _) := routes[j]!
    ¬((s1i = s1j ∧ s2i = s2j) ∨ (s1i = s2j ∧ s2i = s1j))

-- Precondition definitions
@[reducible, simp]
def findLongestRailwayPath_precond (numStations : Nat) (routes : List (Nat × Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  1 ≤ numStations ∧ numStations ≤ 10 ∧
    routes.length ≤ 20 ∧
    allRoutesValid numStations routes ∧
    uniqueRoutes routes
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper to check if two edges are the same (undirected)
def sameEdge (e1 e2 : Nat × Nat × Nat) : Bool :=
  let (s1, s2, _) := e1
  let (t1, t2, _) := e2
  (s1 == t1 && s2 == t2) || (s1 == t2 && s2 == t1)

-- Helper to find edge distance
def findEdgeDist (routes : List (Nat × Nat × Nat)) (v1 v2 : Nat) : Option Nat :=
  routes.find? (fun r => let (s1, s2, _) := r; (s1 == v1 && s2 == v2) || (s1 == v2 && s2 == v1))
    |>.map (fun (_, _, d) => d)

-- Helper to check if edge is used
def edgeUsed (usedEdges : List (Nat × Nat × Nat)) (route : Nat × Nat × Nat) : Bool :=
  usedEdges.any (sameEdge route)

-- DFS to find longest path
partial def dfs (routes : List (Nat × Nat × Nat)) (current : Nat) (path : List Nat) 
    (usedEdges : List (Nat × Nat × Nat)) (currentDist : Nat) : Nat × List Nat :=
  -- Try to extend the path
  let extensions := routes.filter (fun r =>
    let (s1, s2, d) := r
    !edgeUsed usedEdges r && (s1 == current || s2 == current)
  )
  
  if extensions.isEmpty then
    (currentDist, path)
  else
    extensions.foldl (fun best r =>
      let (s1, s2, d) := r
      let next := if s1 == current then s2 else s1
      let newPath := path ++ [next]
      let newUsed := r :: usedEdges
      let newDist := currentDist + d
      let (resDist, resPath) := dfs routes next newPath newUsed newDist
      let (bestDist, bestPath) := best
      if resDist > bestDist then
        (resDist, resPath)
      else if resDist == bestDist then
        -- Choose lexicographically smaller
        if resPath < bestPath then (resDist, resPath) else best
      else
        best
    ) (currentDist, path)

-- Find all possible starting configurations and return the best
def findBestPath (numStations : Nat) (routes : List (Nat × Nat × Nat)) : Nat × List Nat :=
  let allStarts := List.range numStations |>.map (· + 1)
  allStarts.foldl (fun best start =>
    let (bestDist, bestPath) := best
    let (dist, path) := dfs routes start [start] [] 0
    if dist > bestDist then
      (dist, path)
    else if dist == bestDist && path < bestPath then
      (dist, path)
    else
      best
  ) (0, [])

-- Main function definitions
def findLongestRailwayPath (numStations : Nat) (routes : List (Nat × Nat × Nat)) (h_precond : findLongestRailwayPath_precond (numStations) (routes)) : Nat × List Nat :=
  -- !benchmark @start code
  findBestPath numStations routes
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper to check if a path is valid (uses each edge at most once)
def validPath (routes : List (Nat × Nat × Nat)) (path : List Nat) : Prop :=
  path.length ≥ 1 ∧
  (∀ i, i + 1 < path.length →
    ∃ r ∈ routes, let (s1, s2, _) := r
      (s1 = path[i]! ∧ s2 = path[i+1]!) ∨ (s1 = path[i+1]! ∧ s2 = path[i]!)) ∧
  -- Each edge is used at most once
  (∀ i j, i < j → j + 1 < path.length →
    ∃ ri ∈ routes, ∃ rj ∈ routes,
      let (s1i, s2i, _) := ri
      let (s1j, s2j, _) := rj
      ((s1i = path[i]! ∧ s2i = path[i+1]!) ∨ (s1i = path[i+1]! ∧ s2i = path[i]!)) ∧
      ((s1j = path[j]! ∧ s2j = path[j+1]!) ∨ (s1j = path[j+1]! ∧ s2j = path[j]!)) →
      ¬((s1i = s1j ∧ s2i = s2j) ∨ (s1i = s2j ∧ s2i = s1j)))

-- Helper to compute path length
def pathLength (routes : List (Nat × Nat × Nat)) (path : List Nat) : Nat :=
  (List.range (path.length - 1)).foldl (fun acc i =>
    let v1 := path[i]!
    let v2 := path[i+1]!
    match routes.find? (fun r => let (s1, s2, _) := r; (s1 = v1 ∧ s2 = v2) ∨ (s1 = v2 ∧ s2 = v1)) with
    | some (_, _, d) => acc + d
    | none => acc
  ) 0

-- Helper for lexicographic comparison
def lexLess (p1 p2 : List Nat) : Prop :=
  ∃ i, i < p1.length ∧ i < p2.length ∧
    (∀ j, j < i → p1[j]! = p2[j]!) ∧
    p1[i]! < p2[i]!

-- Postcondition definitions
@[reducible, simp]
def findLongestRailwayPath_postcond (numStations : Nat) (routes : List (Nat × Nat × Nat)) (result: Nat × List Nat) (h_precond : findLongestRailwayPath_precond (numStations) (routes)) : Prop :=
  -- !benchmark @start postcond
  let (length, path) := result
  -- The path is valid
  validPath routes path ∧
  -- The computed length matches the actual path length
  length = pathLength routes path ∧
  -- The path is maximal (no other valid path is longer)
  (∀ p, validPath routes p → pathLength routes p ≤ length) ∧
  -- The path is lexicographically smallest among all maximal paths
  (∀ p, validPath routes p → pathLength routes p = length → 
    path = p ∨ lexLess path p)
  -- !benchmark @end postcond


-- Proof content
theorem findLongestRailwayPath_postcond_satisfied (numStations: Nat) (routes: List (Nat × Nat × Nat)) (h_precond : findLongestRailwayPath_precond (numStations) (routes)) :
    findLongestRailwayPath_postcond (numStations) (routes) (findLongestRailwayPath (numStations) (routes) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_588_p00690