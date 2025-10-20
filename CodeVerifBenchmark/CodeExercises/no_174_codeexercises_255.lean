import Mathlib

namespace no_174_codeexercises_255


-- Precondition definitions
@[reducible, simp]
def range_operation_intersection_precond (range_start : Int) (range_end : Int) (set_a : Set Int) (set_b : Set Int) : Prop :=
  -- !benchmark @start precond
  range_start ≤ range_end
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def range_operation_intersection (range_start : Int) (range_end : Int) (set_a : Set Int) (set_b : Set Int) (h_precond : range_operation_intersection_precond (range_start) (range_end) (set_a) (set_b)) : Set Int :=
  -- !benchmark @start code
  { x | x ∈ set_a ∩ set_b ∧ range_start ≤ x ∧ x ≤ range_end }
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def range_operation_intersection_postcond (range_start : Int) (range_end : Int) (set_a : Set Int) (set_b : Set Int) (result: Set Int) (h_precond : range_operation_intersection_precond (range_start) (range_end) (set_a) (set_b)) : Prop :=
  -- !benchmark @start postcond
  result = {x | x ∈ set_a ∧ x ∈ set_b ∧ range_start ≤ x ∧ x ≤ range_end}
  -- !benchmark @end postcond


-- Proof content
theorem range_operation_intersection_postcond_satisfied (range_start: Int) (range_end: Int) (set_a: Set Int) (set_b: Set Int) (h_precond : range_operation_intersection_precond (range_start) (range_end) (set_a) (set_b)) :
    range_operation_intersection_postcond (range_start) (range_end) (set_a) (set_b) (range_operation_intersection (range_start) (range_end) (set_a) (set_b) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_174_codeexercises_255