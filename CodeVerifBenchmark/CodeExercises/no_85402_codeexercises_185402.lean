import Mathlib

-- Precondition definitions
@[reducible, simp]
def add_positive_integers_precond (total : Nat) (numbers : List Nat) : Prop :=
  -- !benchmark @start precond
  ∀ n ∈ numbers, n > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def add_positive_integers (total : Nat) (numbers : List Nat) (h_precond : add_positive_integers_precond (total) (numbers)) : Nat :=
  -- !benchmark @start code
  let rec helper (acc : Nat) (nums : List Nat) : Nat :=
    match nums with
    | [] => acc
    | n :: ns => helper (acc + n) ns
  helper total numbers
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def add_positive_integers_postcond (total : Nat) (numbers : List Nat) (result: Nat) (h_precond : add_positive_integers_precond (total) (numbers)) : Prop :=
  -- !benchmark @start postcond
  result = total + (numbers.foldl (· + ·) 0)
  -- !benchmark @end postcond


-- Proof content
theorem add_positive_integers_postcond_satisfied (total: Nat) (numbers: List Nat) (h_precond : add_positive_integers_precond (total) (numbers)) :
    add_positive_integers_postcond (total) (numbers) (add_positive_integers (total) (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

