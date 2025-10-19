import Mathlib

-- Precondition auxiliary definitions
/-- Check if all rows have the same length -/
def List.EqLength {α : Type} (l : List (List α)) : Prop :=
  match l with
  | [] => True
  | h :: t => ∀ r ∈ t, r.length = h.length

/-- Check if the list forms a valid matrix -/
def List.IsMatrix {α : Type} (l : List (List α)) : Prop :=
  l ≠ [] ∧ l.EqLength

/-- Get dimensions of the matrix -/
def List.MatrixDim {α : Type} (l : List (List α)) : Nat × Nat :=
  (l.length, match l with | [] => 0 | h :: _ => h.length)

/-- Access element at (i,j) in matrix with default value if out of bounds -/
def List.getMatrixElemD {α : Type} (default : α) (matrix : List (List α)) (i j : Nat) : α :=
  match matrix.get? i with
  | some row => match row.get? j with
                | some elem => elem
                | none => default
  | none => default

/-- Check if indices are within matrix bounds -/
def List.inBounds {α : Type} (matrix : List (List α)) (i j : Nat) : Prop :=
  i < matrix.length ∧ 
  (match matrix.get? i with
   | some row => j < row.length
   | none => False)

-- Precondition definitions
@[reducible, simp]
def maxProfitPath_precond (coins : List (List Int)) : Prop :=
  coins.IsMatrix ∧
  let dim := coins.MatrixDim
  dim.1 ≥ 1 ∧ dim.2 ≥ 1 ∧ dim.1 ≤ 500 ∧ dim.2 ≤ 500 ∧
  (∀ i j, coins.inBounds i j → -1000 ≤ coins.getMatrixElemD 0 i j ∧ coins.getMatrixElemD 0 i j ≤ 1000)

-- Code auxiliary definitions
/-- State for dynamic programming: (current_profit, neutralizations_used) -/
structure DPState :=
  profit : Int
  neutralized : Nat  -- Number of neutralizations used (0, 1, or 2)
deriving Inhabited

/-- Compare two DP states and return the better one -/
def betterState (s1 s2 : DPState) : DPState :=
  if s1.profit > s2.profit then s1 else s2

/-- Custom groupBy implementation for Lists -/
def List.groupBy' {α : Type} (r : α → α → Bool) : List α → List (List α) :=
  go
where
  go : List α → List (List α)
  | [] => []
  | h :: t => 
    let (eq, neq) := t.partition (r h)
    (h :: eq) :: go neq
decreasing_by sorry

/-- Merge lists of DP states, keeping only the best state for each neutralization count -/
def mergeStates (states : List DPState) : List DPState :=
  let grouped := states.groupBy' (fun s1 s2 => s1.neutralized = s2.neutralized)
  grouped.map (fun group => 
    match group with
    | [] => panic! "Empty group"
    | h :: t => t.foldl betterState h)

/-- Custom bind implementation for Lists -/
def List.bind' {α β : Type} (l : List α) (f : α → List β) : List β :=
  l.flatMap f

/-- Process a cell: add its value to all states, optionally neutralizing if it's negative -/
def processCell (cellValue : Int) (states : List DPState) : List DPState :=
  states.bind' (fun state =>
    if cellValue ≥ 0 then
      [⟨state.profit + cellValue, state.neutralized⟩]
    else -- cellValue < 0, it's a robber
      let withoutNeutralization := ⟨state.profit + cellValue, state.neutralized⟩
      if state.neutralized < 2 then
        let withNeutralization := ⟨state.profit, state.neutralized + 1⟩
        [withoutNeutralization, withNeutralization]
      else
        [withoutNeutralization])

