import Mathlib

namespace no_2183_p03164


-- Precondition definitions
@[reducible, simp]
def knapsackMaxValue_precond (n : Nat) (W : Nat) (items : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  -- The number of items matches the list length
  items.length = n ∧
  -- All weights are positive and at most W
  (∀ i : Fin items.length, let (w, v) := items[i]!; 1 ≤ w ∧ w ≤ W) ∧
  -- All values are positive and at most 1000
  (∀ i : Fin items.length, let (w, v) := items[i]!; 1 ≤ v ∧ v ≤ 1000) ∧
  -- W is positive
  1 ≤ W ∧
  -- n is positive and at most 100
  1 ≤ n ∧ n ≤ 100
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute the sum of all values
def sumValues (items : List (Nat × Nat)) : Nat :=
  items.foldl (fun acc (w, v) => acc + v) 0

-- DP approach: dp[v] = minimum weight needed to achieve value v
def knapsackDP (items : List (Nat × Nat)) (maxValue : Nat) : Array Nat :=
  let INF := 10^18
  let init := Array.mkArray (maxValue + 1) INF |>.set! 0 0
  items.foldl (fun dp (w, v) =>
    -- Process in reverse order to avoid using the same item multiple times
    List.range (maxValue + 1) |>.reverse.foldl (fun dp' j =>
      if j ≥ v && dp'[j - v]! < INF then
        let newWeight := dp'[j - v]! + w
        if newWeight < dp'[j]! then
          dp'.set! j newWeight
        else
          dp'
      else
        dp'
    ) dp
  ) init

-- Main function definitions
def knapsackMaxValue (n : Nat) (W : Nat) (items : List (Nat × Nat)) (h_precond : knapsackMaxValue_precond (n) (W) (items)) : Nat :=
  -- !benchmark @start code
  -- Calculate the sum of all values to determine DP array size
    let k := sumValues items
    -- Build DP table where dp[v] = minimum weight to achieve value v
    let dp := knapsackDP items k
    -- Find the maximum value that can be achieved with weight ≤ W
    let result := List.range (k + 1) |>.foldl (fun maxVal i =>
      if dp[i]! ≤ W then i else maxVal
    ) 0
    result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- A subset of items represented as a boolean list indicating which items are selected
def validSelection (items : List (Nat × Nat)) (selection : List Bool) (W : Nat) : Prop :=
  selection.length = items.length ∧
  (List.zip items selection).foldl 
    (fun acc ((w, v), selected) => if selected then acc + w else acc) 
    0 ≤ W

-- Calculate the total value of a selection
def selectionValue (items : List (Nat × Nat)) (selection : List Bool) : Nat :=
  (List.zip items selection).foldl 
    (fun acc ((w, v), selected) => if selected then acc + v else acc) 
    0

-- Calculate the total weight of a selection
def selectionWeight (items : List (Nat × Nat)) (selection : List Bool) : Nat :=
  (List.zip items selection).foldl 
    (fun acc ((w, v), selected) => if selected then acc + w else acc) 
    0

-- Postcondition definitions
@[reducible, simp]
def knapsackMaxValue_postcond (n : Nat) (W : Nat) (items : List (Nat × Nat)) (result: Nat) (h_precond : knapsackMaxValue_precond (n) (W) (items)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the maximum value achievable
  (∃ selection : List Bool, 
    validSelection items selection W ∧ 
    selectionWeight items selection ≤ W ∧
    selectionValue items selection = result) ∧
  -- No other valid selection can achieve a higher value
  (∀ selection : List Bool, 
    validSelection items selection W → 
    selectionWeight items selection ≤ W → 
    selectionValue items selection ≤ result)
  -- !benchmark @end postcond


-- Proof content
theorem knapsackMaxValue_postcond_satisfied (n: Nat) (W: Nat) (items: List (Nat × Nat)) (h_precond : knapsackMaxValue_precond (n) (W) (items)) :
    knapsackMaxValue_postcond (n) (W) (items) (knapsackMaxValue (n) (W) (items) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2183_p03164