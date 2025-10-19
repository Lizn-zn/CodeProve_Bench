import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def update_dictionary_values_precond (dictionary : List (String × String)) (key : String) (values : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def concatStrings (strings : List String) : String :=
  strings.foldl (λ acc s => acc ++ s) ""

-- Main function definitions
def update_dictionary_values (dictionary : List (String × String)) (key : String) (values : List String) (h_precond : update_dictionary_values_precond dictionary key values) : List (String × String) :=
  -- !benchmark @start code
  match dictionary.lookup key with
  | some existingValue => 
    let newValue := existingValue ++ (concatStrings values)
    dictionary.map (λ (k, v) => if k = key then (k, newValue) else (k, v))
  | none => 
    let newValue := concatStrings values
    (key, newValue) :: dictionary
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- concatStrings moved to code auxiliary definitions

-- Postcondition definitions
@[reducible, simp]
def update_dictionary_values_postcond (dictionary : List (String × String)) (key : String) (values : List String) (result: List (String × String)) (h_precond : update_dictionary_values_precond dictionary key values) : Prop :=
  -- !benchmark @start postcond
  let existingValue := (dictionary.lookup key).getD ""
  let newValue := existingValue ++ concatStrings values
  result = (dictionary.map (λ (k, v) => if k = key then (k, newValue) else (k, v)))
  -- !benchmark @end postcond


-- Proof content
theorem update_dictionary_values_postcond_satisfied (dictionary: List (String × String)) (key: String) (values: List String) (h_precond : update_dictionary_values_precond dictionary key values) :
    update_dictionary_values_postcond dictionary key values (update_dictionary_values dictionary key values h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof