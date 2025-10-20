import Mathlib

namespace no_34127_codeexercises_134127


-- Precondition definitions
@[reducible, simp]
def intersection_precond (range_start : Int) (range_end : Int) (negative_integers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def intersection (range_start : Int) (range_end : Int) (negative_integers : List Int) (h_precond : intersection_precond range_start range_end negative_integers) : List Int :=
  -- !benchmark @start code
  let filtered := negative_integers.filter (λ x => range_start ≤ x ∧ x ≤ range_end ∧ x < 0)
  filtered
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_negative (x : Int) : Prop := x < 0

def in_range (x : Int) (start end_ : Int) : Prop := start ≤ x ∧ x ≤ end_

def is_intersection (result : List Int) (range_start range_end : Int) (negative_integers : List Int) : Prop :=
  ∀ x : Int, x ∈ result ↔ (x ∈ negative_integers ∧ in_range x range_start range_end ∧ is_negative x)

-- Postcondition definitions
@[reducible, simp]
def intersection_postcond (range_start : Int) (range_end : Int) (negative_integers : List Int) (result: List Int) (h_precond : intersection_precond range_start range_end negative_integers) : Prop :=
  -- !benchmark @start postcond
  is_intersection result range_start range_end negative_integers
  -- !benchmark @end postcond


-- Proof content
theorem intersection_postcond_satisfied (range_start: Int) (range_end: Int) (negative_integers: List Int) (h_precond : intersection_precond range_start range_end negative_integers) :
    intersection_postcond range_start range_end negative_integers (intersection range_start range_end negative_integers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_34127_codeexercises_134127