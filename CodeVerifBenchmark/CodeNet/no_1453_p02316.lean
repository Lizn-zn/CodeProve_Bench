import Mathlib

-- Precondition definitions
@[reducible, simp]
def unboundedKnapsack_precond (items : List (Nat × Nat)) (capacity : Nat) : Prop :=
  -- !benchmark @start precond
  items.length > 0 ∧ capacity > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to update DP array for one item
def updateDPForItem (dp : Array Nat) (value weight : Nat) (capacity : Nat) : Array Nat :=
  let rec loop (j : Nat) (currentDP : Array Nat) : Array Nat :=
    if j > capacity then currentDP
    else
      let newValue := value + currentDP[j - weight]!
      let updatedDP := if newValue ≥ currentDP[j]! then currentDP.set! j newValue else currentDP
      loop (j + 1) updatedDP
  termination_by (capacity + 1 - j)
  decreasing_by sorry
  loop weight dp

-- Process all items to build the DP table
def processItems (items : List (Nat × Nat)) (capacity : Nat) : Array Nat :=
  let initialDP := Array.mkArray (capacity + 1) 0
  items.foldl (fun dp (value, weight) =>
    if weight ≤ capacity then
      updateDPForItem dp value weight capacity
    else
      dp
  ) initialDP

-- Main function definitions
def unboundedKnapsack (items : List (Nat × Nat)) (capacity : Nat) (h_precond : unboundedKnapsack_precond (items) (capacity)) : Nat :=
  -- !benchmark @start code
  let dp := processItems items capacity
    let result := dp.foldl max 0
    result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- A valid selection is a list of counts for each item type
def ValidSelection (items : List (Nat × Nat)) (capacity : Nat) (counts : List Nat) : Prop :=
  counts.length = items.length ∧
  (List.zip items counts).foldl (fun acc ((v, w), cnt) => acc + w * cnt) 0 ≤ capacity

-- Calculate total value for a given selection
def SelectionValue (items : List (Nat × Nat)) (counts : List Nat) : Nat :=
  (List.zip items counts).foldl (fun acc ((v, w), cnt) => acc + v * cnt) 0

-- Check if a selection exists with the given value
def ExistsSelectionWithValue (items : List (Nat × Nat)) (capacity : Nat) (targetValue : Nat) : Prop :=
  ∃ counts : List Nat, ValidSelection items capacity counts ∧ SelectionValue items counts = targetValue

-- Check if a value is achievable (there exists a selection with at least this value)
def IsAchievableValue (items : List (Nat × Nat)) (capacity : Nat) (value : Nat) : Prop :=
  ∃ counts : List Nat, ValidSelection items capacity counts ∧ SelectionValue items counts ≥ value

-- Postcondition definitions
@[reducible, simp]
def unboundedKnapsack_postcond (items : List (Nat × Nat)) (capacity : Nat) (result: Nat) (h_precond : unboundedKnapsack_precond (items) (capacity)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the maximum achievable value
  (∃ counts : List Nat, ValidSelection items capacity counts ∧ SelectionValue items counts = result) ∧
  (∀ counts : List Nat, ValidSelection items capacity counts → SelectionValue items counts ≤ result)
  -- !benchmark @end postcond


-- Proof content
theorem unboundedKnapsack_postcond_satisfied (items: List (Nat × Nat)) (capacity: Nat) (h_precond : unboundedKnapsack_precond (items) (capacity)) :
    unboundedKnapsack_postcond (items) (capacity) (unboundedKnapsack (items) (capacity) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof