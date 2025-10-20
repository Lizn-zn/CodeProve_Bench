import Mathlib

namespace no_23520_codeexercises_36184


-- Precondition definitions
@[reducible, simp]
def intersect_intervals_precond (interval1 : Int × Int) (interval2 : Int × Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed for this implementation

-- Main function definitions
def intersect_intervals (interval1 : Int × Int) (interval2 : Int × Int) (h_precond : intersect_intervals_precond (interval1) (interval2)) : List Int :=
  -- !benchmark @start code
  if interval1.1 ≤ interval1.2 ∧ interval2.1 ≤ interval2.2 then
    let start := max interval1.1 interval2.1
    let end_ := min interval1.2 interval2.2
    if start ≤ end_ then
      [start, end_]
    else
      []
  else
    []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_interval (interval : Int × Int) : Prop :=
  interval.1 ≤ interval.2

def interval_intersection (a b : Int × Int) : List Int :=
  if h : max a.1 b.1 ≤ min a.2 b.2 then
    [max a.1 b.1, min a.2 b.2]
  else
    []

-- Postcondition definitions
@[reducible, simp]
def intersect_intervals_postcond (interval1 : Int × Int) (interval2 : Int × Int) (result: List Int) (h_precond : intersect_intervals_precond (interval1) (interval2)) : Prop :=
  -- !benchmark @start postcond
  is_interval interval1 ∧ is_interval interval2 ∧
    result = interval_intersection interval1 interval2
  -- !benchmark @end postcond


-- Proof content
theorem intersect_intervals_postcond_satisfied (interval1: Int × Int) (interval2: Int × Int) (h_precond : intersect_intervals_precond (interval1) (interval2)) :
    intersect_intervals_postcond (interval1) (interval2) (intersect_intervals (interval1) (interval2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_23520_codeexercises_36184