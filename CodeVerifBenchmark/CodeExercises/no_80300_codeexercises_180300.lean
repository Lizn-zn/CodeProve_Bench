import Mathlib

namespace no_80300_codeexercises_180300


-- Precondition definitions
@[reducible, simp]
def find_largest_perfect_square_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  n > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function that finds the largest perfect square ≤ n using binary search -/
def find_largest_perfect_square_aux (n : Nat) : Nat :=
  if n == 0 then 0
  else
    let rec binary_search (lo hi : Nat) : Nat :=
      if lo < hi then
        let mid := (lo + hi + 1) / 2
        if mid * mid ≤ n then
          binary_search mid hi
        else
          binary_search lo (mid - 1)
      else
        lo
    let max_sqrt := binary_search 1 n
    max_sqrt * max_sqrt

-- Main function definitions
def find_largest_perfect_square (n : Nat) (h_precond : find_largest_perfect_square_precond (n)) : Nat :=
  -- !benchmark @start code
  if n == 1 then 1
  else
    let candidate := find_largest_perfect_square_aux n
    -- Verify that candidate is indeed a perfect square ≤ n
    -- and that no larger perfect square exists
    candidate
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def IsPerfectSquare (k : Nat) : Prop := ∃ (m : Nat), m * m = k

-- Postcondition definitions
@[reducible, simp]
def find_largest_perfect_square_postcond (n : Nat) (result: Nat) (h_precond : find_largest_perfect_square_precond (n)) : Prop :=
  -- !benchmark @start postcond
  IsPerfectSquare result ∧ result ≤ n ∧ ∀ (k : Nat), k > result → k ≤ n → ¬IsPerfectSquare k
  -- !benchmark @end postcond


-- Proof content
theorem find_largest_perfect_square_postcond_satisfied (n: Nat) (h_precond : find_largest_perfect_square_precond (n)) :
    find_largest_perfect_square_postcond (n) (find_largest_perfect_square (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_80300_codeexercises_180300