import Mathlib

-- Precondition auxiliary definitions
-- Helper function to check if an operation is valid
def isValidOperation (lanes : List (List Nat)) (op : Nat × Nat) : Prop :=
  match op.1 with
  | 0 => -- finish refueling: lane number must be valid and non-empty
    op.2 > 0 ∧ op.2 ≤ lanes.length ∧ 
    (lanes[op.2 - 1]!).length > 0
  | 1 => -- enter: car number is positive
    op.2 > 0
  | _ => False

-- Helper function to simulate one operation
def applyOperation (lanes : List (List Nat)) (op : Nat × Nat) : List (List Nat) :=
  match op.1 with
  | 0 => -- finish refueling at lane (op.2 - 1)
    let laneIdx := op.2 - 1
    lanes.set laneIdx (lanes[laneIdx]!.tail!)
  | 1 => -- car enters, find lane with minimum cars
    let minIdx := (List.range lanes.length).foldl 
      (fun acc i => if lanes[i]!.length < lanes[acc]!.length then i else acc) 0
    lanes.set minIdx (lanes[minIdx]! ++ [op.2])
  | _ => lanes

-- Helper function to check all operations are valid sequentially
def allOperationsValid (n : Nat) (operations : List (Nat × Nat)) : Prop :=
  let initialLanes := List.replicate n []
  operations.foldl 
    (fun (acc : Prop × List (List Nat)) op => 
      (acc.1 ∧ isValidOperation acc.2 op, applyOperation acc.2 op))
    (True, initialLanes) |>.1

-- Precondition definitions
@[reducible, simp]
def gasStationSimulation_precond (n : Nat) (operations : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  n > 0 ∧ 
    n ≤ 10 ∧
    operations.length ≥ 2 ∧
    operations.length ≤ 10000 ∧
    -- All operations have valid type (0 or 1)
    (∀ op ∈ operations, op.1 = 0 ∨ op.1 = 1) ∧
    -- At least one enter operation and one finish operation
    (∃ op ∈ operations, op.1 = 1) ∧
    (∃ op ∈ operations, op.1 = 0) ∧
    -- All car numbers are distinct
    (∀ i j, i < operations.length → j < operations.length → 
      operations[i]!.1 = 1 → operations[j]!.1 = 1 → 
      i ≠ j → operations[i]!.2 ≠ operations[j]!.2) ∧
    -- All car numbers are in valid range
    (∀ op ∈ operations, op.1 = 1 → op.2 ≥ 1 ∧ op.2 ≤ 9999) ∧
    -- All lane numbers are in valid range
    (∀ op ∈ operations, op.1 = 0 → op.2 ≥ 1 ∧ op.2 ≤ n) ∧
    -- All operations are valid in sequence
    allOperationsValid n operations
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to find the lane with minimum cars (ties broken by smallest index)
def findMinLane (lanes : List (List Nat)) : Nat :=
  (List.range lanes.length).foldl 
    (fun acc i => 
      if lanes[i]!.length < lanes[acc]!.length then i 
      else if lanes[i]!.length = lanes[acc]!.length ∧ i < acc then i
      else acc) 
    0

-- Process operations and collect results
def processOperations (n : Nat) (operations : List (Nat × Nat)) : List Nat :=
  let initialLanes := List.replicate n []
  (operations.foldl 
    (fun (acc : List Nat × List (List Nat)) op =>
      match op.1 with
      | 0 => -- finish refueling
        let laneIdx := op.2 - 1
        let finishedCar := acc.2[laneIdx]!.head!
        let newLanes := acc.2.set laneIdx (acc.2[laneIdx]!.tail!)
        (acc.1 ++ [finishedCar], newLanes)
      | 1 => -- car enters
        let minIdx := findMinLane acc.2
        let newLanes := acc.2.set minIdx (acc.2[minIdx]! ++ [op.2])
        (acc.1, newLanes)
      | _ => acc)
    ([], initialLanes)).1

-- Main function definitions
def gasStationSimulation (n : Nat) (operations : List (Nat × Nat)) (h_precond : gasStationSimulation_precond (n) (operations)) : List Nat :=
  -- !benchmark @start code
  processOperations n operations
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to extract finished car numbers from operations
def simulateGasStation (n : Nat) (operations : List (Nat × Nat)) : List Nat :=
  let initialLanes := List.replicate n []
  (operations.foldl 
    (fun (acc : List Nat × List (List Nat)) op =>
      match op.1 with
      | 0 => -- finish refueling
        let laneIdx := op.2 - 1
        let finishedCar := acc.2[laneIdx]!.head!
        let newLanes := acc.2.set laneIdx (acc.2[laneIdx]!.tail!)
        (acc.1 ++ [finishedCar], newLanes)
      | 1 => -- car enters
        let minIdx := (List.range n).foldl 
          (fun accIdx i => 
            if acc.2[i]!.length < acc.2[accIdx]!.length then i 
            else if acc.2[i]!.length = acc.2[accIdx]!.length ∧ i < accIdx then i
            else accIdx) 
          0
        let newLanes := acc.2.set minIdx (acc.2[minIdx]! ++ [op.2])
        (acc.1, newLanes)
      | _ => acc)
    ([], initialLanes)).1

-- Postcondition definitions
@[reducible, simp]
def gasStationSimulation_postcond (n : Nat) (operations : List (Nat × Nat)) (result: List Nat) (h_precond : gasStationSimulation_precond (n) (operations)) : Prop :=
  -- !benchmark @start postcond
  result = simulateGasStation n operations
  -- !benchmark @end postcond


-- Proof content
theorem gasStationSimulation_postcond_satisfied (n: Nat) (operations: List (Nat × Nat)) (h_precond : gasStationSimulation_precond (n) (operations)) :
    gasStationSimulation_postcond (n) (operations) (gasStationSimulation (n) (operations) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof