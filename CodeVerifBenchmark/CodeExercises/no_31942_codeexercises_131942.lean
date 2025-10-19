import Mathlib

-- Precondition definitions
@[reducible, simp]
def create_nested_tuples_precond (n : Nat) (m : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def create_nested_tuples (n : Nat) (m : Nat) (h_precond : create_nested_tuples_precond (n) (m)) : List (List Nat) :=
  -- !benchmark @start code
  let rec outer_loop (i : Nat) (acc : List (List Nat)) : List (List Nat) :=
    if h : i < n then
      let rec inner_loop (j : Nat) (inner_acc : List Nat) : List Nat :=
        if h' : j < m then
          inner_loop (j + 1) (inner_acc ++ [i * m + j])
        else
          inner_acc
      outer_loop (i + 1) (acc ++ [inner_loop 0 []])
    else
      acc
  outer_loop 0 []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def create_nested_tuples_expected (n : Nat) (m : Nat) : List (List Nat) :=
  List.range n |>.map (λ i => List.range m |>.map (λ j => i * m + j))

-- Postcondition definitions
@[reducible, simp]
def create_nested_tuples_postcond (n : Nat) (m : Nat) (result: List (List Nat)) (h_precond : create_nested_tuples_precond (n) (m)) : Prop :=
  -- !benchmark @start postcond
  result = create_nested_tuples_expected n m
  -- !benchmark @end postcond


-- Proof content
theorem create_nested_tuples_postcond_satisfied (n: Nat) (m: Nat) (h_precond : create_nested_tuples_precond (n) (m)) :
    create_nested_tuples_postcond (n) (m) (create_nested_tuples (n) (m) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof