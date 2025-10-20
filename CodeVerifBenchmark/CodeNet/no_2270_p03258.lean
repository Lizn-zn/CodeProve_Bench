import Mathlib

namespace no_2270_p03258


-- Precondition definitions
@[reducible, simp]
def countReachableStrings_precond (s : String) : Prop :=
  -- !benchmark @start precond
  s.length ≥ 1 ∧ s.all (fun c => c = 'a' ∨ c = 'b')
  -- !benchmark @end precond


-- Postcondition auxiliary definitions
-- Define a single operation step
def applyOperation (str : String) : List String :=
  let rec replaceAA (i : Nat) (acc : List String) : List String :=
    if i + 1 < str.length then
      let acc' := if str.get ⟨i⟩ = 'a' ∧ str.get ⟨i+1⟩ = 'b' then acc
                  else if str.get ⟨i⟩ = 'a' ∧ str.get ⟨i+1⟩ = 'a' then
                    (str.extract ⟨0⟩ ⟨i⟩ ++ "b" ++ str.extract ⟨i+2⟩ ⟨str.length⟩) :: acc
                  else acc
      replaceAA (i + 1) acc'
    else acc
  let rec replaceBB (i : Nat) (acc : List String) : List String :=
    if i + 1 < str.length then
      let acc' := if str.get ⟨i⟩ = 'b' ∧ str.get ⟨i+1⟩ = 'b' then
                    (str.extract ⟨0⟩ ⟨i⟩ ++ "a" ++ str.extract ⟨i+2⟩ ⟨str.length⟩) :: acc
                  else acc
      replaceBB (i + 1) acc'
    else acc
  replaceAA 0 [] ++ replaceBB 0 []

-- Compute all reachable strings using BFS
partial def computeReachableStrings (initial : String) : Finset String :=
  let rec bfs (queue : List String) (visited : Finset String) : Finset String :=
    match queue with
    | [] => visited
    | current :: rest =>
      let neighbors := applyOperation current
      let newNeighbors := neighbors.filter (fun s => s ∉ visited)
      let newVisited := visited ∪ newNeighbors.toFinset
      let newQueue := rest ++ newNeighbors
      bfs newQueue newVisited
  bfs [initial] {initial}

-- Code auxiliary definitions
-- BFS implementation to find all reachable strings
partial def bfsReachable (initial : String) : Nat :=
  let rec bfs (queue : List String) (visited : Std.HashSet String) (count : Nat) : Nat :=
    match queue with
    | [] => count
    | current :: rest =>
      -- Generate all possible next strings from current
      let neighbors := applyOperation current
      -- Filter out already visited strings
      let (newQueue, newVisited, newCount) := 
        neighbors.foldl (fun (q, v, c) s =>
          if v.contains s then (q, v, c)
          else (s :: q, v.insert s, c + 1)
        ) (rest, visited, count)
      bfs newQueue newVisited newCount
  bfs [initial] (Std.HashSet.empty.insert initial) 1

-- Main function definitions
def countReachableStrings (s : String) (h_precond : countReachableStrings_precond (s)) : Nat :=
  -- !benchmark @start code
  let result := bfsReachable s
  result % 1000000007
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def countReachableStrings_postcond (s : String) (result: Nat) (h_precond : countReachableStrings_precond (s)) : Prop :=
  -- !benchmark @start postcond
  let reachableStrings := computeReachableStrings s
  result = reachableStrings.card % 1000000007
  -- !benchmark @end postcond


-- Proof content
theorem countReachableStrings_postcond_satisfied (s: String) (h_precond : countReachableStrings_precond (s)) :
    countReachableStrings_postcond (s) (countReachableStrings (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2270_p03258