import Mathlib

namespace no_55063_codeexercises_155063


-- Precondition definitions
@[reducible, simp]
def calculate_garment_price_precond (price : Float) (discount : Float) : Prop :=
  -- !benchmark @start precond
  price ≥ 0 ∧ discount ≥ 0 ∧ discount ≤ 100
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple calculation

-- Main function definitions
def calculate_garment_price (price : Float) (discount : Float) (h_precond : calculate_garment_price_precond (price) (discount)) : Float :=
  -- !benchmark @start code
  price * (1 - discount / 100)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def calculate_garment_price_postcond (price : Float) (discount : Float) (result: Float) (h_precond : calculate_garment_price_precond (price) (discount)) : Prop :=
  -- !benchmark @start postcond
  result = price * (1 - discount / 100) ∧ result ≥ 0
  -- !benchmark @end postcond


-- Proof content
theorem calculate_garment_price_postcond_satisfied (price: Float) (discount: Float) (h_precond : calculate_garment_price_precond (price) (discount)) :
    calculate_garment_price_postcond (price) (discount) (calculate_garment_price (price) (discount) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_55063_codeexercises_155063