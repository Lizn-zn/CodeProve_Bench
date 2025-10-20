import Mathlib

namespace no_8779_syn_1_iter_8779


-- Precondition definitions
@[reducible, simp]
def generate_ascii_array_precond (c : Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def generate_ascii_array (c : Char) (h_precond : generate_ascii_array_precond (c)) : Array (Array Int) :=
  -- !benchmark @start code
  let ascii_val := c.toNat
  #[mkArray ascii_val ascii_val]
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def generate_ascii_array_postcond (c : Char) (result: Array (Array Int)) (h_precond : generate_ascii_array_precond (c)) : Prop :=
  -- !benchmark @start postcond
  let ascii_val := c.toNat
  result.size = 1 ∧
  (if h : 0 < result.size then
    let first := result[0]
    first.size = ascii_val ∧
    ∀ (i : Fin first.size), first[i] = ascii_val
  else False)
  -- !benchmark @end postcond


-- Proof content
theorem generate_ascii_array_postcond_satisfied (c: Char) (h_precond : generate_ascii_array_precond (c)) :
    generate_ascii_array_postcond (c) (generate_ascii_array (c) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_8779_syn_1_iter_8779