import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_odd_numbers_precond (start : Nat) (end_val : Nat) : Prop :=
  -- !benchmark @start precond
  start ≤ end_val + 1
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to generate the list of numbers in the range
def range (start : Nat) (end_val : Nat) : List Nat :=
  List.range (end_val + 1 - start) |>.map (λ i => start + i)

-- Helper function to filter odd numbers
def is_odd (n : Nat) : Bool := n % 2 = 1

def filter_odd (nums : List Nat) : List Nat :=
  nums.filter is_odd

-- Main function definitions
def find_odd_numbers (start : Nat) (end_val : Nat) (h_precond : find_odd_numbers_precond start end_val) : List Nat :=
  -- !benchmark @start code
  -- Generate the range from start to end_val (inclusive)
  let nums := range start end_val
  -- Filter to keep only odd numbers
  filter_odd nums
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def in_range (n : Nat) (start end_val : Nat) : Prop := start ≤ n ∧ n ≤ end_val

-- Postcondition definitions
@[reducible, simp]
def find_odd_numbers_postcond (start : Nat) (end_val : Nat) (result: List Nat) (h_precond : find_odd_numbers_precond start end_val) : Prop :=
  -- !benchmark @start postcond
  ∀ n, n ∈ result ↔ (in_range n start end_val ∧ is_odd n)
  -- !benchmark @end postcond


-- Proof content
theorem find_odd_numbers_postcond_satisfied (start: Nat) (end_val: Nat) (h_precond : find_odd_numbers_precond start end_val) :
    find_odd_numbers_postcond start end_val (find_odd_numbers start end_val h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof