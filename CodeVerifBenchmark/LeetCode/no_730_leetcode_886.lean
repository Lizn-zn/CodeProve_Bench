import Mathlib

-- Precondition auxiliary definitions
/-- A graph is bipartite if its vertices can be colored with two colors such that no two adjacent vertices have the same color. -/
def IsBipartite (n : Nat) (edges : List (Nat × Nat)) : Prop :=
  ∃ (color : Fin n → Bool),
    ∀ (u v : Fin n), (u.val + 1, v.val + 1) ∈ edges → color u ≠ color v

-- Precondition definitions
@[reducible, simp]
def possibleBipartition_precond (n : Nat) (dislikes : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  n > 0 ∧ dislikes ⊆ (List.range n).product (List.range n) ∧
  ∀ d ∈ dislikes, d.1 ≠ d.2 ∧ d.1 > 0 ∧ d.2 > 0 ∧ d.1 ≤ n ∧ d.2 ≤ n
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Converts a list of edges into an adjacency list representation of a graph. -/
def adjacencyList (n : Nat) (edges : List (Nat × Nat)) : Array (Array Nat) :=
  let adj := Array.mkArray n #[]
  let addEdge (adj : Array (Array Nat)) (u v : Nat) : Array (Array Nat) :=
    if u > 0 ∧ u ≤ n ∧ v > 0 ∧ v ≤ n then
      let uIdx := u - 1
      let vIdx := v - 1
      let updatedAdj := adj.set! uIdx ((adj.get! uIdx).push vIdx)
      updatedAdj.set! vIdx ((updatedAdj.get! vIdx).push uIdx)
    else adj
  edges.foldl (fun adj (u, v) => addEdge adj u v) adj

/-- Checks if a graph is bipartite using BFS. -/
def isBipartiteBFS (n : Nat) (adj : Array (Array Nat)) : Bool :=
  let colors := Array.mkArray n Bool.false
  let visited := Array.mkArray n false
  let rec bfs (q : List Nat) (colors : Array Bool) (visited : Array Bool) : Option (Array Bool × Array Bool) :=
    match q with
    | [] => some (colors, visited)
    | u :: q' =>
      let currentColor := colors.get! u
      let neighbors := adj.get! u
      let rec visitNeighbors (idx : Nat) (q' : List Nat) (colors : Array Bool) (visited : Array Bool) : Option (List Nat × Array Bool × Array Bool) :=
        if idx ≥ neighbors.size then
          some (q', colors, visited)
        else
          let v := neighbors.get! idx
          if visited.get! v then
            if colors.get! v = currentColor then
              none -- Not bipartite
            else
              visitNeighbors (idx + 1) q' colors visited
          else
            let newColors := colors.set! v (Bool.not currentColor)
            let newVisited := visited.set! v true
            visitNeighbors (idx + 1) (q' ++ [v]) newColors newVisited
      match visitNeighbors 0 q' colors visited with
      | none => none
      | some (newQ, newColors, newVisited) => 
        bfs newQ newColors newVisited
  decreasing_by
    all_goals sorry
  let rec checkAll (i : Nat) (colors : Array Bool) (visited : Array Bool) : Bool :=
    if i ≥ n then
      true
    else if visited.get! i then
      checkAll (i + 1) colors visited
    else
      match bfs [i] (colors.set! i true) (visited.set! i true) with
      | none => false
      | some (finalColors, finalVisited) => checkAll (i + 1) finalColors finalVisited
  checkAll 0 colors visited

-- Main function definitions
def possibleBipartition (n : Nat) (dislikes : List (Nat × Nat)) (h_precond : possibleBipartition_precond (n) (dislikes)) : Bool :=
  -- !benchmark @start code
  let adj := adjacencyList n dislikes
  isBipartiteBFS n adj
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def possibleBipartition_postcond (n : Nat) (dislikes : List (Nat × Nat)) (result: Bool) (h_precond : possibleBipartition_precond (n) (dislikes)) : Prop :=
  -- !benchmark @start postcond
  result ↔ IsBipartite n dislikes
  -- !benchmark @end postcond


-- Proof content
theorem possibleBipartition_postcond_satisfied (n: Nat) (dislikes: List (Nat × Nat)) (h_precond : possibleBipartition_precond (n) (dislikes)) :
    possibleBipartition_postcond (n) (dislikes) (possibleBipartition (n) (dislikes) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof