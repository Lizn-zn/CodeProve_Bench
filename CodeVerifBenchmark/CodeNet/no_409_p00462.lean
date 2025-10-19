import Mathlib

-- Precondition definitions
@[reducible, simp]
def pizzaDelivery_precond (d : Nat) (storePositions : List Nat) (deliveryPositions : List Nat) : Prop :=
  -- !benchmark @start precond
  d ≥ 2 ∧ 
    storePositions.length ≥ 1 ∧
    deliveryPositions.length ≥ 1 ∧
    -- All store positions (except the main store at 0) are in valid range [1, d-1]
    (∀ pos ∈ storePositions, 1 ≤ pos ∧ pos ≤ d - 1) ∧
    -- All store positions are distinct
    storePositions.Nodup ∧
    -- All delivery positions are in valid range [0, d-1]
    (∀ pos ∈ deliveryPositions, pos ≤ d - 1)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to find the nearest store positions around a delivery position
def findNearestStores (sortedStores : Array Nat) (deliveryPos : Nat) : Nat × Nat :=
  -- Binary search to find the position where deliveryPos would be inserted
  let rec binarySearch (left right : Nat) : Nat :=
    if left >= right then left
    else
      let mid := (left + right) / 2
      if sortedStores[mid]! <= deliveryPos then
        binarySearch (mid + 1) right
      else
        binarySearch left mid
  let idx := binarySearch 0 sortedStores.size
  -- idx is the first position where sortedStores[idx] > deliveryPos
  let prevStore := if idx > 0 then sortedStores[idx - 1]! else sortedStores[sortedStores.size - 1]!
  let nextStore := if idx < sortedStores.size then sortedStores[idx]! else sortedStores[0]!
  (prevStore, nextStore)

-- Efficient version using sorted stores
def totalDeliveryDistanceEfficient (d : Nat) (storePositions : List Nat) (deliveryPositions : List Nat) : Nat :=
  let allStores := (0 :: storePositions).toArray
  let sortedStores := allStores.qsort (· < ·)
  -- Add the wraparound store at the end for circular logic
  let extendedStores := sortedStores.push (sortedStores[0]! + d)
  
  deliveryPositions.foldl (fun acc deliveryPos =>
    let (prevStore, nextStore) := findNearestStores sortedStores deliveryPos
    let distToPrev := if deliveryPos >= prevStore then 
                        deliveryPos - prevStore 
                      else 
                        d - prevStore + deliveryPos
    let distToNext := if nextStore >= deliveryPos then 
                        nextStore - deliveryPos 
                      else 
                        d - deliveryPos + nextStore
    acc + min distToPrev distToNext
  ) 0

-- Main function definitions
def pizzaDelivery (d : Nat) (storePositions : List Nat) (deliveryPositions : List Nat) (h_precond : pizzaDelivery_precond (d) (storePositions) (deliveryPositions)) : Nat :=
  -- !benchmark @start code
  totalDeliveryDistanceEfficient d storePositions deliveryPositions
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Calculate the distance from a store to a delivery position on a circular route
def circularDistance (d : Nat) (storePos : Nat) (deliveryPos : Nat) : Nat :=
  let clockwise := if deliveryPos ≥ storePos then deliveryPos - storePos else d - storePos + deliveryPos
  let counterclockwise := if storePos ≥ deliveryPos then storePos - deliveryPos else d - deliveryPos + storePos
  min clockwise counterclockwise

-- Find the minimum distance from any store to a delivery position
def minDistanceToDelivery (d : Nat) (allStores : List Nat) (deliveryPos : Nat) : Nat :=
  match allStores with
  | [] => 0  -- Should not happen given preconditions
  | stores => (stores.map (fun store => circularDistance d store deliveryPos)).foldl min (circularDistance d stores.head! deliveryPos)

-- Calculate total delivery distance for all orders
def totalDeliveryDistance (d : Nat) (storePositions : List Nat) (deliveryPositions : List Nat) : Nat :=
  let allStores := 0 :: storePositions  -- Include main store at position 0
  deliveryPositions.foldl (fun acc deliveryPos => acc + minDistanceToDelivery d allStores deliveryPos) 0

-- Postcondition definitions
@[reducible, simp]
def pizzaDelivery_postcond (d : Nat) (storePositions : List Nat) (deliveryPositions : List Nat) (result: Nat) (h_precond : pizzaDelivery_precond (d) (storePositions) (deliveryPositions)) : Prop :=
  -- !benchmark @start postcond
  result = totalDeliveryDistance d storePositions deliveryPositions
  -- !benchmark @end postcond


-- Proof content
theorem pizzaDelivery_postcond_satisfied (d: Nat) (storePositions: List Nat) (deliveryPositions: List Nat) (h_precond : pizzaDelivery_precond (d) (storePositions) (deliveryPositions)) :
    pizzaDelivery_postcond (d) (storePositions) (deliveryPositions) (pizzaDelivery (d) (storePositions) (deliveryPositions) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof