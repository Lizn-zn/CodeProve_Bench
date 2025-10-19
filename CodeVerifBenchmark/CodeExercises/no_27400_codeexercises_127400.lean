import Mathlib

-- Precondition definitions
@[reducible, simp]
def create_tuple_precond (index : Nat) (value : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def create_tuple (index : Nat) (value : String) (h_precond : create_tuple_precond (index) (value)) : List String :=
  -- !benchmark @start code
  let result := List.replicate (index + 1) ""
  result.set index value
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def create_tuple_length (index : Nat) : Nat := index + 1

def create_tuple_at_index (index : Nat) (value : String) (result : List String) : Prop :=
  match result.get? index with
  | some v => v = value
  | none => False

def create_tuple_empty_elsewhere (index : Nat) (result : List String) : Prop :=
  ∀ i, i < result.length → i ≠ index → result.get? i = some ""

-- Postcondition definitions
@[reducible, simp]
def create_tuple_postcond (index : Nat) (value : String) (result: List String) (h_precond : create_tuple_precond (index) (value)) : Prop :=
  -- !benchmark @start postcond
  result.length = create_tuple_length index ∧
  create_tuple_at_index index value result ∧
  create_tuple_empty_elsewhere index result
  -- !benchmark @end postcond


-- Proof content
theorem create_tuple_postcond_satisfied (index: Nat) (value: String) (h_precond : create_tuple_precond (index) (value)) :
    create_tuple_postcond (index) (value) (create_tuple (index) (value) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof