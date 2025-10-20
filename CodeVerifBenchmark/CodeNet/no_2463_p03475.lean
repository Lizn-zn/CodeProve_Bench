import Mathlib

namespace no_2463_p03475


-- Precondition definitions
@[reducible, simp]
def calculateEarliestArrivalTimes_precond (n : Nat) (trainData : List (Nat × Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  -- n is the number of stations (must be at least 1)
    -- trainData contains n-1 entries, one for each connection between consecutive stations
    -- Each entry is (C_i, S_i, F_i) where:
    --   C_i is the travel time from station i to i+1 (positive)
    --   S_i is the time of the first train departure (positive)
    --   F_i is the frequency of trains (positive)
    --   S_i is divisible by F_i
    n ≥ 1 ∧
    trainData.length = n - 1 ∧
    (∀ triple ∈ trainData, triple.1 > 0 ∧ triple.2.1 > 0 ∧ triple.2.2 > 0 ∧ triple.2.1 % triple.2.2 = 0)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to calculate the next departure time at or after time t
def nextDepartureImpl (t : Nat) (s : Nat) (f : Nat) : Nat :=
  let k := (t + f - 1) / f  -- ceiling division
  max s (k * f)

-- Helper function to calculate arrival time at station N starting from station i at time 0
def arrivalTimeFromImpl (i : Nat) (trainData : List (Nat × Nat × Nat)) : Nat :=
  let rec aux (currentTime : Nat) (remaining : List (Nat × Nat × Nat)) : Nat :=
    match remaining with
    | [] => currentTime
    | (c, s, f) :: rest =>
        let departTime := nextDepartureImpl currentTime s f
        let arriveTime := departTime + c
        aux arriveTime rest
  aux 0 (trainData.drop i)

-- Main function definitions
def calculateEarliestArrivalTimes (n : Nat) (trainData : List (Nat × Nat × Nat)) (h_precond : calculateEarliestArrivalTimes_precond (n) (trainData)) : List Nat :=
  -- !benchmark @start code
  -- Build the result list by computing arrival times for each station
    let rec buildResults (i : Nat) (acc : List Nat) : List Nat :=
      if i = 0 then acc
      else
        let stationIdx := i - 1
        let arrivalTime := 
          if stationIdx = n - 1 then 
            0  -- Already at station N
          else 
            arrivalTimeFromImpl stationIdx trainData
        buildResults stationIdx (arrivalTime :: acc)
    buildResults n []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to calculate the next departure time at or after time t
def nextDeparture (t : Nat) (s : Nat) (f : Nat) : Nat :=
  let k := (t + f - 1) / f  -- ceiling division
  max s (k * f)

-- Helper function to calculate arrival time at station N starting from station i at time 0
def arrivalTimeFrom (i : Nat) (trainData : List (Nat × Nat × Nat)) : Nat :=
  let rec aux (j : Nat) (currentTime : Nat) (remaining : List (Nat × Nat × Nat)) : Nat :=
    match remaining with
    | [] => currentTime
    | (c, s, f) :: rest =>
        let departTime := nextDeparture currentTime s f
        let arriveTime := departTime + c
        aux (j + 1) arriveTime rest
  aux i 0 (trainData.drop i)

-- Postcondition definitions
@[reducible, simp]
def calculateEarliestArrivalTimes_postcond (n : Nat) (trainData : List (Nat × Nat × Nat)) (result: List Nat) (h_precond : calculateEarliestArrivalTimes_precond (n) (trainData)) : Prop :=
  -- !benchmark @start postcond
  -- The result should have n entries
    result.length = n ∧
    -- For station N (index n-1), the arrival time is 0 (already there)
    result.get! (n - 1) = 0 ∧
    -- For each station i < n-1, the result is the earliest arrival time at station N
    (∀ i < n - 1, result.get! i = arrivalTimeFrom i trainData)
  -- !benchmark @end postcond


-- Proof content
theorem calculateEarliestArrivalTimes_postcond_satisfied (n: Nat) (trainData: List (Nat × Nat × Nat)) (h_precond : calculateEarliestArrivalTimes_precond (n) (trainData)) :
    calculateEarliestArrivalTimes_postcond (n) (trainData) (calculateEarliestArrivalTimes (n) (trainData) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2463_p03475