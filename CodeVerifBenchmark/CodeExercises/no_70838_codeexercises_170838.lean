import Mathlib

-- Precondition definitions
@[reducible, simp]
def intersection_equal_nested_loops_precond (dancer1 : List String) (dancer2 : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def List.elem? (x : String) (l : List String) : Bool :=
  l.any (λ y => x == y)

-- Main function definitions
def intersection_equal_nested_loops (dancer1 : List String) (dancer2 : List String) (h_precond : intersection_equal_nested_loops_precond (dancer1) (dancer2)) : List String :=
  -- !benchmark @start code
  let result : List String := dancer1.filter (λ move1 => dancer2.elem? move1)
  result.dedup
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def intersection_equal_nested_loops_postcond (dancer1 : List String) (dancer2 : List String) (result: List String) (h_precond : intersection_equal_nested_loops_precond (dancer1) (dancer2)) : Prop :=
  -- !benchmark @start postcond
  ∀ (move : String), move ∈ result ↔ (move ∈ dancer1 ∧ move ∈ dancer2) ∧
    (∀ (move' : String), move' ∈ result → move' == move → move' = move) ∧
    (∀ (move' : String), move' ∈ dancer1 → move' ∈ dancer2 → move' ∈ result)
  -- !benchmark @end postcond


-- Proof content
theorem intersection_equal_nested_loops_postcond_satisfied (dancer1: List String) (dancer2: List String) (h_precond : intersection_equal_nested_loops_precond (dancer1) (dancer2)) :
    intersection_equal_nested_loops_postcond (dancer1) (dancer2) (intersection_equal_nested_loops (dancer1) (dancer2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
