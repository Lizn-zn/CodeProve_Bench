import Mathlib

-- Precondition definitions
@[reducible, simp]
def modify_tuple_precond (t : List α) (index : Nat) (new_value : α) : Prop :=
  -- !benchmark @start precond
  index < t.length
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def modify_tuple (t : List α) (index : Nat) (new_value : α) (h_precond : modify_tuple_precond (t) (index) (new_value)) : List α :=
  -- !benchmark @start code
  let rec helper (l : List α) (idx : Nat) (current : Nat) : List α :=
      match l with
      | [] => []
      | x :: xs =>
        if current = index then
          new_value :: helper xs idx (current + 1)
        else
          x :: helper xs idx (current + 1)
    helper t index 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def modify_tuple_postcond [Inhabited α] (t : List α) (index : Nat) (new_value : α) (result: List α) (h_precond : modify_tuple_precond (t) (index) (new_value)) : Prop :=
  -- !benchmark @start postcond
  result.length = t.length ∧
  ∀ (i : Nat), i < t.length → 
    if i = index then result.get! i = new_value else result.get! i = t.get! i
  -- !benchmark @end postcond


-- Proof content
theorem modify_tuple_postcond_satisfied [Inhabited α] (t: List α) (index: Nat) (new_value: α) (h_precond : modify_tuple_precond (t) (index) (new_value)) :
    modify_tuple_postcond (t) (index) (new_value) (modify_tuple (t) (index) (new_value) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof