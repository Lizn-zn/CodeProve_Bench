import Mathlib

-- Precondition definitions
@[reducible, simp]
def remove_odd_elements_precond (lst : List Int) (start : Nat) (end_pos : Nat) : Prop :=
  -- !benchmark @start precond
  start < end_pos ∧
    start < lst.length ∧
    end_pos ≤ lst.length
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to check if an integer is even
def is_even_code (x : Int) : Bool := x % 2 = 0

-- Helper function to filter odd elements from a specific range
def filter_range_code (lst : List Int) (start end_pos : Nat) : List Int :=
  match lst with
  | [] => []
  | x :: xs =>
    if start > 0 then
      x :: filter_range_code xs (start - 1) (end_pos - 1)
    else if end_pos > 0 then
      if is_even_code x then
        x :: filter_range_code xs 0 (end_pos - 1)
      else
        filter_range_code xs 0 (end_pos - 1)
    else
      []

-- Main function definitions
def remove_odd_elements (lst : List Int) (start : Nat) (end_pos : Nat) (h_precond : remove_odd_elements_precond lst start end_pos) : List Int :=
  -- !benchmark @start code
  -- Extract the preconditions from the hypothesis
  have h_start_lt_end : start < end_pos := h_precond.left
  have h_start_bound : start < lst.length := h_precond.right.left
  have h_end_bound : end_pos ≤ lst.length := h_precond.right.right
  
  -- Use the filter_range helper function to remove odd elements in the specified range
  filter_range_code lst start end_pos
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_even_prop (x : Int) : Prop := x % 2 = 0

def filter_range_prop (lst : List Int) (start end_pos : Nat) : List Int :=
  match lst with
  | [] => []
  | x :: xs =>
    if start > 0 then
      x :: filter_range_prop xs (start - 1) (end_pos - 1)
    else if end_pos > 0 then
      if is_even_code x then
        x :: filter_range_prop xs 0 (end_pos - 1)
      else
        filter_range_prop xs 0 (end_pos - 1)
    else
      []

-- Postcondition definitions
@[reducible, simp]
def remove_odd_elements_postcond (lst : List Int) (start : Nat) (end_pos : Nat) (result: List Int) (h_precond : remove_odd_elements_precond lst start end_pos) : Prop :=
  -- !benchmark @start postcond
  let filtered := filter_range_prop lst start end_pos
  result = filtered
  -- !benchmark @end postcond


-- Proof content
theorem remove_odd_elements_postcond_satisfied (lst: List Int) (start: Nat) (end_pos: Nat) (h_precond : remove_odd_elements_precond lst start end_pos) :
    remove_odd_elements_postcond lst start end_pos (remove_odd_elements lst start end_pos h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof