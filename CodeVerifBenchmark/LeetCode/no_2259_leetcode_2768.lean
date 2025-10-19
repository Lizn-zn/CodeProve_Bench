import Mathlib

-- Precondition auxiliary definitions
def validCoordinate (m n : Nat) (coord : Nat × Nat) : Prop :=
  coord.1 < m ∧ coord.2 < n

def isPairwiseDistinct (l : List (Nat × Nat)) : Prop :=
  ∀ x ∈ l, ∀ y ∈ l, x ≠ y → ¬(x.1 = y.1 ∧ x.2 = y.2)

-- Precondition definitions
@[reducible, simp]
def countBlackBlocks_precond (m : Nat) (n : Nat) (coordinates : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  m ≥ 2 ∧ n ≥ 2 ∧
  ∀ c ∈ coordinates, validCoordinate m n c ∧
  isPairwiseDistinct coordinates
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Convert a list of coordinates to a set for efficient lookup -/
def coordSet (coordinates : List (Nat × Nat)) : Std.HashSet (Nat × Nat) :=
  let set := coordinates.foldl (init := Std.HashSet.empty) fun s coord => s.insert coord
  set

/-- Count how many black cells are in a 2x2 block starting at (x, y) -/
def countInBlock (set : Std.HashSet (Nat × Nat)) (x y : Nat) : Nat :=
  let coords := [(x, y), (x + 1, y), (x, y + 1), (x + 1, y + 1)]
  coords.foldl (fun acc coord => if set.contains coord then acc + 1 else acc) 0


-- Main function definitions
def countBlackBlocks (m : Nat) (n : Nat) (coordinates : List (Nat × Nat)) (h_precond : countBlackBlocks_precond (m) (n) (coordinates)) : Array Nat :=
  -- !benchmark @start code
  let set := coordSet coordinates
  let result := Array.mkArray 5 0
  
  -- Iterate through all possible top-left corners of 2x2 blocks
  let result := Id.run do
    let mut res := result
    for x in [0:m-1] do
      for y in [0:n-1] do
        let count := countInBlock set x y
        -- Increment the count for blocks with `count` black cells
        if count < 5 then
          res := res.set! count (res[count]! + 1)
    res
  
  result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def countBlackCellsInBlock (coordinates : List (Nat × Nat)) (x y : Nat) : Nat :=
  let blockCoords := [(x, y), (x + 1, y), (x, y + 1), (x + 1, y + 1)]
  blockCoords.foldl (fun count coord => if coordinates.contains coord then count + 1 else count) 0

def countBlocksHavingKBlacks (m n : Nat) (coordinates : List (Nat × Nat)) (k : Nat) : Nat :=
  let validX := List.range (m - 1)
  let validY := List.range (n - 1)
  let allBlocks := validX.flatMap (fun x => validY.map (fun y => (x, y)))
  allBlocks.foldl (fun count (x, y) => if countBlackCellsInBlock coordinates x y = k then count + 1 else count) 0

-- Postcondition definitions
@[reducible, simp]
def countBlackBlocks_postcond (m : Nat) (n : Nat) (coordinates : List (Nat × Nat)) (result: Array Nat) (h_precond : countBlackBlocks_precond (m) (n) (coordinates)) : Prop :=
  -- !benchmark @start postcond
  result.size = 5 ∧
  ∀ i ∈ Finset.range 5,
    result[i]! = countBlocksHavingKBlacks m n coordinates i
  -- !benchmark @end postcond


-- Proof content
theorem countBlackBlocks_postcond_satisfied (m: Nat) (n: Nat) (coordinates: List (Nat × Nat)) (h_precond : countBlackBlocks_precond (m) (n) (coordinates)) :
    countBlackBlocks_postcond (m) (n) (coordinates) (countBlackBlocks (m) (n) (coordinates) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof