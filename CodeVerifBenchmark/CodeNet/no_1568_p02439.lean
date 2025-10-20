import Mathlib

namespace no_1568_p02439


-- Precondition definitions
@[reducible, simp]
def minMax_precond (a : Int) (b : Int) (c : Int) : Prop :=
  -- !benchmark @start precond
  -- The three integers must be within the specified range
  -1000000000 ≤ a ∧ a ≤ 1000000000 ∧
  -1000000000 ≤ b ∧ b ≤ 1000000000 ∧
  -1000000000 ≤ c ∧ c ≤ 1000000000
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to find minimum of two integers
def min2 (x y : Int) : Int :=
  if x ≤ y then x else y

-- Helper function to find maximum of two integers
def max2 (x y : Int) : Int :=
  if x ≥ y then x else y

-- Helper function to find minimum of three integers
def min3 (x y z : Int) : Int :=
  min2 (min2 x y) z

-- Helper function to find maximum of three integers
def max3 (x y z : Int) : Int :=
  max2 (max2 x y) z

-- Main function definitions
def minMax (a : Int) (b : Int) (c : Int) (h_precond : minMax_precond (a) (b) (c)) : Int × Int :=
  -- !benchmark @start code
  let minVal := min3 a b c
    let maxVal := max3 a b c
    (minVal, maxVal)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def minMax_postcond (a : Int) (b : Int) (c : Int) (result: Int × Int) (h_precond : minMax_precond (a) (b) (c)) : Prop :=
  -- !benchmark @start postcond
  -- result.1 is the minimum of a, b, c
  -- result.2 is the maximum of a, b, c
  let min := result.1
  let max := result.2
  -- min is less than or equal to all three values
  min ≤ a ∧ min ≤ b ∧ min ≤ c ∧
  -- min equals at least one of the three values
  (min = a ∨ min = b ∨ min = c) ∧
  -- max is greater than or equal to all three values
  max ≥ a ∧ max ≥ b ∧ max ≥ c ∧
  -- max equals at least one of the three values
  (max = a ∨ max = b ∨ max = c)
  -- !benchmark @end postcond


-- Proof content
theorem minMax_postcond_satisfied (a: Int) (b: Int) (c: Int) (h_precond : minMax_precond (a) (b) (c)) :
    minMax_postcond (a) (b) (c) (minMax (a) (b) (c) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1568_p02439