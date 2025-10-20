import Mathlib

namespace no_26090_codeexercises_126090


-- Precondition definitions
@[reducible, simp]
def find_multiple_of_precond (n : Nat) (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  n > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
def is_multiple_of_code (x : Int) (n : Nat) : Bool :=
  n > 0 ∧ x % (n : Int) = 0

-- Main function definitions
def find_multiple_of (n : Nat) (numbers : List Int) (h_precond : find_multiple_of_precond (n) (numbers)) : List Int :=
  -- !benchmark @start code
  numbers.filter (λ x => is_multiple_of_code x n)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_multiple_of_post (x : Int) (n : Nat) : Prop :=
  n > 0 ∧ ∃ (k : Int), x = k * (n : Int)

-- Postcondition definitions
@[reducible, simp]
def find_multiple_of_postcond (n : Nat) (numbers : List Int) (result: List Int) (h_precond : find_multiple_of_precond (n) (numbers)) : Prop :=
  -- !benchmark @start postcond
  ∀ x, x ∈ result ↔ x ∈ numbers ∧ is_multiple_of_post x n
  -- !benchmark @end postcond


-- Proof content
theorem find_multiple_of_postcond_satisfied (n: Nat) (numbers: List Int) (h_precond : find_multiple_of_precond (n) (numbers)) :
    find_multiple_of_postcond (n) (numbers) (find_multiple_of (n) (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_26090_codeexercises_126090