import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def calculate_range_precond (arr : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the implementation

-- Main function definitions
def calculate_range (arr : List Int) (h_precond : calculate_range_precond (arr)) : Int :=
  -- !benchmark @start code
  match arr with
  | [] => 0
  | h :: t =>
    let max_val := List.foldl (λ acc x => if x > acc then x else acc) h t
    let min_val := List.foldl (λ acc x => if x < acc then x else acc) h t
    max_val - min_val
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def max_of_list (l : List Int) : Option Int :=
  match l with
  | [] => none
  | h :: t => some (List.foldl (λ acc x => if x > acc then x else acc) h t)

def min_of_list (l : List Int) : Option Int :=
  match l with
  | [] => none
  | h :: t => some (List.foldl (λ acc x => if x < acc then x else acc) h t)

-- Postcondition definitions
@[reducible, simp]
def calculate_range_postcond (arr : List Int) (result: Int) (h_precond : calculate_range_precond (arr)) : Prop :=
  -- !benchmark @start postcond
  match max_of_list arr, min_of_list arr with
  | some max_val, some min_val => result = max_val - min_val
  | _, _ => False
  -- !benchmark @end postcond


-- Proof content
theorem calculate_range_postcond_satisfied (arr: List Int) (h_precond : calculate_range_precond (arr)) :
    calculate_range_postcond (arr) (calculate_range (arr) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

