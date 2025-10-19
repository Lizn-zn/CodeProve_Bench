import Mathlib

-- Precondition definitions
@[reducible, simp]
def intersected_string_concatenation_nested_ifs_precond (list1 : List String) (list2 : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No additional auxiliary definitions needed beyond what's already provided in postcond_aux

-- Main function definitions
def intersected_string_concatenation_nested_ifs (list1 : List String) (list2 : List String) (h_precond : intersected_string_concatenation_nested_ifs_precond (list1) (list2)) : String :=
  -- !benchmark @start code
  let intersected := list1.filter (λ s => list2.contains s)
  let processed_strings := intersected.map (λ s => 
    s.foldl (λ acc c => 
      match c with
      | 'a' => acc ++ "a"
      | 'b' => acc ++ "bb" 
      | 'c' => acc ++ "ccc"
      | _ => acc
    ) ""
  )
  String.join processed_strings
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def process_char (c : Char) : String :=
  match c with
  | 'a' => "a"
  | 'b' => "bb"
  | 'c' => "ccc"
  | _ => ""

def process_string (s : String) : String :=
  s.foldl (λ acc c => acc ++ process_char c) ""

def intersection (list1 list2 : List String) : List String :=
  list1.filter (λ s => list2.contains s)

def expected_result (list1 list2 : List String) : String :=
  let intersected := intersection list1 list2
  String.join (intersected.map process_string)

-- Postcondition definitions
@[reducible, simp]
def intersected_string_concatenation_nested_ifs_postcond (list1 : List String) (list2 : List String) (result: String) (h_precond : intersected_string_concatenation_nested_ifs_precond (list1) (list2)) : Prop :=
  -- !benchmark @start postcond
  result = expected_result list1 list2
  -- !benchmark @end postcond


-- Proof content
theorem intersected_string_concatenation_nested_ifs_postcond_satisfied (list1: List String) (list2: List String) (h_precond : intersected_string_concatenation_nested_ifs_precond (list1) (list2)) :
    intersected_string_concatenation_nested_ifs_postcond (list1) (list2) (intersected_string_concatenation_nested_ifs (list1) (list2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

