import Mathlib

namespace no_2064_codeexercises_102064


-- Precondition definitions
@[reducible, simp]
def find_common_factors_precond (num1 : Nat) (num2 : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to get factors of a number
def get_factors (n : Nat) : List Nat :=
  List.filter (λ x => n % x = 0) (List.range (n + 1) |>.tail? |>.getD [])

-- Main function definitions
def find_common_factors (num1 : Nat) (num2 : Nat) (h_precond : find_common_factors_precond (num1) (num2)) : List Nat :=
  -- !benchmark @start code
  let factors1 := get_factors num1
  let factors2 := get_factors num2
  List.filter (λ x => x ∈ factors2) factors1
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_factor (n : Nat) (x : Nat) : Prop :=
  x > 0 ∧ n % x = 0

def is_common_factor (x : Nat) (num1 : Nat) (num2 : Nat) : Prop :=
  is_factor num1 x ∧ is_factor num2 x

def all_common_factors (num1 : Nat) (num2 : Nat) : Set Nat :=
  {x | is_common_factor x num1 num2}

-- Postcondition definitions
@[reducible, simp]
def find_common_factors_postcond (num1 : Nat) (num2 : Nat) (result: List Nat) (h_precond : find_common_factors_precond (num1) (num2)) : Prop :=
  -- !benchmark @start postcond
  ∀ x, x ∈ result ↔ x ∈ all_common_factors num1 num2
  -- !benchmark @end postcond


-- Proof content
theorem find_common_factors_postcond_satisfied (num1: Nat) (num2: Nat) (h_precond : find_common_factors_precond (num1) (num2)) :
    find_common_factors_postcond (num1) (num2) (find_common_factors (num1) (num2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2064_codeexercises_102064