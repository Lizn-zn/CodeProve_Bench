import Mathlib

namespace no_64161_codeexercises_164161


-- Precondition definitions
@[reducible, simp]
def intersection_precond (a : List α) (b : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- none


-- Main function definitions
def intersection [DecidableEq α] (a : List α) (b : List α) (h_precond : intersection_precond a b) : List α :=
  -- !benchmark @start code
  List.filter (λ x => x ∈ b) a
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def List.mem_inter (x : α) (a b : List α) : Prop := x ∈ a ∧ x ∈ b

-- Postcondition definitions
@[reducible, simp]
def intersection_postcond (a : List α) (b : List α) (result: List α) (h_precond : intersection_precond a b) : Prop :=
  -- !benchmark @start postcond
  ∀ x, x ∈ result ↔ List.mem_inter x a b
  -- !benchmark @end postcond


-- Proof content
theorem intersection_postcond_satisfied [DecidableEq α] (a: List α) (b: List α) (h_precond : intersection_precond a b) :
    intersection_postcond a b (intersection a b h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_64161_codeexercises_164161