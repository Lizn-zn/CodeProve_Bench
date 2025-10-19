import Mathlib

-- Precondition definitions
@[reducible, simp]
def zip_strings_with_ints_precond (strings : List String) (pairs : List (Int × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def zip_strings_with_ints (strings : List String) (pairs : List (Int × Nat)) (h_precond : zip_strings_with_ints_precond (strings) (pairs)) : List (String × Int) :=
  -- !benchmark @start code
  match strings, pairs with
    | [], _ => []
    | _, [] => []
    | s::ss, (i, _)::ps => (s, i) :: zip_strings_with_ints ss ps h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def zip_strings_with_ints_aux (strings : List String) (pairs : List (Int × Nat)) : List (String × Int) :=
  List.zipWith (λ s p => (s, p.1)) strings pairs

-- Postcondition definitions
@[reducible, simp]
def zip_strings_with_ints_postcond (strings : List String) (pairs : List (Int × Nat)) (result: List (String × Int)) (h_precond : zip_strings_with_ints_precond (strings) (pairs)) : Prop :=
  -- !benchmark @start postcond
  result = zip_strings_with_ints_aux strings pairs
  -- !benchmark @end postcond


-- Proof content
theorem zip_strings_with_ints_postcond_satisfied (strings: List String) (pairs: List (Int × Nat)) (h_precond : zip_strings_with_ints_precond (strings) (pairs)) :
    zip_strings_with_ints_postcond (strings) (pairs) (zip_strings_with_ints (strings) (pairs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

