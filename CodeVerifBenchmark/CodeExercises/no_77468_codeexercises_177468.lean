import Mathlib

namespace no_77468_codeexercises_177468


-- Precondition definitions
@[reducible, simp]
def extract_odd_squares_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def is_odd (n : Nat) : Bool := n % 2 = 1

-- Main function definitions
def extract_odd_squares (nums : List Nat) (h_precond : extract_odd_squares_precond (nums)) : List (Nat × Unit) :=
  -- !benchmark @start code
  let filtered := nums.filter is_odd
  filtered.map (λ n => (n * n, ()))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_odd_post (n : Nat) : Bool := n % 2 = 1

-- Postcondition definitions
@[reducible, simp]
def extract_odd_squares_postcond (nums : List Nat) (result: List (Nat × Unit)) (h_precond : extract_odd_squares_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result = (nums.filter (λ n => is_odd_post n)).map (λ n => (n * n, ()))
  -- !benchmark @end postcond


-- Proof content
theorem extract_odd_squares_postcond_satisfied (nums: List Nat) (h_precond : extract_odd_squares_precond (nums)) :
    extract_odd_squares_postcond (nums) (extract_odd_squares (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_77468_codeexercises_177468