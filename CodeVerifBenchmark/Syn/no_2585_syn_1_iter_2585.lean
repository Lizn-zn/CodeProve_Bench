import Mathlib

namespace no_2585_syn_1_iter_2585


-- Precondition definitions
@[reducible, simp]
def convert_nat_set_to_float_list_precond (s : Finset ℕ) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this function

-- Main function definitions
noncomputable def convert_nat_set_to_float_list (s : Finset ℕ) (h_precond : convert_nat_set_to_float_list_precond (s)) : List Float :=
  -- !benchmark @start code
  s.val.map (λ n => Float.ofNat n) |>.toList
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def convert_nat_set_to_float_list_postcond (s : Finset ℕ) (result: List Float) (h_precond : convert_nat_set_to_float_list_precond (s)) : Prop :=
  -- !benchmark @start postcond
  Finset.card s = List.length result ∧
  ∀ (n : ℕ), n ∈ s → (Float.ofNat n) ∈ result ∧
  ∀ (f : Float), f ∈ result → ∃ (n : ℕ), n ∈ s ∧ f = Float.ofNat n
  -- !benchmark @end postcond


-- Proof content
theorem convert_nat_set_to_float_list_postcond_satisfied (s: Finset ℕ) (h_precond : convert_nat_set_to_float_list_precond (s)) :
    convert_nat_set_to_float_list_postcond (s) (convert_nat_set_to_float_list (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2585_syn_1_iter_2585