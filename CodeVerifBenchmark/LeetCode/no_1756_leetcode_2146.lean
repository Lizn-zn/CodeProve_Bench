import Mathlib

namespace no_1756_leetcode_2146


-- Precondition auxiliary definitions
def isValidGridIndex (grid : List (List Nat)) (row col : Nat) : Prop :=
  row < grid.length ∧ col < (grid.get ⟨row, by sorry⟩).length

def isReachableCell (grid : List (List Nat)) (row col : Nat) : Prop :=
  isValidGridIndex grid row col ∧ (grid.get ⟨row, by sorry⟩).get ⟨col, by sorry⟩ ≠ 0

def isInPriceRange (pricing : List Nat) (price : Nat) : Prop :=
  pricing.length = 2 ∧
  let low := pricing.get ⟨0, by sorry⟩
  let high := pricing.get ⟨1, by sorry⟩
  low ≤ price ∧ price ≤ high

def isValidStart (grid : List (List Nat)) (start : List Nat) : Prop :=
  start.length = 2 ∧
  let row := start.get ⟨0, by sorry⟩
  let col := start.get ⟨1, by sorry⟩
  isReachableCell grid row col

def isValidPricing (pricing : List Nat) : Prop :=
  pricing.length = 2 ∧
  let low := pricing.get ⟨0, by sorry⟩
  let high := pricing.get ⟨1, by sorry⟩
  low ≤ high ∧ 1 ≤ low

-- Precondition definitions
@[reducible, simp]
def highestRankedKItems_precond (grid : List (List Nat)) (pricing : List Nat) (start : List Nat) (k : Nat) : Prop :=
  -- !benchmark @start precond
  grid.length > 0 ∧
  ∀ row ∈ grid, row.length > 0 ∧
  pricing.length = 2 ∧
  start.length = 2 ∧
  isValidStart grid start ∧
  isValidPricing pricing ∧
  k > 0 ∧
  k ≤ (List.sum (List.map List.length grid))
  -- !benchmark @end precond


-- Code auxiliary definitions
abbrev ItemInfo := Nat × Nat × Nat × Nat  -- (distance, price, row, col)
deriving instance Repr for ItemInfo

def compareItems (item1 item2 : ItemInfo) : Bool :=
  let (d1, p1, r1, c1) := item1
  let (d2, p2, r2, c2) := item2
  if d1 < d2 then true
  else if d1 > d2 then false
  else if p1 < p2 then true
  else if p1 > p2 then false
  else if r1 < r2 then true
  else if r1 > r2 then false
  else if c1 < c2 then true
  else false

def sortItemsByRank (items : List ItemInfo) : List ItemInfo :=
  items.mergeSort (fun a b => compareItems a b)

def extractPositions (items : List ItemInfo) : List (List Nat) :=
  items.map (fun (_, _, r, c) => [r, c])

def isInPriceRange' (pricing : List Nat) (price : Nat) : Bool :=
  if pricing.length ≠ 2 then false
  else
    let low := pricing.get ⟨0, by sorry⟩
    let high := pricing.get ⟨1, by sorry⟩
    low ≤ price ∧ price ≤ high

structure State where
  visited : List (List Bool)
  queue : List (Nat × Nat × Nat)  -- (row, col, distance)
  items : List ItemInfo
  deriving Repr

def initializeVisited (rows cols : Nat) : List (List Bool) :=
  List.replicate rows (List.replicate cols false)

def markVisited (visited : List (List Bool)) (row col : Nat) : List (List Bool) :=
  if row ≥ visited.length ∨ col ≥ (visited.get ⟨0, by sorry⟩).length then visited
  else
    let oldRow := visited.get ⟨row, by sorry⟩
    let newRow := List.set oldRow col true
    List.set visited row newRow

def isVisited (visited : List (List Bool)) (row col : Nat) : Bool :=
  if row ≥ visited.length ∨ col ≥ (visited.get ⟨0, by sorry⟩).length then false
  else
    (visited.get ⟨row, by sorry⟩).get ⟨col, by sorry⟩

def isValidAndNotVisited (grid : List (List Nat)) (visited : List (List Bool)) (row col : Nat) : Bool :=
  if row ≥ grid.length ∨ col ≥ (grid.get ⟨0, by sorry⟩).length then false
  else
    let cellValue := (grid.get ⟨row, by sorry⟩).get ⟨col, by sorry⟩
    cellValue ≠ 0 ∧ ¬(isVisited visited row col)

def getNeighbors (grid : List (List Nat)) (visited : List (List Bool)) (row col : Nat) : List (Nat × Nat) :=
  let directions := [(0, 1), (1, 0), (0, -1), (-1, 0)]
  directions.filterMap fun (dr, dc) =>
    let newRow := (Int.ofNat row + dr).toNat
    let newCol := (Int.ofNat col + dc).toNat
    if isValidAndNotVisited grid visited newRow newCol then
      some (newRow, newCol)
    else
      none

-- Main function definitions
def highestRankedKItems (grid : List (List Nat)) (pricing : List Nat) (start : List Nat) (k : Nat) (h_precond : highestRankedKItems_precond (grid) (pricing) (start) (k)) : List (List Nat) :=
  -- !benchmark @start code
  let numRows := grid.length
    let numCols := (grid.get ⟨0, by sorry⟩).length
    let startRow := start.get ⟨0, by sorry⟩
    let startCol := start.get ⟨1, by sorry⟩
    let initialVisited := initializeVisited numRows numCols
    let markedVisited := markVisited initialVisited startRow startCol
    let initialState := { visited := markedVisited, queue := [(startRow, startCol, 0)], items := [] }
    
    let finalState := List.foldl (fun (s : State) _ =>
      match s.queue with
      | [] => s
      | (row, col, dist) :: restQueue =>
        -- Process current cell
        let price := (grid.get ⟨row, by sorry⟩).get ⟨col, by sorry⟩
        let newItems := if price > 1 ∧ (isInPriceRange' pricing price) then
                         (dist, price, row, col) :: s.items
                       else
                         s.items
        
        -- Get unvisited neighbors
        let neighbors := getNeighbors grid s.visited row col
        let updatedVisited := neighbors.foldl (fun v (r, c) => markVisited v r c) s.visited
        let newQueueEntries := neighbors.map (fun (r, c) => (r, c, dist + 1))
        
        { visited := updatedVisited,
          queue := restQueue ++ newQueueEntries,
          items := newItems }
    ) initialState (List.range (numRows * numCols))
    
    let sortedItems := sortItemsByRank finalState.items
    let topKItems := sortedItems.take k
    extractPositions topKItems
  -- !benchmark @end code


-- Postcondition auxiliary definitions
inductive GridPath : List (List Nat) → Nat → Nat → Nat → Prop
  | base (grid : List (List Nat)) (row col : Nat) :
    isReachableCell grid row col →
    GridPath grid row col 0
  | step (grid : List (List Nat)) (r c r' c' : Nat) (dist : Nat) :
    GridPath grid r c dist →
    (r' = r + 1 ∨ r' = r - 1 ∨ r' = r) ∧
    (c' = c + 1 ∨ c' = c - 1 ∨ c' = c) →
    isReachableCell grid r' c' →
    GridPath grid r' c' (dist + 1)

def ItemInfo' := Nat × Nat × Nat × Nat  -- (distance, price, row, col)

def itemRank (item1 item2 : ItemInfo') : Prop :=
  let (d1, p1, r1, c1) := item1
  let (d2, p2, r2, c2) := item2
  d1 < d2 ∨
  (d1 = d2 ∧ p1 < p2) ∨
  (d1 = d2 ∧ p1 = p2 ∧ r1 < r2) ∨
  (d1 = d2 ∧ p1 = p2 ∧ r1 = r2 ∧ c1 < c2)

def isSortedByRank (items : List ItemInfo') : Prop :=
  match items with
  | [] => True
  | [_] => True
  | a :: b :: rest => itemRank a b ∧ isSortedByRank (b :: rest)

def collectValidItems (grid : List (List Nat)) (pricing : List Nat) (start : List Nat) : List ItemInfo' :=
  let numRows := grid.length
  let numCols := (grid.get ⟨0, by sorry⟩).length
  let validItems := List.range numRows >>= fun row =>
    List.range numCols >>= fun col =>
      let price := (grid.get ⟨row, by sorry⟩).get ⟨col, by sorry⟩
      if price > 1 ∧ isInPriceRange' pricing price then  -- Changed from isInPriceRange to isInPriceRange'
        [(0, price, row, col)]  -- Distance will be computed properly in implementation
      else
        []
  validItems

def compareItems' (item1 item2 : ItemInfo') : Ordering :=
  let (d1, p1, r1, c1) := item1
  let (d2, p2, r2, c2) := item2
  if d1 < d2 then .lt
  else if d1 > d2 then .gt
  else if p1 < p2 then .lt
  else if p1 > p2 then .gt
  else if r1 < r2 then .lt
  else if r1 > r2 then .gt
  else if c1 < c2 then .lt
  else if c1 > c2 then .gt
  else .eq

def sortItemsByRank' (items : List ItemInfo') : List ItemInfo' :=
  items.mergeSort (fun a b => compareItems' a b = .lt)

def extractPositions' (items : List ItemInfo') : List (List Nat) :=
  items.map (fun (_, _, r, c) => [r, c])

-- Postcondition definitions
@[reducible, simp]
def highestRankedKItems_postcond (grid : List (List Nat)) (pricing : List Nat) (start : List Nat) (k : Nat) (result: List (List Nat)) (h_precond : highestRankedKItems_precond (grid) (pricing) (start) (k)) : Prop :=
  -- !benchmark @start postcond
  let startRow := start.get ⟨0, by sorry⟩
  let startCol := start.get ⟨1, by sorry⟩
  let validItems := collectValidItems grid pricing start
  let sortedItems := sortItemsByRank' validItems
  let topKItems := sortedItems.take k
  let expectedPositions := extractPositions' topKItems
  result = expectedPositions
  -- !benchmark @end postcond


-- Proof content
theorem highestRankedKItems_postcond_satisfied (grid: List (List Nat)) (pricing: List Nat) (start: List Nat) (k: Nat) (h_precond : highestRankedKItems_precond (grid) (pricing) (start) (k)) :
    highestRankedKItems_postcond (grid) (pricing) (start) (k) (highestRankedKItems (grid) (pricing) (start) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1756_leetcode_2146