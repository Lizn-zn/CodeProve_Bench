import Mathlib

namespace no_46024_codeexercises_146024


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def find_abnormal_values_precond (data : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to flatten a list of lists and filter abnormal values
def flatten_and_filter (data : List (List Nat)) : List Nat :=
  data.foldl (λ acc inner_list => acc ++ inner_list.filter (λ x => x < 36 ∨ x > 42)) []

-- Helper function to remove duplicates while preserving order
def remove_duplicates (l : List Nat) : List Nat :=
  l.foldl (λ acc x => if x ∈ acc then acc else acc ++ [x]) []

-- Main function definitions
def find_abnormal_values (data : List (List Nat)) (h_precond : find_abnormal_values_precond (data)) : List Nat :=
  -- !benchmark @start code
  -- First flatten the nested list and filter out abnormal values
  let flattened := flatten_and_filter data
  -- Then remove duplicates to get the final result
  remove_duplicates flattened
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Define what constitutes an abnormal value
def is_abnormal (value : Nat) : Prop :=
  value < 36 ∨ value > 42

-- Helper to check if a value in nested list is abnormal
def is_abnormal_in_data (data : List (List Nat)) (value : Nat) : Prop :=
  ∃ (inner_list : List Nat), inner_list ∈ data ∧ value ∈ inner_list ∧ is_abnormal value

-- Helper to ensure all abnormal values are included
def all_abnormal_values_included (data : List (List Nat)) (result : List Nat) : Prop :=
  ∀ (value : Nat), is_abnormal_in_data data value → value ∈ result

-- Helper to ensure no extra values are included
def no_extra_values (data : List (List Nat)) (result : List Nat) : Prop :=
  ∀ (value : Nat), value ∈ result → is_abnormal_in_data data value

-- Postcondition definitions
@[reducible, simp]
def find_abnormal_values_postcond (data : List (List Nat)) (result: List Nat) (h_precond : find_abnormal_values_precond (data)) : Prop :=
  -- !benchmark @start postcond
  -- The result should contain exactly all abnormal values from the data
  all_abnormal_values_included data result ∧ no_extra_values data result
  -- !benchmark @end postcond


-- Proof content
theorem find_abnormal_values_postcond_satisfied (data: List (List Nat)) (h_precond : find_abnormal_values_precond (data)) :
    find_abnormal_values_postcond (data) (find_abnormal_values (data) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_46024_codeexercises_146024