import Mathlib

-- Precondition auxiliary definitions
/-- A board is a chessboard if it has alternating 0s and 1s such that no two adjacent cells have the same value. -/
def IsChessboard (board : List (List Int)) : Prop :=
  let n := board.length
  (n > 0 ∧ (∀ row ∈ board, row.length = n)) ∧
  -- Every cell must differ from its neighbors
  (∀ i j, i < n → j < n →
    (∀ k, k < n → k ≠ i → (board.get! i).get! j = (board.get! k).get! j → False) ∧
    (∀ k, k < n → k ≠ j → (board.get! i).get! j = (board.get! i).get! k → False))

/-- Count how many positions differ from a given pattern starting with 'start' (0 or 1) at position (i,j). -/
def countDiffFromPattern (board : List (List Int)) (start : Int) : Nat :=
  let n := board.length
  let expectedVal i j := if (i + j) % 2 = start % 2 then 1 else 0
  List.foldl (fun acc (i, row) =>
    acc + List.foldl (fun innerAcc (j, val) =>
      if val ≠ expectedVal i j then innerAcc + 1 else innerAcc)
      0 (List.zip (List.range row.length) row))
    0 (List.zip (List.range board.length) board)

/-- Check whether a row matches one of two possible valid patterns for a chessboard. -/
def isValidRowPattern (row : List Int) : Bool :=
  let n := row.length
  if n = 0 then true else
    let first := row.head!
    let pattern1 := List.map (fun i => if i % 2 = 0 then first else 1 - first) (List.range n)
    let pattern2 := List.map (fun i => if i % 2 = 0 then 1 - first else first) (List.range n)
    row = pattern1 ∨ row = pattern2

/-- Check whether all rows are valid according to the above definition. -/
def allRowsValid (board : List (List Int)) : Bool :=
  board.all isValidRowPattern

/-- Generate all distinct rows present in the board. -/
def distinctRows (board : List (List Int)) : List (List Int) :=
  board.foldl (fun acc row => if acc.contains row then acc else row :: acc) []

/-- Check if there are exactly two distinct rows and they are complements of each other. -/
def hasTwoComplementRows (rows : List (List Int)) : Bool :=
  if rows.length ≠ 2 then false else
    let r1 := rows.head!
    let r2 := rows.tail!.head!
    r1.length = r2.length ∧
    (List.zipWith (· == ·) r1 r2).all (fun b => !b) -- All elements are different

/-- Generate all distinct columns present in the board. -/
def distinctColumns (board : List (List Int)) : List (List Int) :=
  if board.isEmpty then [] else
    let m := board.length
    let n := board.head!.length
    List.map (fun j =>
      List.map (fun i => (board.get! i).get! j) (List.range m)
    ) (List.range n)

/-- Check if there are exactly two distinct columns and they are complements of each other. -/
def hasTwoComplementColumns (cols : List (List Int)) : Bool :=
  if cols.length ≠ 2 then false else
    let c1 := cols.head!
    let c2 := cols.tail!.head!
    c1.length = c2.length ∧
    (List.zipWith (· == ·) c1 c2).all (fun b => !b)

-- Precondition definitions
@[reducible, simp]
def minMovesToChessboard_precond (board : List (List Int)) : Prop :=
  -- !benchmark @start precond
  let n := board.length
  n ≥ 2 ∧
  -- Board must be square
  (∀ row ∈ board, row.length = n) ∧
  -- All entries must be 0 or 1
  List.all board (fun row => List.all row (fun x => x = 0 ∨ x = 1))
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function to compute absolute difference between two natural numbers. -/
def Nat.absDiff (a b : Nat) : Nat :=
  if a ≥ b then a - b else b - a

/-- Count mismatches for a list to match an alternating pattern starting with `start`. -/
def countMismatches (lst : List Int) (start : Int) : Nat :=
  lst.enum.foldl (fun acc (i, val) =>
    let expected := if (Int.ofNat i % 2 : Int) = (start % 2) then 1 else 0
    if val ≠ expected then acc + 1 else acc
  ) 0

/-- Attempt to calculate minimum swaps to make a list alternate starting with 0 or 1. -/
def minSwapsToAlternate (lst : List Int) : Option Nat :=
  let mismatches0 := countMismatches lst 0
  let mismatches1 := countMismatches lst 1
  if mismatches0 % 2 ≠ 0 ∧ mismatches1 % 2 ≠ 0 then none
  else
    let swaps0 := if mismatches0 % 2 = 0 then some (mismatches0 / 2) else none
    let swaps1 := if mismatches1 % 2 = 0 then some (mismatches1 / 2) else none
    match swaps0, swaps1 with
    | some s0, some s1 => some (min s0 s1)
    | some s0, none => some s0
    | none, some s1 => some s1
    | none, none => none


