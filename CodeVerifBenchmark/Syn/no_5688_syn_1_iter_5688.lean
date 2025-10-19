import Mathlib

-- Precondition definitions
@[reducible, simp]
def transform_set_to_list_precond (input_set : Set (ℤ × String)) : Prop :=
  -- !benchmark @start precond
  Set.Finite input_set
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
noncomputable def transform_set_to_list (input_set : Set (ℤ × String)) (h_precond : transform_set_to_list_precond (input_set)) : List (ℤ × ℕ) :=
  -- !benchmark @start code
  let h_finite : Set.Finite input_set := h_precond
  let finset : Finset (ℤ × String) := h_finite.toFinset
  let pairs : List (ℤ × String) := finset.toList
  pairs.map (λ (p : ℤ × String) => (p.1, p.2.length))
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def transform_set_to_list_postcond (input_set : Set (ℤ × String)) (result: List (ℤ × ℕ)) (h_precond : transform_set_to_list_precond (input_set)) : Prop :=
  -- !benchmark @start postcond
  ∀ (z : ℤ) (s : String), (z, s) ∈ input_set → (z, s.length) ∈ result ∧
  ∀ (p : ℤ × ℕ), p ∈ result → ∃ (s : String), (p.1, s) ∈ input_set ∧ p.2 = s.length
  -- !benchmark @end postcond


-- Proof content
theorem transform_set_to_list_postcond_satisfied (input_set: Set (ℤ × String)) (h_precond : transform_set_to_list_precond (input_set)) :
    transform_set_to_list_postcond (input_set) (transform_set_to_list (input_set) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof