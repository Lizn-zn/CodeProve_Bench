import Mathlib

-- Precondition definitions
@[reducible, simp]
def solveLupinHeist_precond (warehouses : Array (Nat × Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  -- warehouses is an array of tuples (warehouse_id, distance_from_castle, num_boxes)
    -- There is at least one warehouse
    warehouses.size > 0 ∧
    warehouses.size ≤ 15 ∧
    -- All warehouse IDs are valid (between 1 and 100)
    (∀ i : Fin warehouses.size, 
      let (id, dist, boxes) := warehouses[i]
      1 ≤ id ∧ id ≤ 100 ∧
      1 ≤ dist ∧ dist ≤ 10000 ∧
      1 ≤ boxes ∧ boxes ≤ 10000) ∧
    -- All warehouse IDs are distinct
    (∀ i j : Fin warehouses.size, i ≠ j → 
      let (id1, _, _) := warehouses[i]
      let (id2, _, _) := warehouses[j]
      id1 ≠ id2)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Dynamic programming state: (visited_mask, current_warehouse_index) -> (min_time, route)
-- We'll use a simpler approach: try all permutations and find the minimum

-- Helper to get warehouse by id
def getWarehouseById (warehouses : Array (Nat × Nat × Nat)) (id : Nat) : Option (Nat × Nat × Nat) :=
  warehouses.find? (fun w => w.1 == id)

-- Helper to calculate travel time for a complete route
def calcRouteTravelTime (warehouses : Array (Nat × Nat × Nat)) (route : Array Nat) : Float :=
  let rec go (idx : Nat) (weight : Nat) (pos : Nat) (time : Float) : Float :=
    if h : idx < route.size then
      match getWarehouseById warehouses route[idx] with
      | none => time  -- Should not happen with valid input
      | some (_, dist, boxes) =>
        let distance := if dist > pos then dist - pos else pos - dist
        let speed := 2000.0 / (70.0 + weight.toFloat)
        let travelTime := distance.toFloat / speed
        let newWeight := weight + boxes * 20
        go (idx + 1) newWeight dist (time + travelTime)
    else time
  
  if route.size == 0 then 0.0
  else
    match getWarehouseById warehouses route[0]! with
    | none => 0.0
    | some (_, _, boxes) => go 0 (boxes * 20) 0 0.0

-- Generate all permutations using dynamic programming with bitmask
partial def findOptimalRoute (warehouses : Array (Nat × Nat × Nat)) : Array Nat :=
  let n := warehouses.size
  
  -- Try all possible starting warehouses and use DP to find optimal continuation
  let rec solveDP (mask : Nat) (lastIdx : Nat) (currentWeight : Nat) (currentPos : Nat) : (Float × Array Nat) :=
    if mask == (1 <<< n) - 1 then
      (0.0, #[])
    else
      Id.run do
      let mut bestTime := 1e12
      let mut bestRoute := #[]
      
      for i in [:n] do
        if (mask &&& (1 <<< i)) == 0 then
          let (id, dist, boxes) := warehouses[i]!
          let distance := if dist > currentPos then dist - currentPos else currentPos - dist
          let speed := 2000.0 / (70.0 + currentWeight.toFloat)
          let travelTime := distance.toFloat / speed
          let newWeight := currentWeight + boxes * 20
          let (futureTime, futureRoute) := solveDP (mask ||| (1 <<< i)) i newWeight dist
          let totalTime := travelTime + futureTime
          
          if totalTime < bestTime then
            bestTime := totalTime
            bestRoute := #[id] ++ futureRoute
      
      return (bestTime, bestRoute)
  
  -- Try each warehouse as starting point
  Id.run do
  let mut globalBestTime := 1e12
  let mut globalBestRoute := #[]
  
  for i in [:n] do
    let (id, dist, boxes) := warehouses[i]!
    let (time, route) := solveDP (1 <<< i) i (boxes * 20) 0
    
    if time < globalBestTime then
      globalBestTime := time
      globalBestRoute := #[id] ++ route
  
  return globalBestRoute

-- Main function definitions
def solveLupinHeist (warehouses : Array (Nat × Nat × Nat)) (h_precond : solveLupinHeist_precond (warehouses)) : Array Nat :=
  -- !benchmark @start code
  findOptimalRoute warehouses
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if result is a permutation of warehouse IDs
def isPermutationOfWarehouseIds (warehouses : Array (Nat × Nat × Nat)) (result : Array Nat) : Prop :=
  result.size = warehouses.size ∧
  (∀ i : Fin result.size, ∃ j : Fin warehouses.size, 
    let (id, _, _) := warehouses[j]
    result[i] = id) ∧
  (∀ i : Fin warehouses.size, ∃ j : Fin result.size,
    let (id, _, _) := warehouses[i]
    result[j] = id) ∧
  (∀ i j : Fin result.size, i ≠ j → result[i] ≠ result[j])

-- Helper function to calculate total travel time for a given route
def calculateTravelTime (warehouses : Array (Nat × Nat × Nat)) (route : Array Nat) : Option Float :=
  if route.size = 0 then none
  else
    let rec computeTime (idx : Nat) (currentWeight : Nat) (currentPos : Nat) (accTime : Float) : Option Float :=
      if h : idx < route.size then
        -- Find the warehouse with id = route[idx]
        match warehouses.findIdx? (fun w => w.1 == route[idx]) with
        | none => none
        | some warehouseIdx =>
          if h2 : warehouseIdx < warehouses.size then
            let (_, dist, boxes) := warehouses[warehouseIdx]
            let newWeight := currentWeight + boxes * 20
            let distance := if dist > currentPos then dist - currentPos else currentPos - dist
            let speed := 2000.0 / (70.0 + currentWeight.toFloat)
            let time := distance.toFloat / speed
            computeTime (idx + 1) newWeight dist (accTime + time)
          else none
      else some accTime
    -- Start from position 0 (castle) with the weight of boxes from first warehouse
    match warehouses.findIdx? (fun w => w.1 == route[0]!) with
    | none => none
    | some firstIdx =>
      if h : firstIdx < warehouses.size then
        let (_, _, firstBoxes) := warehouses[firstIdx]
        computeTime 0 (firstBoxes * 20) 0 0.0
      else none

-- Postcondition definitions
@[reducible, simp]
def solveLupinHeist_postcond (warehouses : Array (Nat × Nat × Nat)) (result: Array Nat) (h_precond : solveLupinHeist_precond (warehouses)) : Prop :=
  -- !benchmark @start postcond
  -- The result is a valid permutation of all warehouse IDs
    isPermutationOfWarehouseIds warehouses result ∧
    -- The result represents an optimal ordering that minimizes total travel time
    -- (i.e., no other permutation has strictly less travel time)
    (∀ otherRoute : Array Nat, 
      isPermutationOfWarehouseIds warehouses otherRoute →
      match calculateTravelTime warehouses result, calculateTravelTime warehouses otherRoute with
      | some t1, some t2 => t1 ≤ t2
      | _, _ => True)
  -- !benchmark @end postcond


-- Proof content
theorem solveLupinHeist_postcond_satisfied (warehouses: Array (Nat × Nat × Nat)) (h_precond : solveLupinHeist_precond (warehouses)) :
    solveLupinHeist_postcond (warehouses) (solveLupinHeist (warehouses) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof