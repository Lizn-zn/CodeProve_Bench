import Mathlib

namespace no_28894_codeexercises_128894


-- Precondition definitions
@[reducible, simp]
def list_intersection_precond (arr1 : List Int) (arr2 : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def dedup (l : List Int) : List Int :=
  match l with
  | [] => []
  | x :: xs => x :: dedup (xs.filter (λ y => y ≠ x))
termination_by l.length
decreasing_by sorry

-- Main function definitions
def list_intersection (arr1 : List Int) (arr2 : List Int) (h_precond : list_intersection_precond arr1 arr2) : List Int :=
  -- !benchmark @start code
  let common := arr1.filter (λ x => arr2.contains x)
  dedup common
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_intersection (arr1 arr2 result : List Int) : Prop :=
  (∀ x, x ∈ result → x ∈ arr1 ∧ x ∈ arr2) ∧
  (∀ x, x ∈ arr1 → x ∈ arr2 → x ∈ result) ∧
  (∀ x, x ∈ result → (result.filter (λ y => y = x)).length = 1)

-- Postcondition definitions
@[reducible, simp]
def list_intersection_postcond (arr1 : List Int) (arr2 : List Int) (result: List Int) (h_precond : list_intersection_precond arr1 arr2) : Prop :=
  -- !benchmark @start postcond
  is_intersection arr1 arr2 result
  -- !benchmark @end postcond


-- Proof content
theorem list_intersection_postcond_satisfied (arr1: List Int) (arr2: List Int) (h_precond : list_intersection_precond arr1 arr2) :
    list_intersection_postcond arr1 arr2 (list_intersection arr1 arr2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_28894_codeexercises_128894