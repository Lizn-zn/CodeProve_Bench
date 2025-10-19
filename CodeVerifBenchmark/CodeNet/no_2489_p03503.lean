import Mathlib

-- Precondition definitions
@[reducible, simp]
def maxShopProfit_precond (n : Nat) (shopSchedules : List (List Nat)) (profitTables : List (List Int)) : Prop :=
  -- !benchmark @start precond
  -- n is the number of existing shops (1 ≤ n ≤ 100)
  n ≥ 1 ∧ n ≤ 100 ∧
  -- shopSchedules contains n schedules, each with 10 periods (5 days × 2 periods)
  shopSchedules.length = n ∧
  (∀ schedule ∈ shopSchedules, schedule.length = 10 ∧ (∀ val ∈ schedule, val = 0 ∨ val = 1)) ∧
  -- Each shop must be open during at least one period
  (∀ schedule ∈ shopSchedules, ∃ val ∈ schedule, val = 1) ∧
  -- profitTables contains n profit tables, each with 11 entries (for 0 to 10 overlaps)
  profitTables.length = n ∧
  (∀ table ∈ profitTables, table.length = 11 ∧ (∀ profit ∈ table, profit ≥ -10000000 ∧ profit ≤ 10000000))
  -- !benchmark @end precond


-- Postcondition auxiliary definitions
-- Calculate the number of overlapping periods between Joisino's schedule and a shop's schedule
def countOverlaps (joisino : List Nat) (shop : List Nat) : Nat :=
  (List.zip joisino shop).foldl (fun acc (j, s) => acc + j * s) 0

-- Calculate the total profit for a given Joisino's schedule
def calculateProfit (joisino : List Nat) (shopSchedules : List (List Nat)) (profitTables : List (List Int)) : Int :=
  (List.zip shopSchedules profitTables).foldl 
    (fun acc (shop, profits) => 
      let overlaps := countOverlaps joisino shop
      acc + profits[overlaps]!) 
    0

-- Check if a schedule is valid (at least one period is open)
def isValidSchedule (schedule : List Nat) : Prop :=
  ∃ val ∈ schedule, val = 1

-- Generate all possible schedules (2^10 - 1 valid schedules)
def allValidSchedules : List (List Nat) :=
  let allBits := List.range 1024 |>.tail! -- Exclude 0 (all closed)
  allBits.map (fun n => List.range 10 |>.map (fun i => (n >>> i) % 2))

-- Code auxiliary definitions
-- Helper function to convert a number to a binary list of length 10
def numToBinaryList (n : Nat) : List Nat :=
  List.range 10 |>.map (fun i => (n >>> i) % 2)

-- Helper function to find maximum profit among all valid schedules
def findMaxProfit (schedules : List (List Nat)) (shopSchedules : List (List Nat)) (profitTables : List (List Int)) : Int :=
  schedules.foldl 
    (fun maxProfit schedule => 
      let profit := calculateProfit schedule shopSchedules profitTables
      max maxProfit profit)
    (-10000000000 : Int) -- Start with a very small number

-- Main function definitions
def maxShopProfit (n : Nat) (shopSchedules : List (List Nat)) (profitTables : List (List Int)) (h_precond : maxShopProfit_precond (n) (shopSchedules) (profitTables)) : Int :=
  -- !benchmark @start code
  -- Generate all valid schedules and find the maximum profit
    findMaxProfit allValidSchedules shopSchedules profitTables
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def maxShopProfit_postcond (n : Nat) (shopSchedules : List (List Nat)) (profitTables : List (List Int)) (result: Int) (h_precond : maxShopProfit_precond (n) (shopSchedules) (profitTables)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the maximum profit among all valid schedules
  (∃ schedule ∈ allValidSchedules, 
    schedule.length = 10 ∧ 
    isValidSchedule schedule ∧
    result = calculateProfit schedule shopSchedules profitTables) ∧
  (∀ schedule ∈ allValidSchedules, 
    schedule.length = 10 → 
    isValidSchedule schedule → 
    calculateProfit schedule shopSchedules profitTables ≤ result)
  -- !benchmark @end postcond


-- Proof content
theorem maxShopProfit_postcond_satisfied (n: Nat) (shopSchedules: List (List Nat)) (profitTables: List (List Int)) (h_precond : maxShopProfit_precond (n) (shopSchedules) (profitTables)) :
    maxShopProfit_postcond (n) (shopSchedules) (profitTables) (maxShopProfit (n) (shopSchedules) (profitTables) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof