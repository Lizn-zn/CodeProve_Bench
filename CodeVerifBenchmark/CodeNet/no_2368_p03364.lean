import Mathlib

namespace no_2368_p03364


-- Precondition definitions
@[reducible, simp]
def countGoodBoards_precond (n : Nat) (grid : List (List Char)) : Prop :=
  -- !benchmark @start precond
  n > 0 ∧ 
    grid.length = n ∧ 
    (∀ row ∈ grid, row.length = n)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to get element from grid with bounds checking
def getGridElement (grid : List (List Char)) (i j : Nat) : Option Char :=
  match grid[i]? with
  | some row => row[j]?
  | none => none

-- Check if a board with shift (a, b) is symmetric
def isSymmetric (n : Nat) (grid : List (List Char)) (a b : Nat) : Bool :=
  List.all (List.range n) fun i =>
    List.all (List.range n) fun j =>
      let row1 := (i + a) % n
      let col1 := (j + b) % n
      let row2 := (j + a) % n
      let col2 := (i + b) % n
      match getGridElement grid row1 col1, getGridElement grid row2 col2 with
      | some c1, some c2 => c1 == c2
      | _, _ => false

-- Main function definitions
def countGoodBoards (n : Nat) (grid : List (List Char)) (h_precond : countGoodBoards_precond (n) (grid)) : Nat :=
  -- !benchmark @start code
  (List.range n).foldl (fun acc a =>
      acc + (List.range n).foldl (fun acc2 b =>
        if isSymmetric n grid a b then acc2 + 1 else acc2
      ) 0
    ) 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if a shifted board is symmetric (good board)
def isGoodBoard (n : Nat) (grid : List (List Char)) (a b : Nat) : Bool :=
  List.all (List.range n) fun i =>
    List.all (List.range n) fun j =>
      let row1 := (i + a) % n
      let col1 := (j + b) % n
      let row2 := (j + a) % n
      let col2 := (i + b) % n
      match grid[row1]?, grid[row2]? with
      | some r1, some r2 =>
        match r1[col1]?, r2[col2]? with
        | some c1, some c2 => c1 == c2
        | _, _ => false
      | _, _ => false

-- Count the number of valid (A, B) pairs
def countValidPairs (n : Nat) (grid : List (List Char)) : Nat :=
  (List.range n).foldl (fun acc a =>
    acc + (List.range n).foldl (fun acc2 b =>
      if isGoodBoard n grid a b then acc2 + 1 else acc2
    ) 0
  ) 0

-- Postcondition definitions
@[reducible, simp]
def countGoodBoards_postcond (n : Nat) (grid : List (List Char)) (result: Nat) (h_precond : countGoodBoards_precond (n) (grid)) : Prop :=
  -- !benchmark @start postcond
  result = countValidPairs n grid
  -- !benchmark @end postcond


-- Proof content
theorem countGoodBoards_postcond_satisfied (n: Nat) (grid: List (List Char)) (h_precond : countGoodBoards_precond (n) (grid)) :
    countGoodBoards_postcond (n) (grid) (countGoodBoards (n) (grid) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2368_p03364