import Mathlib

namespace no_24198_codeexercises_37257


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def find_max_polar_complex_precond (dictionary : List (String × List Float)) : Prop :=
  -- !benchmark @start precond
  ∀ (key_val : String × List Float), key_val ∈ dictionary → 
    let (_, value) := key_val
    value.length = 2 ∧ value[0]! ≥ 0
  -- !benchmark @end precond


-- Code auxiliary definitions
def find_max_polar_complex_aux (dictionary : List (String × List Float)) : String × List Float :=
  match dictionary with
  | [] => ("", [0, 0])
  | [pair] => pair
  | pair :: rest =>
    let max_rest := find_max_polar_complex_aux rest
    let r_pair := match pair.2 with | [r, _] => r | _ => 0
    let r_max := match max_rest.2 with | [r, _] => r | _ => 0
    if r_pair > r_max then pair else max_rest

-- Main function definitions
def find_max_polar_complex (dictionary : List (String × List Float)) (h_precond : find_max_polar_complex_precond (dictionary)) : String × List Float :=
  -- !benchmark @start code
  find_max_polar_complex_aux dictionary
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def abs_polar (value : List Float) : Float :=
  match value with
  | [r, _] => r
  | _ => 0

def is_max_pair (dictionary : List (String × List Float)) (pair : String × List Float) : Prop :=
  pair ∈ dictionary ∧ 
  ∀ (other : String × List Float), other ∈ dictionary → abs_polar other.2 ≤ abs_polar pair.2

def first_max_pair (dictionary : List (String × List Float)) (pair : String × List Float) : Prop :=
  is_max_pair dictionary pair ∧
  ∀ (other : String × List Float), is_max_pair dictionary other → 
    dictionary.indexOf pair ≤ dictionary.indexOf other

-- Postcondition definitions
@[reducible, simp]
def find_max_polar_complex_postcond (dictionary : List (String × List Float)) (result: String × List Float) (h_precond : find_max_polar_complex_precond (dictionary)) : Prop :=
  -- !benchmark @start postcond
  first_max_pair dictionary result
  -- !benchmark @end postcond


-- Proof content
theorem find_max_polar_complex_postcond_satisfied (dictionary: List (String × List Float)) (h_precond : find_max_polar_complex_precond (dictionary)) :
    find_max_polar_complex_postcond (dictionary) (find_max_polar_complex (dictionary) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_24198_codeexercises_37257