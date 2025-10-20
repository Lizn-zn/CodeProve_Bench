import Mathlib

namespace no_1540_leetcode_1895


-- Precondition auxiliary definitions
def isSquareMatrix (matrix : List (List Int)) : Prop :=
  match matrix with
  | [] => True
  | head :: tail => 
      let rowLength := head.length
      rowLength > 0 ∧ 
      matrix.Forall (fun row => row.length = rowLength)

def allElementsNat (matrix : List (List Int)) : Prop :=
  matrix.Forall (fun row => row.Forall (fun elem => Int.natAbs elem > 0))

def matrixBounds (matrix : List (List Int)) : Prop :=
  let m := matrix.length
  let n := if m > 0 then matrix.head!.length else 0
  m > 0 ∧ m ≤ 50 ∧ n > 0 ∧ n ≤ 50

def elementBounds (matrix : List (List Int)) : Prop :=
  matrix.Forall (fun row => row.Forall (fun elem => 1 ≤ elem ∧ elem ≤ 106))

-- Precondition definitions
@[reducible, simp]
def largestMagicSquare_precond (grid : List (List Int)) : Prop :=
  -- !benchmark @start precond
  isSquareMatrix grid ∧ matrixBounds grid ∧ allElementsNat grid ∧ elementBounds grid
  -- !benchmark @end precond


-- Postcondition auxiliary definitions
def sumList (l : List Int) : Int :=
  l.foldl (· + ·) 0

def getSubMatrix (grid : List (List Int)) (topLeftRow : Nat) (topLeftCol : Nat) (size : Nat) : List (List Int) :=
  let rows := grid.drop topLeftRow
  let selectedRows := rows.take size
  selectedRows.map (fun row => (row.drop topLeftCol).take size)

def isMagicSquare (square : List (List Int)) : Bool :=
  if square = [] then
    false
  else
    let size := square.length
    if size = 0 then
      false
    else
      -- Calculate the sum of the first row as the target sum
      let targetSum := sumList square.head!
      
      -- Check all rows
      let rowsValid := square.Forall (fun row => sumList row = targetSum)
      
      -- Check all columns
      let colsValid := 
        List.range size |>.Forall (fun colIdx => 
          let colSum := sumList (square.map (fun row => row.get! colIdx))
          colSum = targetSum
        )
      
      -- Check main diagonal
      let mainDiagSum := sumList (List.range size |>.map (fun i => square.get! i |>.get! i))
      let mainDiagValid := mainDiagSum = targetSum
      
      -- Check anti-diagonal
      let antiDiagSum := sumList (List.range size |>.map (fun i => square.get! i |>.get! (size - 1 - i)))
      let antiDiagValid := antiDiagSum = targetSum
      
      rowsValid ∧ colsValid ∧ mainDiagValid ∧ antiDiagValid

def checkAllSubSquares (grid : List (List Int)) (k : Nat) : Bool :=
  let m := grid.length
  let n := if m > 0 then grid.head!.length else 0
  if k > m ∨ k > n then
    false
  else
    (List.range (m - k + 1)).Forall (fun i =>
      (List.range (n - k + 1)).Forall (fun j =>
        isMagicSquare (getSubMatrix grid i j k)
      )
    )

-- Code auxiliary definitions
def findLargestSize (grid : List (List Int)) : Nat :=
  let m := grid.length
  let n := if m > 0 then grid.head!.length else 0
  let maxSize := min m n
  -- Try from maxSize down to 1
  let rec loop (k : Nat) : Nat :=
    if k = 0 then
      1  -- At least 1x1 is always a magic square
    else
      if checkAllSubSquares grid k then
        k
      else
        loop (k - 1)
  loop maxSize

-- Main function definitions
def largestMagicSquare (grid : List (List Int)) (h_precond : largestMagicSquare_precond (grid)) : Nat :=
  -- !benchmark @start code
  findLargestSize grid
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def largestMagicSquare_postcond (grid : List (List Int)) (result: Nat) (h_precond : largestMagicSquare_precond (grid)) : Prop :=
  -- !benchmark @start postcond
  result > 0 ∧ 
  (∀ k : Nat, k > result → ¬checkAllSubSquares grid k) ∧
  checkAllSubSquares grid result
  -- !benchmark @end postcond


-- Proof content
theorem largestMagicSquare_postcond_satisfied (grid: List (List Int)) (h_precond : largestMagicSquare_precond (grid)) :
    largestMagicSquare_postcond (grid) (largestMagicSquare (grid) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1540_leetcode_1895