-- Main function definitions
def minMovesToChessboard (board : List (List Int)) (h_precond : minMovesToChessboard_precond board) : Int :=
  -- !benchmark @start code
  let n := board.length
  let rows := distinctRows board
  let cols := distinctColumns board
  
  -- Check structural validity
  if ¬(rows.length = 2 ∧ hasTwoComplementRows rows ∧ cols.length = 2 ∧ hasTwoComplementColumns cols) then
    -1
  else
    -- Count occurrences of each row type
    let firstRow := rows.head!
    let rowCountFirst := board.foldl (fun acc row => if row = firstRow then acc + 1 else acc) 0
    let rowCountSecond := n - rowCountFirst
    
    -- Check balance condition for rows
    if Nat.absDiff rowCountFirst rowCountSecond > 1 then
      -1
    else
      -- Count occurrences of each column type by transposing the board
      let transposed := List.transpose board
      let firstCol := cols.head!
      let colCountFirst := transposed.foldl (fun acc col => if col = firstCol then acc + 1 else acc) 0
      let colCountSecond := n - colCountFirst
      
      -- Check balance condition for columns
      if Nat.absDiff colCountFirst colCountSecond > 1 then
        -1
      else
        -- Compute required swaps for rows
        let rowSwaps? := minSwapsToAlternate (List.map (fun row => if row = firstRow then 0 else 1) board)
        -- Compute required swaps for columns
        let colSwaps? := minSwapsToAlternate (List.map (fun col => if col = firstCol then 0 else 1) transposed)
        
        match rowSwaps?, colSwaps? with
        | some rs, some cs => Int.ofNat (rs + cs)
        | _, _ => -1
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def minSwapsToMakeAlternating (lst : List Int) (expectedStart : Int) : Option Nat :=
  let mismatches := lst.enum.filter (fun (i, val) => val ≠ if (Int.ofNat i % 2 : Int) = expectedStart then 1 else 0)
  if (mismatches.length) % 2 ≠ 0 then none else
    some (mismatches.length / 2)

def getMinRowSwaps (rows : List (List Int)) : Option Nat :=
  if rows.length = 0 then some 0 else
    let n := rows.length
    let firstRow := rows.head!
    let countFirst := rows.foldl (fun acc row => if row = firstRow then acc + 1 else acc) 0
    let countSecond := n - countFirst
    if Nat.absDiff countFirst countSecond > 1 then none else
      let evenParitySwaps := minSwapsToMakeAlternating (List.map (fun r => if r = firstRow then 0 else 1) rows) 0
      let oddParitySwaps := minSwapsToMakeAlternating (List.map (fun r => if r = firstRow then 0 else 1) rows) 1
      match evenParitySwaps, oddParitySwaps with
      | some e, some o =>
        if countFirst > countSecond then some e
        else if countSecond > countFirst then some o
        else some (min e o)
      | some e, none => some e
      | none, some o => some o
      | none, none => none

def getMinColSwaps (cols : List (List Int)) : Option Nat :=
  if cols.length = 0 then some 0 else
    let n := cols.length
    let firstCol := cols.head!
    let countFirst := cols.foldl (fun acc col => if col = firstCol then acc + 1 else acc) 0
    let countSecond := n - countFirst
    if Nat.absDiff countFirst countSecond > 1 then none else
      let evenParitySwaps := minSwapsToMakeAlternating (List.map (fun c => if c = firstCol then 0 else 1) cols) 0
      let oddParitySwaps := minSwapsToMakeAlternating (List.map (fun c => if c = firstCol then 0 else 1) cols) 1
      match evenParitySwaps, oddParitySwaps with
      | some e, some o =>
        if countFirst > countSecond then some e
        else if countSecond > countFirst then some o
        else some (min e o)
      | some e, none => some e
      | none, some o => some o
      | none, none => none

-- Postcondition definitions
@[reducible, simp]
def minMovesToChessboard_postcond (board : List (List Int)) (result: Int) (h_precond : minMovesToChessboard_precond board) : Prop :=
  -- !benchmark @start postcond
  let n := board.length
  let rows := distinctRows board
  let cols := distinctColumns board
  let validStructure := rows.length = 2 ∧ hasTwoComplementRows rows ∧ cols.length = 2 ∧ hasTwoComplementColumns cols
  if ¬validStructure then result = -1 else
    let maybeRowSwaps := getMinRowSwaps board
    let maybeColSwaps := getMinColSwaps (List.transpose board)
    match maybeRowSwaps, maybeColSwaps with
    | some rs, some cs => result = Int.ofNat (rs + cs)
    | _, _ => result = -1
  -- !benchmark @end postcond


-- Proof content
theorem minMovesToChessboard_postcond_satisfied (board: List (List Int)) (h_precond : minMovesToChessboard_precond board) :
    minMovesToChessboard_postcond board (minMovesToChessboard board h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof