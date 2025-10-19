import Mathlib

-- Precondition auxiliary definitions
def validMineIndex (n : Nat) (mine : Nat × Nat) : Prop :=
  mine.1 < n ∧ mine.2 < n

def allMinesValid (n : Nat) (mines : List (Nat × Nat)) : Prop :=
  ∀ mine ∈ mines, validMineIndex n mine

-- Precondition definitions
@[reducible, simp]
def largestPlusSign_precond (n : Nat) (mines : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  n > 0 ∧ n ≤ 500 ∧ mines.length ≤ 5000 ∧ allMinesValid n mines
  -- !benchmark @end precond


-- Code auxiliary definitions
def countConsecutiveOnes (arr : List Nat) : List Nat :=
  let rec helper (remaining : List Nat) (currentCount : Nat) (acc : List Nat) : List Nat :=
    match remaining with
    | [] => acc.reverse
    | 0 :: rest => helper rest 0 (0 :: acc)
    | _ :: rest => 
      helper rest (currentCount + 1) ((currentCount + 1) :: acc)
  helper arr 0 []

def computeArmLengths (n : Nat) (gridRow : List Nat) : List Nat :=
  let leftToRight := countConsecutiveOnes gridRow
  let rightToLeft := countConsecutiveOnes gridRow.reverse
  let rightToLeftCorrected := rightToLeft.reverse
  List.zipWith (min · ·) leftToRight rightToLeftCorrected

def buildGridFromMines (n : Nat) (mines : List (Nat × Nat)) : List (List Nat) :=
  let allPositions := List.range n >>= fun i => List.range n |> List.map (fun j => (i, j))
  let zeroPositions := mines
  (List.range n).map (fun i => 
    (List.range n).map (fun j => 
      if zeroPositions.contains (i, j) then 0 else 1))

def transpose (matrix : List (List Nat)) : List (List Nat) :=
  if matrix.isEmpty then []
  else
    let cols := matrix.head!.length
    (List.range cols).map (fun j =>
      matrix.map (fun row => row.get! j))

def minOfFour (a b c d : Nat) : Nat := min (min a b) (min c d)

-- Main function definitions
def largestPlusSign (n : Nat) (mines : List (Nat × Nat)) (h_precond : largestPlusSign_precond (n) (mines)) : Nat :=
  -- !benchmark @start code
  let grid := buildGridFromMines n mines
  let rows := grid.map (computeArmLengths n)
  let colsTransposed := transpose grid
  let cols := transpose (colsTransposed.map (computeArmLengths n))
  
  let combined := List.zipWith (fun row col => List.zipWith (fun a b => minOfFour a b a b) row col) rows cols
  
  let maxInRow (row : List Nat) : Nat :=
    match row with
    | [] => 0
    | _ => row.foldl max 0
  
  match combined.map maxInRow with
  | [] => 0
  | list => list.foldl max 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def gridVal (n : Nat) (mines : List (Nat × Nat)) (i j : Nat) : Nat :=
  if mines.contains (i, j) then 0 else 1

def isValidPlusSign (n : Nat) (mines : List (Nat × Nat)) (r c k : Nat) : Prop :=
  k > 0 ∧ r < n ∧ c < n ∧ gridVal n mines r c = 1 ∧
  (∀ i, i > 0 → i < k → 
    (r ≥ i → gridVal n mines (r-i) c = 1) ∧
    (r+i < n → gridVal n mines (r+i) c = 1) ∧
    (c ≥ i → gridVal n mines r (c-i) = 1) ∧
    (c+i < n → gridVal n mines r (c+i) = 1))

def hasValidPlusSign (n : Nat) (mines : List (Nat × Nat)) (k : Nat) : Prop :=
  ∃ r c, isValidPlusSign n mines r c k

def isLargestPlusSignOrder (n : Nat) (mines : List (Nat × Nat)) (result : Nat) : Prop :=
  hasValidPlusSign n mines result ∧
  (∀ k, k > result → ¬hasValidPlusSign n mines k)

-- Postcondition definitions
@[reducible, simp]
def largestPlusSign_postcond (n : Nat) (mines : List (Nat × Nat)) (result: Nat) (h_precond : largestPlusSign_precond (n) (mines)) : Prop :=
  -- !benchmark @start postcond
  isLargestPlusSignOrder n mines result
  -- !benchmark @end postcond


-- Proof content
theorem largestPlusSign_postcond_satisfied (n: Nat) (mines: List (Nat × Nat)) (h_precond : largestPlusSign_precond (n) (mines)) :
    largestPlusSign_postcond (n) (mines) (largestPlusSign (n) (mines) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof