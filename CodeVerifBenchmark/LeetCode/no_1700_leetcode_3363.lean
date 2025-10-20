import Mathlib

namespace no_1700_leetcode_3363


-- Precondition auxiliary definitions
def isValidFruitsGrid (fruits : List (List Nat)) : Prop :=
  let n := fruits.length
  n ≥ 2 ∧
  fruits.all (fun row => row.length = n) ∧
  fruits.all (fun row => row.all (fun fruit => fruit ≤ 1000))

-- Precondition definitions
@[reducible, simp]
def maxFruitsInDungeon_precond (fruits : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  isValidFruitsGrid fruits
  -- !benchmark @end precond

-- A position in the grid
structure Position where
  row : Nat
  col : Nat
deriving DecidableEq, Repr

-- A state in the DP: positions of the three children
structure State where
  pos1 : Position  -- Child starting from (0,0)
  pos2 : Position  -- Child starting from (0,n-1)
  pos3 : Position  -- Child starting from (n-1,0)
deriving DecidableEq, Repr

instance : Hashable Position where
  hash p := Hashable.hash (p.row, p.col)

instance : Hashable State where
  hash s := Hashable.hash (s.pos1, s.pos2, s.pos3)

-- Check if a position is within bounds
def inBounds (pos : Position) (n : Nat) : Bool :=
  pos.row < n ∧ pos.col < n

-- Get possible moves for child 1 (from top-left): can move right, down, or diagonally down-right
def getPossibleMoves1 (pos : Position) (n : Nat) : List Position :=
  let i := pos.row
  let j := pos.col
  let candidates := [
    { row := i+1, col := j },      -- down
    { row := i, col := j+1 },      -- right
    { row := i+1, col := j+1 }     -- diagonal down-right
  ]
  candidates.filter (fun p => inBounds p n)

-- Get possible moves for child 2 (from top-right): can move down, left, or diagonally down-left
def getPossibleMoves2 (pos : Position) (n : Nat) : List Position :=
  let i := pos.row
  let j := pos.col
  let candidates := [
    { row := i+1, col := j },      -- down
    { row := if j > 0 then i+1 else i, col := if j > 0 then j-1 else j },  -- avoid invalid subtraction
    { row := i+1, col := j+1 }     -- diagonal down-right
  ]
  candidates.filter (fun p => inBounds p n ∧ (j = 0 → p.col ≠ j-1) ∧ (j > 0 → p.col < n))  -- correct condition logic

-- Get possible moves for child 3 (from bottom-left): can move right, up, or diagonally up-right
def getPossibleMoves3 (pos : Position) (n : Nat) : List Position :=
  let i := pos.row
  let j := pos.col
  let candidates := [
    { row := i, col := j+1 },      -- right
    { row := if i > 0 then i-1 else i, col := j+1 },  -- avoid invalid subtraction
    { row := i+1, col := j+1 }     -- diagonal down-right
  ]
  candidates.filter (fun p => inBounds p n ∧ (i = 0 → p.row ≠ i-1) ∧ (i > 0 → p.row < n))  -- correct condition logic

-- Collect fruits from a set of positions (avoiding double counting)
def collectFruits (fruits : List (List Nat)) (positions : List Position) : Nat :=
  let uniquePositions := positions.eraseDups
  uniquePositions.foldl (fun acc pos =>
    if pos.row < fruits.length ∧ pos.col < (fruits.get! pos.row).length then
      acc + (fruits.get! pos.row |>.get! pos.col)
    else
      acc
  ) 0

-- Memoization table type using HashMap
abbrev MemoKey := State
abbrev MemoValue := Nat
abbrev MemoTable := Std.HashMap MemoKey MemoValue

-- Helper function to find key in HashMap
def HashMap.find? {α β : Type} [BEq α] [Hashable α] (map : Std.HashMap α β) (key : α) : Option β :=
  match map.findEntry? key with
  | .some (_, v) => .some v
  | .none => .none

-- The dynamic programming function to compute maximum fruits
partial def maxFruitsDP (fruits : List (List Nat)) (memo : MemoTable) (state : State) : (Nat × MemoTable) :=
  let n := fruits.length
  
  -- Check if we've already computed this state
  match HashMap.find? memo state with
  | some value => (value, memo)
  | none =>
    let pos1 := state.pos1
    let pos2 := state.pos2
    let pos3 := state.pos3
    
    -- Base case: if all children have reached the destination (n-1, n-1)
    if pos1.row = n - 1 ∧ pos1.col = n - 1 ∧ 
       pos2.row = n - 1 ∧ pos2.col = n - 1 ∧ 
       pos3.row = n - 1 ∧ pos3.col = n - 1 then
      let collected := collectFruits fruits [pos1, pos2, pos3]
      let newMemo := memo.insert state collected
      (collected, newMemo)
    else
      -- Get possible moves for each child
      let moves1 := getPossibleMoves1 pos1 n
      let moves2 := getPossibleMoves2 pos2 n
      let moves3 := getPossibleMoves3 pos3 n
      
      -- Try all combinations of moves
      let combinations := moves1.flatMap (fun m1 =>
        moves2.flatMap (fun m2 =>
          moves3.map (fun m3 => (m1, m2, m3))
        )
      )
      
      let result := combinations.foldl (fun best (m1, m2, m3) =>
        let newState := { pos1 := m1, pos2 := m2, pos3 := m3 }
        let (value, _) := maxFruitsDP fruits memo newState
        let collected := collectFruits fruits [m1, m2, m3]
        let total := collected + value
        Nat.max best total
      ) 0
      
      let newMemo := memo.insert state result
      (result, newMemo)

-- Compute the maximum fruits by calling the DP with initial state
def computeMaxFruits (fruits : List (List Nat)) : Nat :=
  let n := fruits.length
  let initialState := {
    pos1 := { row := 0, col := 0 },
    pos2 := { row := 0, col := n-1 },
    pos3 := { row := n-1, col := 0 }
  }
  let initialMemo : MemoTable := Std.HashMap.empty
  let (result, _) := maxFruitsDP fruits initialMemo initialState
  result

-- Main function definitions
def maxFruitsInDungeon (fruits : List (List Nat)) (h_precond : maxFruitsInDungeon_precond (fruits)) : Nat :=
  -- !benchmark @start code
  computeMaxFruits fruits
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def maxFruitsInDungeon_postcond (fruits : List (List Nat)) (result: Nat) (h_precond : maxFruitsInDungeon_precond (fruits)) : Prop :=
  -- !benchmark @start postcond
  result = computeMaxFruits fruits
  -- !benchmark @end postcond

-- Proof content
theorem maxFruitsInDungeon_postcond_satisfied (fruits: List (List Nat)) (h_precond : maxFruitsInDungeon_precond (fruits)) :
    maxFruitsInDungeon_postcond (fruits) (maxFruitsInDungeon (fruits) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1700_leetcode_3363