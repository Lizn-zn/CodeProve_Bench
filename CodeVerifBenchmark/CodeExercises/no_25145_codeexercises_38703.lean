import Mathlib

-- Precondition definitions
@[reducible, simp]
def tuple_iteration_precond (sequence : List (String × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def tuple_iteration (sequence : List (String × Nat)) (h_precond : tuple_iteration_precond (sequence)) : IO Unit :=
  -- !benchmark @start code
  sequence.forM (λ (item : String × Nat) => IO.println s!"Name: {item.1}, Price: {item.2}")
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def expected_output (sequence : List (String × Nat)) : List String :=
  sequence.map (λ (item : String × Nat) => s!"Name: {item.1}, Price: {item.2}")

-- Postcondition definitions
@[reducible, simp]
def tuple_iteration_postcond (sequence : List (String × Nat)) (result: IO Unit) (h_precond : tuple_iteration_precond (sequence)) : Prop :=
  -- !benchmark @start postcond
  let output_lines := expected_output sequence
  ∀ (line : String), line ∈ output_lines → IO.println line = result
  -- !benchmark @end postcond


-- Proof content
theorem tuple_iteration_postcond_satisfied (sequence: List (String × Nat)) (h_precond : tuple_iteration_precond (sequence)) :
    tuple_iteration_postcond (sequence) (tuple_iteration (sequence) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof