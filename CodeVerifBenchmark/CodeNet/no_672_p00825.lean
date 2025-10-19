import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def concertHallScheduling_precond (applications : List (Nat × Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  -- Each application has valid day range [i, j] where 1 ≤ i ≤ j ≤ 365
    -- and price is positive
    applications.all fun (i, j, w) => 1 ≤ i ∧ i ≤ j ∧ j ≤ 365 ∧ w > 0
  -- !benchmark @end precond


-- Postcondition auxiliary definitions
-- Check if two applications conflict (overlap in time)
def applicationsConflict (app1 app2 : Nat × Nat × Nat) : Bool :=
  let (i1, j1, _) := app1
  let (i2, j2, _) := app2
  -- Two applications conflict if their time periods overlap
  max i1 i2 ≤ min j1 j2

-- Check if a selection of applications is valid (at most 2 non-conflicting concerts per day)
def validSelection (applications : List (Nat × Nat × Nat)) (selected : List Nat) : Prop :=
  -- All selected indices are valid
  selected.all (fun idx => idx < applications.length) ∧
  -- For each day, at most 2 selected applications cover that day
  ∀ day : Nat, day ≥ 1 → day ≤ 365 →
    (selected.filter fun idx =>
      let app := applications[idx]!
      let (i, j, _) := app
      i ≤ day ∧ day ≤ j).length ≤ 2 ∧
  -- For each pair of selected applications that conflict, there must be at most 2 total
  ∀ idx1 idx2 : Nat, idx1 ∈ selected → idx2 ∈ selected → idx1 ≠ idx2 →
    applicationsConflict applications[idx1]! applications[idx2]! = true →
    -- Count how many selected applications conflict with both
    ∀ day : Nat, day ≥ 1 → day ≤ 365 →
      (selected.filter fun idx =>
        let app := applications[idx]!
        let (i, j, _) := app
        i ≤ day ∧ day ≤ j).length ≤ 2

-- Calculate total income from selected applications
def totalIncome (applications : List (Nat × Nat × Nat)) (selected : List Nat) : Nat :=
  selected.foldl (fun acc idx => acc + (applications[idx]!).2.2) 0


-- Code auxiliary definitions
-- Dynamic programming solution for concert hall scheduling with 2 rooms
-- We use DP where dp[day][room1_end][room2_end] represents the maximum income
-- up to 'day' where room1's last concert ends at room1_end and room2's at room2_end

-- Helper to get all applications sorted by end day
def sortApplicationsByEnd (applications : List (Nat × Nat × Nat)) : List (Nat × Nat × Nat × Nat) :=
  let indexed := applications.enum.map fun (idx, (i, j, w)) => (i, j, w, idx)
  indexed.insertionSort fun a b => a.2.1 < b.2.1

-- Check if we can add an application to a room that ends at 'roomEnd'
def canAddToRoom (roomEnd : Nat) (appStart : Nat) : Bool :=
  roomEnd < appStart

-- DP approach: for each application, decide whether to:
-- 1. Skip it
-- 2. Assign to room 1
-- 3. Assign to room 2
def computeMaxIncome (applications : List (Nat × Nat × Nat)) : Nat :=
  let sorted := sortApplicationsByEnd applications
  let n := sorted.length
  
  -- State: (room1_last_end, room2_last_end, current_income)
  -- We'll use a simple recursive approach with memoization concept
  -- For simplicity, we'll iterate through applications and maintain best income
  
  let rec helper (idx : Nat) (room1End room2End income : Nat) (fuel : Nat) : Nat :=
    match fuel with
    | 0 => income
    | fuel' + 1 =>
      if idx ≥ n then income
      else
        let (i, j, w, _) := sorted[idx]!
        -- Option 1: Skip this application
        let skip := helper (idx + 1) room1End room2End income fuel'
        -- Option 2: Try to assign to room 1
        let useRoom1 := 
          if canAddToRoom room1End i then
            helper (idx + 1) j room2End (income + w) fuel'
          else income
        -- Option 3: Try to assign to room 2
        let useRoom2 := 
          if canAddToRoom room2End i then
            helper (idx + 1) room1End j (income + w) fuel'
          else income
        max skip (max useRoom1 useRoom2)
  
  helper 0 0 0 0 (n * n * n)

-- Better approach using explicit DP with all states
def computeMaxIncomeDP (applications : List (Nat × Nat × Nat)) : Nat :=
  if applications.isEmpty then 0
  else
    let sorted := sortApplicationsByEnd applications
    let n := sorted.length
    
    -- Simplified DP: dp[i] = max income using applications 0..i-1
    let rec dp (idx : Nat) (states : List (Nat × Nat × Nat)) (fuel : Nat) : Nat :=
      match fuel with
      | 0 => states.foldl (fun acc (_, _, inc) => max acc inc) 0
      | fuel' + 1 =>
        if idx ≥ n then
          states.foldl (fun acc (_, _, inc) => max acc inc) 0
        else
          let (i, j, w, _) := sorted[idx]!
          let newStates := states.flatMap fun (r1, r2, inc) =>
            [ (r1, r2, inc),  -- skip
              if r1 < i then (j, r2, inc + w) else (r1, r2, inc),  -- use room1
              if r2 < i then (r1, j, inc + w) else (r1, r2, inc)   -- use room2
            ]
          let uniqueStates := newStates.pwFilter (fun a b => a != b)
          dp (idx + 1) uniqueStates fuel'
    
    dp 0 [(0, 0, 0)] (n + 1)

-- Main function definitions
def concertHallScheduling (applications : List (Nat × Nat × Nat)) (h_precond : concertHallScheduling_precond (applications)) : Nat :=
  -- !benchmark @start code
  computeMaxIncomeDP applications
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def concertHallScheduling_postcond (applications : List (Nat × Nat × Nat)) (result: Nat) (h_precond : concertHallScheduling_precond (applications)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the maximum possible income
    -- There exists a valid selection that achieves this income
    (∃ selected : List Nat, validSelection applications selected ∧ 
      totalIncome applications selected = result) ∧
    -- No other valid selection can achieve higher income
    (∀ selected : List Nat, validSelection applications selected → 
      totalIncome applications selected ≤ result)
  -- !benchmark @end postcond


-- Proof content
theorem concertHallScheduling_postcond_satisfied (applications: List (Nat × Nat × Nat)) (h_precond : concertHallScheduling_precond (applications)) :
    concertHallScheduling_postcond (applications) (concertHallScheduling (applications) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof