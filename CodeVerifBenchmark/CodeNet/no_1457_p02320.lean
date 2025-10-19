import Mathlib

-- Precondition definitions
@[reducible, simp]
def knapsackWithLimitations_precond (n : Nat) (W : Nat) (items : List (Nat × Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  -- The number of items matches the length of the items list
  n = items.length ∧
  -- All items have positive values, weights, and limitations
  (∀ item ∈ items, item.1 > 0 ∧ item.2.1 > 0 ∧ item.2.2 > 0) ∧
  -- Capacity is positive
  W > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to process items using binary decomposition
def processItem (dp : Array Nat) (maxWeight : Nat) (v w m : Nat) (W : Nat) : Array Nat × Nat :=
  let rec processPowers (dp : Array Nat) (maxWeight : Nat) (m : Nat) (j : Nat) : Array Nat × Nat × Nat :=
    if j >= 13 then (dp, maxWeight, m)
    else
      let n := 1 <<< j
      if m < n then (dp, maxWeight, m)
      else
        let m' := m - n
        let _v := v * n
        let _w := w * n
        let maxWeight' := min W (maxWeight + _w)
        let dp' := updateDP dp _w _v maxWeight'
        processPowers dp' maxWeight' m' (j + 1)
  
  let (dp1, maxWeight1, m1) := processPowers dp maxWeight m 0
  if m1 > 0 then
    let _v := v * m1
    let _w := w * m1
    let maxWeight2 := min W (maxWeight1 + _w)
    let dp2 := updateDP dp1 _w _v maxWeight2
    (dp2, maxWeight2)
  else
    (dp1, maxWeight1)

where
  updateDP (dp : Array Nat) (w v maxWeight : Nat) : Array Nat :=
    let rec loop (dp : Array Nat) (k : Nat) : Array Nat :=
      if k < w then dp
      else
        let newVal := max dp[k]! (dp[k - w]! + v)
        loop (dp.set! k newVal) (k - 1)
    termination_by k
    decreasing_by sorry
    loop dp maxWeight

-- Main solving function
def solveKnapsack (n W : Nat) (items : List (Nat × Nat × Nat)) : Nat :=
  let dp := Array.mkArray (W + 1) 0
  let rec processItems (dp : Array Nat) (maxWeight : Nat) (items : List (Nat × Nat × Nat)) : Array Nat :=
    match items with
    | [] => dp
    | (v, w, m) :: rest =>
        let (dp', maxWeight') := processItem dp maxWeight v w m W
        processItems dp' maxWeight' rest
  
  let finalDP := processItems dp 0 items
  finalDP.foldl max 0

-- Main function definitions
def knapsackWithLimitations (n : Nat) (W : Nat) (items : List (Nat × Nat × Nat)) (h_precond : knapsackWithLimitations_precond (n) (W) (items)) : Nat :=
  -- !benchmark @start code
  solveKnapsack n W items
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to compute total value and weight given a selection
def totalValueWeight (items : List (Nat × Nat × Nat)) (selection : List Nat) : Nat × Nat :=
  List.foldl (fun (acc : Nat × Nat) (i : Nat) =>
    if h : i < items.length then
      let item := items[i]!
      let count := selection[i]!
      (acc.1 + item.1 * count, acc.2 + item.2.1 * count)
    else acc
  ) (0, 0) (List.range items.length)

-- Check if a selection is valid (respects limitations and capacity)
def isValidSelection (items : List (Nat × Nat × Nat)) (W : Nat) (selection : List Nat) : Prop :=
  selection.length = items.length ∧
  (∀ i : Nat, i < items.length → selection[i]! ≤ items[i]!.2.2) ∧
  (totalValueWeight items selection).2 ≤ W

-- Get the value of a selection
def selectionValue (items : List (Nat × Nat × Nat)) (selection : List Nat) : Nat :=
  (totalValueWeight items selection).1

-- Postcondition definitions
@[reducible, simp]
def knapsackWithLimitations_postcond (n : Nat) (W : Nat) (items : List (Nat × Nat × Nat)) (result: Nat) (h_precond : knapsackWithLimitations_precond (n) (W) (items)) : Prop :=
  -- !benchmark @start postcond
  -- There exists a valid selection that achieves the result value
  (∃ selection : List Nat, 
    isValidSelection items W selection ∧ 
    selectionValue items selection = result) ∧
  -- The result is the maximum possible value among all valid selections
  (∀ selection : List Nat, 
    isValidSelection items W selection → 
    selectionValue items selection ≤ result)
  -- !benchmark @end postcond


-- Proof content
theorem knapsackWithLimitations_postcond_satisfied (n: Nat) (W: Nat) (items: List (Nat × Nat × Nat)) (h_precond : knapsackWithLimitations_precond (n) (W) (items)) :
    knapsackWithLimitations_postcond (n) (W) (items) (knapsackWithLimitations (n) (W) (items) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof