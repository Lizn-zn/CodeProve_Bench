import Mathlib

namespace no_38519_codeexercises_138519


-- Precondition definitions
@[reducible, simp]
def create_positive_integer_list_precond (num : Nat) : Prop :=
  -- !benchmark @start precond
  num > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def create_positive_integer_list (num : Nat) (h_precond : create_positive_integer_list_precond (num)) : List Nat :=
  -- !benchmark @start code
  match num with
  | 0 => by
    exfalso
    exact Nat.lt_asymm h_precond h_precond
  | n + 1 => List.range' 1 (n + 1) 1
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def range (start : Nat) (stop : Nat) : List Nat :=
  match stop with
  | 0 => []
  | n + 1 => if n + 1 ≤ start then [] else range start n ++ [n + 1]

-- Postcondition definitions
@[reducible, simp]
def create_positive_integer_list_postcond (num : Nat) (result: List Nat) (h_precond : create_positive_integer_list_precond (num)) : Prop :=
  -- !benchmark @start postcond
  result = range 1 (num + 1) ∧ ∀ x ∈ result, x > 0
  -- !benchmark @end postcond


-- Proof content
theorem create_positive_integer_list_postcond_satisfied (num: Nat) (h_precond : create_positive_integer_list_precond (num)) :
    create_positive_integer_list_postcond (num) (create_positive_integer_list (num) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_38519_codeexercises_138519