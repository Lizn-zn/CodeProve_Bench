import Mathlib

-- Precondition definitions
@[reducible, simp]
def intersection_of_nested_loops_less_than_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def intersection_of_nested_loops_less_than (n : Nat) (h_precond : intersection_of_nested_loops_less_than_precond n) : List (Nat × Nat) :=
  -- !benchmark @start code
  let pairs := List.range n |>.flatMap (λ i => 
      List.range n |>.map (λ j => (i, j)))
  pairs.filter (λ (i, j) => i < j)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def all_pairs_less_than (n : Nat) : List (Nat × Nat) :=
  List.filter (λ (p : Nat × Nat) => p.1 < p.2) (List.product (List.range n) (List.range n))

-- Postcondition definitions
@[reducible, simp]
def intersection_of_nested_loops_less_than_postcond (n : Nat) (result: List (Nat × Nat)) (h_precond : intersection_of_nested_loops_less_than_precond n) : Prop :=
  -- !benchmark @start postcond
  result = all_pairs_less_than n
  -- !benchmark @end postcond


-- Proof content
theorem intersection_of_nested_loops_less_than_postcond_satisfied (n: Nat) (h_precond : intersection_of_nested_loops_less_than_precond n) :
    intersection_of_nested_loops_less_than_postcond n (intersection_of_nested_loops_less_than n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof