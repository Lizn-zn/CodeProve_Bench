import Mathlib

-- Precondition definitions
@[reducible, simp]
def minCompleteGraphVertices_precond (n : Nat) (a : List Nat) : Prop :=
  -- !benchmark @start precond
  n ≥ 1 ∧ n ≤ 5 ∧ a.length = n ∧ (∀ x ∈ a, x ≥ 2)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute the number of edges in a complete graph with k vertices
def numEdges (k : Nat) : Nat := k * (k - 1) / 2

-- Helper function to check if a bit is set
def isBitSet (mask : Nat) (bit : Nat) : Bool := (mask &&& (1 <<< bit)) != 0

-- Helper function to set a bit
def setBit (mask : Nat) (bit : Nat) : Nat := mask ||| (1 <<< bit)

-- Helper function to count bits set in a mask
def countBits (mask : Nat) : Nat :=
  let rec loop (m : Nat) (count : Nat) (fuel : Nat) : Nat :=
    match fuel with
    | 0 => count
    | fuel' + 1 =>
      if m == 0 then count
      else loop (m / 2) (count + m % 2) fuel'
  loop mask 0 32

-- DFS helper that tries all possible selections
partial def dfs (n : Nat) (a : List Nat) (i : Nat) (D : Array Nat) : Nat :=
  if i >= n then
    D.foldl (· + ·) 0
  else
    let n2 := 1 <<< n
    let b := 1 <<< i
    let ai := a[i]!
    
    -- Selection function
    let rec sel (j : Nat) (state : Nat) (u : List Nat) : Nat :=
      if j >= n2 then
        -- Apply the selection
        let D2 := u.foldl (fun D' e => D'.set! e (D'[e]! - 1)) D
        let D3 := u.foldl (fun D' e => D'.set! (e ||| b) (D'[e ||| b]! + 1)) D2
        let D4 := D3.set! b (ai - u.length)
        dfs n a (i + 1) D4
      else
        let r1 := sel (j + 1) state u
        if D[j]! > 0 && (state &&& j) == 0 && u.length < ai then
          let r2 := sel (j + 1) (state ||| j) (j :: u)
          min r1 r2
        else
          r1
    
    sel 0 0 []

-- Main function definitions
def minCompleteGraphVertices (n : Nat) (a : List Nat) (h_precond : minCompleteGraphVertices_precond (n) (a)) : Nat :=
  -- !benchmark @start code
  let n2 := 1 <<< n
    let initialD := Array.mkArray n2 0
    dfs n a 0 initialD
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- A valid coloring assigns each of n colors to a subset of vertices
-- such that the complete subgraphs induced by these subsets have no overlapping edges
def ValidColoring (m : Nat) (n : Nat) (a : List Nat) : Prop :=
  ∃ (subsets : List (List Nat)),
    -- We have n subsets, one for each color
    subsets.length = n ∧
    -- Each subset i has exactly a[i] vertices
    (∀ i : Fin n, (subsets[i.val]!).length = a[i.val]!) ∧
    -- All vertices are in range [0, m)
    (∀ i : Fin n, ∀ v ∈ subsets[i.val]!, v < m) ∧
    -- All vertices in each subset are distinct
    (∀ i : Fin n, (subsets[i.val]!).Nodup) ∧
    -- No two subsets share an edge (i.e., no two vertices appear together in multiple subsets)
    (∀ i j : Fin n, i ≠ j → 
      ∀ u ∈ subsets[i.val]!, ∀ v ∈ subsets[i.val]!, u ≠ v →
        ¬(u ∈ subsets[j.val]! ∧ v ∈ subsets[j.val]!))

-- Postcondition definitions
@[reducible, simp]
def minCompleteGraphVertices_postcond (n : Nat) (a : List Nat) (result: Nat) (h_precond : minCompleteGraphVertices_precond (n) (a)) : Prop :=
  -- !benchmark @start postcond
  -- result is the minimum m such that a valid coloring exists
  ValidColoring result n a ∧ 
  (∀ m' : Nat, m' < result → ¬ValidColoring m' n a)
  -- !benchmark @end postcond


-- Proof content
theorem minCompleteGraphVertices_postcond_satisfied (n: Nat) (a: List Nat) (h_precond : minCompleteGraphVertices_precond (n) (a)) :
    minCompleteGraphVertices_postcond (n) (a) (minCompleteGraphVertices (n) (a) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof