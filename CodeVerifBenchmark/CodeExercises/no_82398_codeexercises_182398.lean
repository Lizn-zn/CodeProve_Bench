import Mathlib

namespace no_82398_codeexercises_182398


-- Precondition definitions
@[reducible, simp]
def check_discount_precond (age : Nat) (purchase_amount : Float) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this function

-- Main function definitions
def check_discount (age : Nat) (purchase_amount : Float) (h_precond : check_discount_precond (age) (purchase_amount)) : Prod Bool Float :=
  -- !benchmark @start code
  if age < 18 ∧ purchase_amount < 50.0 then
    (true, 5.0)
  else if 18 ≤ age ∧ age ≤ 30 ∧ 50.0 ≤ purchase_amount ∧ purchase_amount ≤ 100.0 then
    (true, 10.0)
  else if age > 30 ∧ purchase_amount > 100.0 then
    (true, 15.0)
  else
    (false, 0.0)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def check_discount_postcond (age : Nat) (purchase_amount : Float) (result : Prod Bool Float) (h_precond : check_discount_precond (age) (purchase_amount)) : Prop :=
  -- !benchmark @start postcond
  let (eligible, discount_percentage) := result
  (age < 18 ∧ purchase_amount < 50.0 → eligible = true ∧ discount_percentage = 5.0) ∧
  (18 ≤ age ∧ age ≤ 30 ∧ 50.0 ≤ purchase_amount ∧ purchase_amount ≤ 100.0 → eligible = true ∧ discount_percentage = 10.0) ∧
  (age > 30 ∧ purchase_amount > 100.0 → eligible = true ∧ discount_percentage = 15.0) ∧
  (¬(age < 18 ∧ purchase_amount < 50.0) ∧ ¬(18 ≤ age ∧ age ≤ 30 ∧ 50.0 ≤ purchase_amount ∧ purchase_amount ≤ 100.0) ∧ ¬(age > 30 ∧ purchase_amount > 100.0) → eligible = false ∧ discount_percentage = 0.0)
  -- !benchmark @end postcond


-- Proof content
theorem check_discount_postcond_satisfied (age : Nat) (purchase_amount : Float) (h_precond : check_discount_precond (age) (purchase_amount)) :
    check_discount_postcond (age) (purchase_amount) (check_discount (age) (purchase_amount) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_82398_codeexercises_182398