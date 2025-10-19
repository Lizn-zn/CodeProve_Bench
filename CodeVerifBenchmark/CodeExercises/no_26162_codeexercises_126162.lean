import Mathlib

-- Precondition definitions
@[reducible, simp]
def create_range_with_break_precond (start : Nat) (stop : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def create_range_with_break (start : Nat) (stop : Nat) (h_precond : create_range_with_break_precond (start) (stop)) : List Nat :=
  -- !benchmark @start code
  if start ≥ stop then
    []
  else
    let rec loop (current : Nat) (acc : List Nat) : List Nat :=
      if current < stop then
        loop (current + 1) (current :: acc)
      else
        acc.reverse
    loop start []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def range_list (start stop : Nat) : List Nat :=
  if start < stop then
    List.range' start (stop - start)
  else
    []

-- Postcondition definitions
@[reducible, simp]
def create_range_with_break_postcond (start : Nat) (stop : Nat) (result: List Nat) (h_precond : create_range_with_break_precond (start) (stop)) : Prop :=
  -- !benchmark @start postcond
  result = range_list start stop
  -- !benchmark @end postcond


-- Proof content
theorem create_range_with_break_postcond_satisfied (start: Nat) (stop: Nat) (h_precond : create_range_with_break_precond (start) (stop)) :
    create_range_with_break_postcond (start) (stop) (create_range_with_break (start) (stop) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

