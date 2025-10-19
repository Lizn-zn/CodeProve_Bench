import Mathlib

-- Precondition definitions
@[reducible, simp]
def filter_pairs_by_array_precond (pairs : List (Int × Int)) (arr : Array Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def contains_code (arr : Array Int) (x : Int) : Bool :=
  arr.any (λ y => y == x)

-- Main function definitions
def filter_pairs_by_array (pairs : List (Int × Int)) (arr : Array Int) (h_precond : filter_pairs_by_array_precond (pairs) (arr)) : List Int :=
  -- !benchmark @start code
  match pairs with
  | [] => []
  | (a, b) :: rest => 
    if contains_code arr a then
      b :: filter_pairs_by_array rest arr h_precond
    else
      filter_pairs_by_array rest arr h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def contains_prop (arr : Array Int) (x : Int) : Prop :=
  ∃ (i : Fin arr.size), arr[i] = x

instance (arr : Array Int) (x : Int) : Decidable (contains_prop arr x) :=
  inferInstanceAs (Decidable (∃ (i : Fin arr.size), arr[i] = x))

def filter_pairs (pairs : List (Int × Int)) (arr : Array Int) : List Int :=
  pairs.filterMap (λ (a, b) => if contains_prop arr a then some b else none)

-- Postcondition definitions
@[reducible, simp]
def filter_pairs_by_array_postcond (pairs : List (Int × Int)) (arr : Array Int) (result: List Int) (h_precond : filter_pairs_by_array_precond (pairs) (arr)) : Prop :=
  -- !benchmark @start postcond
  result = filter_pairs pairs arr
  -- !benchmark @end postcond


-- Proof content
theorem filter_pairs_by_array_postcond_satisfied (pairs: List (Int × Int)) (arr: Array Int) (h_precond : filter_pairs_by_array_precond (pairs) (arr)) :
    filter_pairs_by_array_postcond (pairs) (arr) (filter_pairs_by_array (pairs) (arr) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof