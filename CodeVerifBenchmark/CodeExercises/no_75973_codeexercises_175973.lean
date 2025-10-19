import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_value_precond (dictionary_list : List (String × α)) (key_to_find : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def get_values_for_key (dictionaries : List (String × α)) (key : String) : List α :=
  dictionaries.filterMap (λ (k, v) => if k = key then some v else none)

-- Main function definitions
def find_value (dictionary_list : List (String × α)) (key_to_find : String) (h_precond : find_value_precond dictionary_list key_to_find) : Option (List α) :=
  -- !benchmark @start code
  let values := get_values_for_key dictionary_list key_to_find
  if values.isEmpty then none else some values
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- (get_values_for_key is already defined above)

-- Postcondition definitions
@[reducible, simp]
def find_value_postcond (dictionary_list : List (String × α)) (key_to_find : String) (result: Option (List α)) (h_precond : find_value_precond dictionary_list key_to_find) : Prop :=
  -- !benchmark @start postcond
  result = some (get_values_for_key dictionary_list key_to_find) ∨
  (result = none ∧ get_values_for_key dictionary_list key_to_find = [])
  -- !benchmark @end postcond


-- Proof content
theorem find_value_postcond_satisfied (dictionary_list: List (String × α)) (key_to_find: String) (h_precond : find_value_precond dictionary_list key_to_find) :
    find_value_postcond dictionary_list key_to_find (find_value dictionary_list key_to_find h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof