import Mathlib

-- Precondition definitions
@[reducible, simp]
def remove_duplicates_from_nested_list_precond (nested_list : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def remove_duplicates_from_nested_list (nested_list : List (List Nat)) (h_precond : remove_duplicates_from_nested_list_precond (nested_list)) : List (List Nat) :=
  -- !benchmark @start code
  nested_list.map λ inner_list => inner_list.dedup
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def remove_duplicates_from_nested_list_postcond_aux (l : List Nat) : List Nat :=
  l.dedup

def remove_duplicates_from_nested_list_postcond_aux' (l : List (List Nat)) : List (List Nat) :=
  l.map remove_duplicates_from_nested_list_postcond_aux

-- Postcondition definitions
@[reducible, simp]
def remove_duplicates_from_nested_list_postcond (nested_list : List (List Nat)) (result: List (List Nat)) (h_precond : remove_duplicates_from_nested_list_precond (nested_list)) : Prop :=
  -- !benchmark @start postcond
  result = remove_duplicates_from_nested_list_postcond_aux' nested_list
  -- !benchmark @end postcond


-- Proof content
theorem remove_duplicates_from_nested_list_postcond_satisfied (nested_list: List (List Nat)) (h_precond : remove_duplicates_from_nested_list_precond (nested_list)) :
    remove_duplicates_from_nested_list_postcond (nested_list) (remove_duplicates_from_nested_list (nested_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

