import Mathlib

namespace no_852_leetcode_1697


-- Precondition auxiliary definitions
def validNode (n : Nat) (node : Nat) : Prop :=
  node < n

def validEdge (n : Nat) (edge : Nat × Nat × Nat) : Prop :=
  let (u, v, d) := edge
  validNode n u ∧ validNode n v ∧ u ≠ v ∧ d > 0

def validQuery (n : Nat) (query : Nat × Nat × Nat) : Prop :=
  let (p, q, limit) := query
  validNode n p ∧ validNode n q ∧ p ≠ q ∧ limit > 0

-- Precondition definitions
@[reducible, simp]
def distanceLimitedPathsExist_precond (n : Nat) (edgeList : List (Nat × Nat × Nat)) (queries : List (Nat × Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  n ≥ 2 ∧
  List.Forall (validEdge n) edgeList ∧
  List.Forall (validQuery n) queries
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Union-Find data structure to check connectivity under distance constraints
structure UnionFind where
  parent : Nat → Nat
  rank : Nat → Nat

def UnionFind.find (uf : UnionFind) (x : Nat) : Nat :=
  if h : uf.parent x = x then
    x
  else
    let px := uf.parent x
    let root := UnionFind.find { uf with parent := fun y => if y = x then uf.parent px else uf.parent y } px
    root
decreasing_by sorry

def UnionFind.union (uf : UnionFind) (x y : Nat) : UnionFind :=
  let rootX := UnionFind.find uf x
  let rootY := UnionFind.find uf y
  if rootX = rootY then
    uf
  else if uf.rank rootX < uf.rank rootY then
    { uf with parent := fun z => if z = rootX then rootY else uf.parent z }
  else if uf.rank rootX > uf.rank rootY then
    { uf with parent := fun z => if z = rootY then rootX else uf.parent z }
  else
    { uf with
      parent := fun z => if z = rootY then rootX else uf.parent z,
      rank := fun z => if z = rootX then uf.rank z + 1 else uf.rank z }

def processEdges (n : Nat) (edges : List (Nat × Nat × Nat)) : UnionFind :=
  let sortedEdges := edges.mergeSort (fun e1 e2 => match e1, e2 with
    | (_, _, d1), (_, _, d2) => d1 < d2)
  let initialUF : UnionFind := {
    parent := fun i => i,
    rank := fun _ => 0
  }
  sortedEdges.foldl (fun uf edge =>
    let (u, v, _) := edge
    UnionFind.union uf u v) initialUF

def queryAnswer (n : Nat) (edgeList : List (Nat × Nat × Nat)) (query : Nat × Nat × Nat) : Bool :=
  let (p, q, limit) := query
  -- Filter edges with distance < limit
  let validEdges := edgeList.filter (fun (_, _, d) => d < limit)
  let uf := processEdges n validEdges
  UnionFind.find uf p = UnionFind.find uf q

-- Main function definitions
def distanceLimitedPathsExist (n : Nat) (edgeList : List (Nat × Nat × Nat)) (queries : List (Nat × Nat × Nat)) (h_precond : distanceLimitedPathsExist_precond n edgeList queries) : List Bool :=
  -- !benchmark @start code
  queries.map (queryAnswer n edgeList)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def distanceLimitedPathsExist_postcond (n : Nat) (edgeList : List (Nat × Nat × Nat)) (queries : List (Nat × Nat × Nat)) (result: List Bool) (h_precond : distanceLimitedPathsExist_precond n edgeList queries) : Prop :=
  -- !benchmark @start postcond
  result.length = queries.length ∧
  List.Forall₂ (fun query ans => ans = queryAnswer n edgeList query) queries result
  -- !benchmark @end postcond


-- Proof content
theorem distanceLimitedPathsExist_postcond_satisfied (n: Nat) (edgeList: List (Nat × Nat × Nat)) (queries: List (Nat × Nat × Nat)) (h_precond : distanceLimitedPathsExist_precond n edgeList queries) :
    distanceLimitedPathsExist_postcond n edgeList queries (distanceLimitedPathsExist n edgeList queries h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_852_leetcode_1697