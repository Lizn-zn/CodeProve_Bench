import Mathlib

namespace no_2684_p03720


-- Precondition definitions
@[reducible, simp]
def countRoadsPerCity_precond (n : Nat) (m : Nat) (roads : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  -- n is the number of cities (2 ≤ n ≤ 50)
    -- m is the number of roads (2 ≤ m ≤ 50)
    -- roads is a list of m edges where each edge connects two different cities
    2 ≤ n ∧ n ≤ 50 ∧
    2 ≤ m ∧ m ≤ 50 ∧
    roads.length = m ∧
    (∀ (edge : Nat × Nat), edge ∈ roads → 
      1 ≤ edge.1 ∧ edge.1 ≤ n ∧ 
      1 ≤ edge.2 ∧ edge.2 ≤ n ∧ 
      edge.1 ≠ edge.2)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to initialize a list of n zeros
def initCountList (n : Nat) : List Nat :=
  List.replicate n 0

-- Helper function to increment the count for a specific city (1-indexed)
def incrementCity (counts : List Nat) (city : Nat) : List Nat :=
  if city = 0 || city > counts.length then counts
  else
    let idx := city - 1
    counts.set idx (counts[idx]! + 1)

-- Helper function to process a single road and update counts
def processRoad (counts : List Nat) (edge : Nat × Nat) : List Nat :=
  let counts' := incrementCity counts edge.1
  incrementCity counts' edge.2

-- Helper function to process all roads
def processAllRoads (roads : List (Nat × Nat)) (n : Nat) : List Nat :=
  roads.foldl processRoad (initCountList n)

-- Main function definitions
def countRoadsPerCity (n : Nat) (m : Nat) (roads : List (Nat × Nat)) (h_precond : countRoadsPerCity_precond (n) (m) (roads)) : List Nat :=
  -- !benchmark @start code
  processAllRoads roads n
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to count how many roads are connected to a specific city
def countRoadsForCity (city : Nat) (roads : List (Nat × Nat)) : Nat :=
  roads.foldl (fun acc edge => 
    if edge.1 = city then acc + 1
    else if edge.2 = city then acc + 1
    else acc) 0

-- Postcondition definitions
@[reducible, simp]
def countRoadsPerCity_postcond (n : Nat) (m : Nat) (roads : List (Nat × Nat)) (result: List Nat) (h_precond : countRoadsPerCity_precond (n) (m) (roads)) : Prop :=
  -- !benchmark @start postcond
  -- The result is a list of n elements where the i-th element (0-indexed)
    -- represents the number of roads connected to city (i+1)
    result.length = n ∧
    (∀ i : Nat, i < n → 
      result[i]! = countRoadsForCity (i + 1) roads)
  -- !benchmark @end postcond


-- Proof content
theorem countRoadsPerCity_postcond_satisfied (n: Nat) (m: Nat) (roads: List (Nat × Nat)) (h_precond : countRoadsPerCity_precond (n) (m) (roads)) :
    countRoadsPerCity_postcond (n) (m) (roads) (countRoadsPerCity (n) (m) (roads) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2684_p03720