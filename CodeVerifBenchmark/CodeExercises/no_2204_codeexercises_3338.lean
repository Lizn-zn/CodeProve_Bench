import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_common_factors_precond (num1 : Nat) (num2 : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to check if a number is a factor of another
def isFactorNat (n : Nat) (x : Nat) : Bool :=
  x > 0 && n % x = 0

-- Helper function to check if a number is a common factor of both inputs
def isCommonFactorNat (x : Nat) (num1 : Nat) (num2 : Nat) : Bool :=
  isFactorNat num1 x && isFactorNat num2 x

-- Main function definitions
def find_common_factors (num1 : Nat) (num2 : Nat) (h_precond : find_common_factors_precond (num1) (num2)) : List Nat :=
  -- !benchmark @start code
  let max_num := max num1 num2
  List.filter (λ x => isCommonFactorNat x num1 num2) (List.range (max_num + 1))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def isFactor (n : Nat) (x : Nat) : Prop :=
  x > 0 ∧ n % x = 0

def isCommonFactor (x : Nat) (num1 : Nat) (num2 : Nat) : Prop :=
  isFactor num1 x ∧ isFactor num2 x

-- Postcondition definitions
@[reducible, simp]
def find_common_factors_postcond (num1 : Nat) (num2 : Nat) (result: List Nat) (h_precond : find_common_factors_precond (num1) (num2)) : Prop :=
  -- !benchmark @start postcond
  ∀ x, x ∈ result ↔ isCommonFactor x num1 num2
  -- !benchmark @end postcond


-- Proof content
theorem find_common_factors_postcond_satisfied (num1: Nat) (num2: Nat) (h_precond : find_common_factors_precond (num1) (num2)) :
    find_common_factors_postcond (num1) (num2) (find_common_factors (num1) (num2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

