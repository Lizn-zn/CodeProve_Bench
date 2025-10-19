import Mathlib

-- Precondition definitions
@[reducible, simp]
def minDaysToGatherMaps_precond (schedules : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  -- schedules is a list of schedules for each descendant
    -- Each schedule is a list of available days (1-30)
    schedules.length > 1 ∧ schedules.length ≤ 50 ∧
    -- All days in schedules are between 1 and 30
    (∀ schedule ∈ schedules, ∀ day ∈ schedule, 1 ≤ day ∧ day ≤ 30)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to simulate gathering maps for a given day
def simulateGathering (schedules : List (List Nat)) (maxDay : Nat) : Option Nat := Id.run do
  let n := schedules.length
  -- Initialize state: each descendant has only their own map (represented as a set)
  let mut state : Array (Finset Nat) := Array.mkArray n {}
  for i in [0:n] do
    state := state.set! i {i}
  
  -- Simulate day by day
  for day in [1:maxDay + 1] do
    -- Find all descendants available on this day
    let mut availableOnDay : List Nat := []
    for i in [0:n] do
      if day ∈ schedules[i]! then
        availableOnDay := availableOnDay.concat i
    
    -- Combine maps of all descendants available on this day
    if availableOnDay.length > 0 then
      let mut combinedMaps : Finset Nat := {}
      for idx in availableOnDay do
        combinedMaps := combinedMaps ∪ state[idx]!
      
      -- Update state for all descendants who met
      for idx in availableOnDay do
        state := state.set! idx combinedMaps
      
      -- Check if all maps are gathered
      if combinedMaps.card = n then
        return some day
  
  return none

-- Main function definitions
def minDaysToGatherMaps (schedules : List (List Nat)) (h_precond : minDaysToGatherMaps_precond (schedules)) : Int :=
  -- !benchmark @start code
  -- Check if any descendant has empty schedule
    let hasEmpty := schedules.any (fun schedule => schedule.isEmpty)
    if hasEmpty then
      -1
    else
      match simulateGathering schedules 30 with
      | some day => day
      | none => -1
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if all maps can be gathered by a given day
def canGatherByDay (schedules : List (List Nat)) (day : Nat) : Prop :=
  -- For each day from 1 to `day`, we simulate the gathering process
  -- We track which descendants' maps have been combined
  -- Two descendants can meet on a day if both have that day in their schedule
  ∃ (states : Nat → Nat → Finset Nat),
    -- Initial state: each descendant has only their own map
    (∀ i, i < schedules.length → states 0 i = {i}) ∧
    -- For each day d from 1 to day
    (∀ d, d ≤ day → ∀ i j,
      i < schedules.length → j < schedules.length →
      -- If both i and j are available on day d
      d ∈ schedules[i]! ∧ d ∈ schedules[j]! →
      -- Then they can meet and combine their maps
      states d i = states d j ∧
      states d i = states (d-1) i ∪ states (d-1) j) ∧
    -- By day `day`, all maps are gathered (some descendant has all maps)
    (∃ i, i < schedules.length ∧ states day i = Finset.range schedules.length)

-- Check if any descendant has an empty schedule
def hasEmptySchedule (schedules : List (List Nat)) : Prop :=
  ∃ schedule ∈ schedules, schedule = []

-- Postcondition definitions
@[reducible, simp]
def minDaysToGatherMaps_postcond (schedules : List (List Nat)) (result: Int) (h_precond : minDaysToGatherMaps_precond (schedules)) : Prop :=
  -- !benchmark @start postcond
  -- If any descendant has no available days, result is -1
    (hasEmptySchedule schedules → result = -1) ∧
    -- If result is -1, either someone has empty schedule or gathering is impossible within 30 days
    (result = -1 → hasEmptySchedule schedules ∨ ¬∃ d : Nat, d ≤ 30 ∧ canGatherByDay schedules d) ∧
    -- If result is positive (1-30), it's the minimum day to gather all maps
    (result > 0 ∧ result ≤ 30 →
      canGatherByDay schedules result.toNat ∧
      (∀ d : Nat, d < result.toNat → ¬canGatherByDay schedules d)) ∧
    -- Result must be -1 or in range [1, 30]
    (result = -1 ∨ (1 ≤ result ∧ result ≤ 30))
  -- !benchmark @end postcond


-- Proof content
theorem minDaysToGatherMaps_postcond_satisfied (schedules: List (List Nat)) (h_precond : minDaysToGatherMaps_precond (schedules)) :
    minDaysToGatherMaps_postcond (schedules) (minDaysToGatherMaps (schedules) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof