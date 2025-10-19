import Mathlib

-- Precondition definitions
@[reducible, simp]
def exiting_while_loops_less_than_precond (n : Nat) (k : Nat) : Prop :=
  -- !benchmark @start precond
  n > 0 ∧ k > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def exiting_while_loops_less_than (n : Nat) (k : Nat) (h_precond : exiting_while_loops_less_than_precond (n) (k)) : Nat :=
  -- !benchmark @start code
  let rec loop (i : Nat) (acc : Nat) : Nat :=
    if h : i < n then
      if i % k = 0 then
        loop (i + 1) (acc + i)
      else
        loop (i + 1) acc
    else
      acc
  loop 1 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sum_divisible_by_k (n : Nat) (k : Nat) : Nat :=
  (Finset.sum (Finset.filter (λ x => x % k = 0) (Finset.Ico 1 n)) (λ x => x))

-- Postcondition definitions
@[reducible, simp]
def exiting_while_loops_less_than_postcond (n : Nat) (k : Nat) (result: Nat) (h_precond : exiting_while_loops_less_than_precond (n) (k)) : Prop :=
  -- !benchmark @start postcond
  result = sum_divisible_by_k n k
  -- !benchmark @end postcond


-- Proof content
theorem exiting_while_loops_less_than_postcond_satisfied (n: Nat) (k: Nat) (h_precond : exiting_while_loops_less_than_precond (n) (k)) :
    exiting_while_loops_less_than_postcond (n) (k) (exiting_while_loops_less_than (n) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

