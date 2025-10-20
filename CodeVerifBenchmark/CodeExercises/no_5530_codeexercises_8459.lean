import Mathlib

namespace no_5530_codeexercises_8459


-- Precondition definitions
@[reducible, simp]
def range_not_in_membership_precond (range_start : Int) (range_end : Int) (membership_list : List Int) : Prop :=
  -- !benchmark @start precond
  range_start ≤ range_end
  -- !benchmark @end precond


-- Main function definitions
def range_not_in_membership (range_start : Int) (range_end : Int) (membership_list : List Int) (h_precond : range_not_in_membership_precond range_start range_end membership_list) : List Int :=
  -- !benchmark @start code
  let numbers := List.range ((range_end - range_start).toNat) |>.map (λ i => range_start + (i : Int))
  numbers.filter (λ x => ¬(membership_list.contains x))
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def range_not_in_membership_postcond (range_start : Int) (range_end : Int) (membership_list : List Int) (result: List Int) (h_precond : range_not_in_membership_precond range_start range_end membership_list) : Prop :=
  -- !benchmark @start postcond
  ∀ (x : Int), x ∈ result ↔ (range_start ≤ x ∧ x < range_end ∧ x ∉ membership_list)
  -- !benchmark @end postcond


-- Proof content
theorem range_not_in_membership_postcond_satisfied (range_start: Int) (range_end: Int) (membership_list: List Int) (h_precond : range_not_in_membership_precond range_start range_end membership_list) :
    range_not_in_membership_postcond range_start range_end membership_list (range_not_in_membership range_start range_end membership_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_5530_codeexercises_8459