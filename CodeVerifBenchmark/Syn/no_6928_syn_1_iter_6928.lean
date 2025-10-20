import Mathlib

namespace no_6928_syn_1_iter_6928


-- Precondition definitions
@[reducible, simp]
def char_code_sums_to_floats_precond (c : Char) (s : Set Int) : Prop :=
  -- !benchmark @start precond
  Set.Finite s
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided in postcond_aux

-- Main function definitions
noncomputable def char_code_sums_to_floats (c : Char) (s : Set Int) (h_precond : char_code_sums_to_floats_precond (c) (s)) : List Float :=
  -- !benchmark @start code
  let code : Int := c.toNat
  let sorted_s : List Int := (Set.Finite.toFinset h_precond).sort (λ a b => a ≤ b)
  sorted_s.map (λ x => Float.ofInt (code + x))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
noncomputable def sorted_ints (s : Set Int) (h_finite : Set.Finite s) : List Int :=
  let finite_set : Finset Int := Set.Finite.toFinset h_finite
  finite_set.sort (λ a b => a ≤ b)

noncomputable def compute_expected (c : Char) (s : Set Int) (h_finite : Set.Finite s) : List Float :=
  let code : Int := c.toNat
  (sorted_ints s h_finite).map (λ x => Float.ofInt (code + x))

-- Postcondition definitions
@[reducible, simp]
def char_code_sums_to_floats_postcond (c : Char) (s : Set Int) (result: List Float) (h_precond : char_code_sums_to_floats_precond (c) (s)) : Prop :=
  -- !benchmark @start postcond
  result = compute_expected c s h_precond
  -- !benchmark @end postcond


-- Proof content
theorem char_code_sums_to_floats_postcond_satisfied (c: Char) (s: Set Int) (h_precond : char_code_sums_to_floats_precond (c) (s)) :
    char_code_sums_to_floats_postcond (c) (s) (char_code_sums_to_floats (c) (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_6928_syn_1_iter_6928