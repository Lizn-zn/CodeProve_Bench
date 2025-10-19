import Mathlib

-- Precondition auxiliary definitions
/-- A ride is valid if start < end and all components are positive. -/
def valid_ride : Nat × Nat × Nat → Prop
| (start, end_, tip) => 0 < start ∧ start < end_ ∧ 0 < tip

/-- All rides in the list are valid. -/
def valid_rides : List (Nat × Nat × Nat) → Prop
| [] => True
| r :: rs => valid_ride r ∧ valid_rides rs

-- Precondition definitions
@[reducible, simp]
def maxTaxiEarnings_precond (n : Nat) (rides : List (Nat × Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  0 < n ∧ valid_rides rides ∧ ∀ r ∈ rides, let (start, end_, _) := r; start ≤ n ∧ end_ ≤ n
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Sorts rides by their ending point. -/
def sort_rides_by_end (rides : List (Nat × Nat × Nat)) : List (Nat × Nat × Nat) :=
  rides.mergeSort fun r1 r2 => Prod.snd (Prod.snd r1) < Prod.snd (Prod.snd r2)

/-- Binary search to find the latest ride that ends before or at a given start point. -/
def find_latest_compatible (rides : List (Nat × Nat × Nat)) (start_point : Nat) : Option Nat :=
  let sorted := sort_rides_by_end rides
  let rec go (l : Nat) (r : Nat) (best : Option Nat) : Option Nat :=
    if l > r then best else
      let mid := (l + r) / 2
      let mid_ride := sorted.get? mid
      match mid_ride with
      | none => best
      | some (_, end_, _) =>
        if end_ ≤ start_point then
          go (mid + 1) r (some mid)
        else
          go l (mid - 1) best
  termination_by r - l
  decreasing_by
    all_goals sorry
  go 0 (sorted.length - 1) none

/-- Dynamic programming solution for maximum taxi earnings. -/
def maxTaxiEarningsDP (n : Nat) (rides : List (Nat × Nat × Nat)) : Nat :=
  let sorted_rides := sort_rides_by_end rides
  let len := sorted_rides.length
  if len = 0 then 0 else
    let dp : Array Nat := Array.mk (List.replicate (len + 1) 0)
    let dp_with_index := Id.run do
      let mut dpa := dp
      for i in [0:len] do
        match sorted_rides.get? i with
        | none => continue
        | some ride =>
          let (start, end_, tip) := ride
          let profit := (end_ - start) + tip
          -- Find latest compatible ride
          let j : Nat := match find_latest_compatible (sorted_rides.take i) start with
                        | none => 0
                        | some idx => idx + 1
          let incl := profit + dpa[j]!
          let excl := dpa[i]!
          dpa := dpa.set! (i+1) (max incl excl)
      return dpa
    dp_with_index[len]!

-- Main function definitions
def maxTaxiEarnings (n : Nat) (rides : List (Nat × Nat × Nat)) (h_precond : maxTaxiEarnings_precond (n) (rides)) : Nat :=
  -- !benchmark @start code
  maxTaxiEarningsDP n rides
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Computes the profit of a single ride. -/
def ride_profit : Nat × Nat × Nat → Nat
| (start, end_, tip) => (end_ - start) + tip

/-- A list of rides is non-overlapping and ordered if for every consecutive pair,
    the end of the first is less than or equal to the start of the second. -/
def ordered_non_overlapping (rides : List (Nat × Nat × Nat)) : Prop :=
  match rides with
  | [] => True
  | [_] => True
  | (s1, e1, _) :: (s2, e2, _) :: rest =>
    e1 ≤ s2 ∧ ordered_non_overlapping ((s2, e2, default) :: rest)

/-- The sum of profits of a list of rides. -/
def total_profit : List (Nat × Nat × Nat) → Nat
| [] => 0
| r :: rs => ride_profit r + total_profit rs

/-- A selection of rides is valid if it is a sublist of the original rides,
    is ordered and non-overlapping, and all rides are within bounds. -/
def valid_selection (all_rides : List (Nat × Nat × Nat)) (selected : List (Nat × Nat × Nat)) (n : Nat) : Prop :=
  selected.Sublist all_rides ∧
  ordered_non_overlapping selected ∧
  ∀ r ∈ selected, let (start, end_, _) := r; 0 < start ∧ start < end_ ∧ end_ ≤ n

-- Postcondition definitions
@[reducible, simp]
def maxTaxiEarnings_postcond (n : Nat) (rides : List (Nat × Nat × Nat)) (result: Nat) (h_precond : maxTaxiEarnings_precond (n) (rides)) : Prop :=
  -- !benchmark @start postcond
  ∀ selected : List (Nat × Nat × Nat),
    valid_selection rides selected n → total_profit selected ≤ result ∧
    (∃ selected_opt : List (Nat × Nat × Nat),
      valid_selection rides selected_opt n ∧
      total_profit selected_opt = result)
  -- !benchmark @end postcond


-- Proof content
theorem maxTaxiEarnings_postcond_satisfied (n: Nat) (rides: List (Nat × Nat × Nat)) (h_precond : maxTaxiEarnings_precond (n) (rides)) :
    maxTaxiEarnings_postcond (n) (rides) (maxTaxiEarnings (n) (rides) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof