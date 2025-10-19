import Mathlib

-- Precondition definitions
@[reducible, simp]
def compute_sum_and_count_precond (pairs : List (Nat × Nat)) (k : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the implementation

-- Main function definitions
def compute_sum_and_count (pairs : List (Nat × Nat)) (k : Nat) (h_precond : compute_sum_and_count_precond (pairs) (k)) : Nat × Nat :=
  -- !benchmark @start code
  let filtered := pairs.filter (λ (a, b) => b > k)
    let sum := filtered.foldl (λ acc (a, _) => acc + a) 0
    let count := filtered.length
    (sum, count)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def filtered_pairs (pairs : List (Nat × Nat)) (k : Nat) : List Nat :=
  pairs.filterMap (λ (a, b) => if b > k then some a else none)

def sum_of_filtered (pairs : List (Nat × Nat)) (k : Nat) : Nat :=
  (filtered_pairs pairs k).foldl (· + ·) 0

def count_of_filtered (pairs : List (Nat × Nat)) (k : Nat) : Nat :=
  (filtered_pairs pairs k).length

-- Postcondition definitions
@[reducible, simp]
def compute_sum_and_count_postcond (pairs : List (Nat × Nat)) (k : Nat) (result: Nat × Nat) (h_precond : compute_sum_and_count_precond (pairs) (k)) : Prop :=
  -- !benchmark @start postcond
  result.1 = sum_of_filtered pairs k ∧ result.2 = count_of_filtered pairs k
  -- !benchmark @end postcond


-- Proof content
theorem compute_sum_and_count_postcond_satisfied (pairs: List (Nat × Nat)) (k: Nat) (h_precond : compute_sum_and_count_precond (pairs) (k)) :
    compute_sum_and_count_postcond (pairs) (k) (compute_sum_and_count (pairs) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

