import Mathlib

namespace no_14785_codeexercises_114785


-- Precondition definitions
@[reducible, simp]
def remove_negative_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def remove_negative (numbers : List Int) (h_precond : remove_negative_precond (numbers)) : List Int :=
  -- !benchmark @start code
  numbers.filter (λ x => x ≥ 0)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_non_negative (n : Int) : Prop := n ≥ 0

-- Postcondition definitions
@[reducible, simp]
def remove_negative_postcond (numbers : List Int) (result: List Int) (h_precond : remove_negative_precond (numbers)) : Prop :=
  -- !benchmark @start postcond
  ∀ (x : Int), x ∈ result → is_non_negative x ∧
  ∀ (x : Int), is_non_negative x → (x ∈ numbers ↔ x ∈ result) ∧
  result.length ≤ numbers.length
  -- !benchmark @end postcond


-- Proof content
theorem remove_negative_postcond_satisfied (numbers: List Int) (h_precond : remove_negative_precond (numbers)) :
    remove_negative_postcond (numbers) (remove_negative (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_14785_codeexercises_114785