/-- Set element at index in list, padding with default if necessary -/
def List.set' {α : Type} (l : List α) (idx : Nat) (value : α) : List α :=
  match idx, l with
  | 0, _ :: t => value :: t
  | n+1, h :: t => h :: (t.set' n value)
  | _, [] => [value]

/-- Initialize DP table -/
def initDPTable (rows cols : Nat) : List (List (List DPState)) :=
  List.replicate rows (List.replicate cols [])

/-- Update DP table at position (i,j) with new states -/
def updateDPTable (table : List (List (List DPState))) (i j : Nat) (newStates : List DPState) : List (List (List DPState)) :=
  match table.get? i with
  | some row =>
    match row.get? j with
    | some existingStates =>
      let updatedRow := row.set' j (mergeStates (existingStates ++ newStates))
      table.set' i updatedRow
    | none => table
  | none => table

/-- Get states from DP table at position (i,j) -/
def getDPStates (table : List (List (List DPState))) (i j : Nat) : List DPState :=
  match table.get? i with
  | some row => 
    match row.get? j with
    | some states => states
    | none => []
  | none => []

/-- Check if a list is non-empty -/
def List.nonEmpty {α : Type} (l : List α) : Bool :=
  match l with
  | [] => false
  | _ => true

/-- Compute maximum profit path using dynamic programming -/
def computeMaxProfit (coins : List (List Int)) : Int :=
  let (rows, cols) := coins.MatrixDim
  let dp := initDPTable rows cols
  -- Initialize starting position
  let dp := updateDPTable dp 0 0 [⟨coins.getMatrixElemD 0 0 0, 0⟩]
  
  -- Fill DP table
  let dp := Id.run do
    let mut dp := dp
    for i in [0:rows] do
      for j in [0:cols] do
        let currentStates := getDPStates dp i j
        if currentStates.nonEmpty then
          let cellValue := coins.getMatrixElemD 0 i j
          let processedStates := processCell cellValue currentStates
          
          -- Move right
          if j + 1 < cols then
            dp := updateDPTable dp i (j+1) processedStates
          
          -- Move down
          if i + 1 < rows then
            dp := updateDPTable dp (i+1) j processedStates
    pure dp
  
  -- Find maximum profit among all states at destination
  let finalStates := getDPStates dp (rows-1) (cols-1)
  match finalStates with
  | [] => 0
  | _ => 
    let profits := finalStates.map (·.profit)
    match profits with
    | [] => 0
    | h :: t => t.foldl (max · ·) h

-- Main function definitions
def maxProfitPath (coins : List (List Int)) (h_precond : maxProfitPath_precond (coins)) : Int :=
  let (rows, cols) := coins.MatrixDim
  let dp := initDPTable rows cols
  
  -- Initialize starting position
  let startValue := coins.getMatrixElemD 0 0 0
  let dp := updateDPTable dp 0 0 [⟨startValue, 0⟩]
  
  -- Fill DP table
  let dp := Id.run do
    let mut dp := dp
    for i in [0:rows] do
      for j in [0:cols] do
        let currentStates := getDPStates dp i j
        if currentStates.nonEmpty then
          let cellValue := coins.getMatrixElemD 0 i j
          let processedStates := processCell cellValue currentStates
          
          -- Move right
          if j + 1 < cols then
            dp := updateDPTable dp i (j+1) processedStates
          
          -- Move down
          if i + 1 < rows then
            dp := updateDPTable dp (i+1) j processedStates
    pure dp
  
  -- Find maximum profit among all states at destination
  let finalStates := getDPStates dp (rows-1) (cols-1)
  match finalStates with
  | [] => 0
  | _ => 
    let profits := finalStates.map (·.profit)
    match profits with
    | [] => 0
    | h :: t => t.foldl (max · ·) h

-- Postcondition definitions
@[reducible, simp]
def maxProfitPath_postcond (coins : List (List Int)) (result: Int) (h_precond : maxProfitPath_precond (coins)) : Prop :=
  result = computeMaxProfit coins

-- Proof content
theorem maxProfitPath_postcond_satisfied (coins: List (List Int)) (h_precond : maxProfitPath_precond (coins)) :
    maxProfitPath_postcond (coins) (maxProfitPath (coins) h_precond) h_precond := by
  sorry