import Mathlib

namespace no_1513_p02378


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def bipartiteMatching_precond (numX : Nat) (numY : Nat) (edges : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  -- All edges must be valid (vertices within bounds)
    ∀ (e : Nat × Nat), e ∈ edges → e.1 < numX ∧ e.2 < numY
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Maximum flow implementation using Dinic's algorithm
structure Edge where
  dst : Nat
  cap : Nat
  rev : Nat
deriving Repr, BEq, Inhabited

structure MaxFlow where
  nodeSize : Nat
  graph : Array (Array Edge)
  level : Array Int
  iter : Array Nat

def MaxFlow.init (n : Nat) : MaxFlow :=
  { nodeSize := n
    graph := Array.mkArray n (Array.mkArray 0 default)
    level := Array.mkArray n (-1)
    iter := Array.mkArray n 0 }

def MaxFlow.addEdge (mf : MaxFlow) (src dst cap : Nat) : MaxFlow :=
  if h1 : src < mf.nodeSize then
    if h2 : dst < mf.nodeSize then
      let revIdx := mf.graph[dst]!.size
      let fwdIdx := mf.graph[src]!.size
      let newGraph := mf.graph
        |>.modify src (fun arr => arr.push { dst := dst, cap := cap, rev := revIdx })
        |>.modify dst (fun arr => arr.push { dst := src, cap := 0, rev := fwdIdx })
      { mf with graph := newGraph }
    else mf
  else mf

partial def MaxFlow.bfs (mf : MaxFlow) (start : Nat) : MaxFlow :=
  let newLevel := Array.mkArray mf.nodeSize (-1)
  let queue := Array.mkArray 1 start
  let newLevel := newLevel.set! start 0
  let rec loop (mf : MaxFlow) (queue : Array Nat) (qStart qEnd : Nat) (level : Array Int) : Array Int :=
    if qStart >= qEnd then level
    else
      let cur := queue[qStart]!
      let edges := mf.graph[cur]!
      let rec processEdges (i : Nat) (queue : Array Nat) (qEnd : Nat) (level : Array Int) : Array Nat × Nat × Array Int :=
        if i >= edges.size then (queue, qEnd, level)
        else
          let e := edges[i]!
          if level[e.dst]! < 0 && e.cap > 0 then
            let newLevel := level.set! e.dst (level[cur]! + 1)
            let newQueue := if qEnd < queue.size then queue.set! qEnd e.dst else queue.push e.dst
            processEdges (i + 1) newQueue (qEnd + 1) newLevel
          else
            processEdges (i + 1) queue qEnd level
      let (newQueue, newQEnd, newLevel) := processEdges 0 queue qEnd level
      loop mf newQueue (qStart + 1) newQEnd newLevel
  let finalLevel := loop mf queue 0 1 newLevel
  { mf with level := finalLevel }

partial def MaxFlow.dfs (mf : MaxFlow) (cur end_ flow : Nat) : Nat × MaxFlow :=
  if cur == end_ then (flow, mf)
  else
    let edges := mf.graph[cur]!
    let rec tryEdges (i : Nat) (mf : MaxFlow) : Nat × MaxFlow :=
      if i >= edges.size then (0, mf)
      else
        let e := edges[i]!
        if e.cap > 0 && mf.level[cur]! < mf.level[e.dst]! then
          let (flowed, mf') := mf.dfs e.dst end_ (min flow e.cap)
          if flowed > 0 then
            let newGraph := mf'.graph
              |>.modify cur (fun arr => arr.modify i (fun edge => { edge with cap := edge.cap - flowed }))
              |>.modify e.dst (fun arr => arr.modify e.rev (fun edge => { edge with cap := edge.cap + flowed }))
            (flowed, { mf' with graph := newGraph })
          else
            tryEdges (i + 1) mf'
        else
          tryEdges (i + 1) mf
    tryEdges mf.iter[cur]! mf

partial def MaxFlow.solve (mf : MaxFlow) (source sink : Nat) : Nat :=
  let rec loop (mf : MaxFlow) (totalFlow : Nat) : Nat :=
    let mf' := mf.bfs source
    if mf'.level[sink]! < 0 then totalFlow
    else
      let mf'' := { mf' with iter := Array.mkArray mf.nodeSize 0 }
      let rec innerLoop (mf : MaxFlow) (flow : Nat) : Nat :=
        let (f, mf') := mf.dfs source sink (mf.nodeSize * mf.nodeSize)
        if f == 0 then flow
        else innerLoop mf' (flow + f)
      let newFlow := innerLoop mf'' totalFlow
      loop mf'' newFlow
  loop mf 0

-- Bipartite matching using max flow
def solveBipartiteMatching (numX numY : Nat) (edges : List (Nat × Nat)) : Nat :=
  let n := numX + numY + 2
  let source := 0
  let sink := numX + numY + 1
  let mf := MaxFlow.init n
  -- Add edges from source to X vertices
  let mf := (List.range numX).foldl (fun mf i => mf.addEdge source (i + 1) 1) mf
  -- Add edges from Y vertices to sink
  let mf := (List.range numY).foldl (fun mf i => mf.addEdge (numX + i + 1) sink 1) mf
  -- Add bipartite edges
  let mf := edges.foldl (fun mf e => mf.addEdge (e.1 + 1) (e.2 + numX + 1) 1) mf
  mf.solve source sink

-- Main function definitions
def bipartiteMatching (numX : Nat) (numY : Nat) (edges : List (Nat × Nat)) (h_precond : bipartiteMatching_precond (numX) (numY) (edges)) : Nat :=
  -- !benchmark @start code
  solveBipartiteMatching numX numY edges
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- A matching is a subset of edges where no vertex appears more than once
def isMatching (edges : List (Nat × Nat)) (matching : List (Nat × Nat)) : Prop :=
  -- All edges in matching are from the original edge set
  (∀ e, e ∈ matching → e ∈ edges) ∧
  -- No vertex from X appears more than once
  (∀ i j, i < matching.length → j < matching.length → i ≠ j → 
    matching[i]!.1 ≠ matching[j]!.1) ∧
  -- No vertex from Y appears more than once
  (∀ i j, i < matching.length → j < matching.length → i ≠ j → 
    matching[i]!.2 ≠ matching[j]!.2)

-- Maximum matching size is the largest size among all valid matchings
def isMaxMatching (edges : List (Nat × Nat)) (size : Nat) : Prop :=
  -- There exists a matching of this size
  (∃ (matching : List (Nat × Nat)), isMatching edges matching ∧ matching.length = size) ∧
  -- No matching can be larger
  (∀ (matching : List (Nat × Nat)), isMatching edges matching → matching.length ≤ size)

-- Postcondition definitions
@[reducible, simp]
def bipartiteMatching_postcond (numX : Nat) (numY : Nat) (edges : List (Nat × Nat)) (result: Nat) (h_precond : bipartiteMatching_precond (numX) (numY) (edges)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the size of a maximum matching in the bipartite graph
    isMaxMatching edges result
  -- !benchmark @end postcond


-- Proof content
theorem bipartiteMatching_postcond_satisfied (numX: Nat) (numY: Nat) (edges: List (Nat × Nat)) (h_precond : bipartiteMatching_precond (numX) (numY) (edges)) :
    bipartiteMatching_postcond (numX) (numY) (edges) (bipartiteMatching (numX) (numY) (edges) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1513_p02378