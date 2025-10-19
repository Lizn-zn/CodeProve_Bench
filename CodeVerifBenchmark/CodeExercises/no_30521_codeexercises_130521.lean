import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def find_smallest_multiple_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  n > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
def my_lcm (a b : Nat) : Nat :=
  if a = 0 then b
  else if b = 0 then a
  else (a * b) / (Nat.gcd a b)

def compute_lcm_range (n : Nat) : Nat :=
  match n with
  | 0 => 1
  | 1 => 1
  | k + 1 => my_lcm (compute_lcm_range k) (k + 1)

-- Main function definitions
def find_smallest_multiple (n : Nat) (h_precond : find_smallest_multiple_precond (n)) : Nat :=
  -- !benchmark @start code
  if n == 1 then
      1
    else
      compute_lcm_range n
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def isMultipleOfAllUpTo (m : Nat) (n : Nat) : Prop :=
  ∀ (k : Nat), 1 ≤ k ∧ k ≤ n → m % k = 0

def isSmallestMultipleOfAllUpTo (m : Nat) (n : Nat) : Prop :=
  isMultipleOfAllUpTo m n ∧ ∀ (m' : Nat), m' < m → ¬ isMultipleOfAllUpTo m' n

-- Postcondition definitions
@[reducible, simp]
def find_smallest_multiple_postcond (n : Nat) (result: Nat) (h_precond : find_smallest_multiple_precond (n)) : Prop :=
  -- !benchmark @start postcond
  isSmallestMultipleOfAllUpTo result n
  -- !benchmark @end postcond


-- Proof content
theorem find_smallest_multiple_postcond_satisfied (n: Nat) (h_precond : find_smallest_multiple_precond (n)) :
    find_smallest_multiple_postcond (n) (find_smallest_multiple (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof