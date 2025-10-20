import Mathlib

namespace no_65424_codeexercises_165424


-- Precondition definitions
@[reducible, simp]
def intersection_precond (a : List α) (b : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def intersection [DecidableEq α] (a : List α) (b : List α) (h_precond : intersection_precond a b) : List α :=
  -- !benchmark @start code
  let seen_in_a := a.dedup
  b.filter (λ y => y ∈ seen_in_a) |>.dedup
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def intersection_membership (x : α) (a b result : List α) : Prop :=
  (x ∈ result ↔ x ∈ a ∧ x ∈ b)

-- Postcondition definitions
@[reducible, simp]
def intersection_postcond (a : List α) (b : List α) (result: List α) (h_precond : intersection_precond a b) : Prop :=
  -- !benchmark @start postcond
  ∀ x : α, intersection_membership x a b result
  -- !benchmark @end postcond


-- Proof content
theorem intersection_postcond_satisfied [DecidableEq α] (a: List α) (b: List α) (h_precond : intersection_precond a b) :
    intersection_postcond a b (intersection a b h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_65424_codeexercises_165424