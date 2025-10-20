import Mathlib

namespace no_39768_codeexercises_139768


-- Precondition definitions
@[reducible, simp]
def find_negative_intersection_precond (range1 : List Int) (range2 : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def sorted_insert (x : Int) (l : List Int) : List Int :=
  match l with
  | [] => [x]
  | h :: t => if x ≤ h then x :: l else h :: sorted_insert x t

def insertion_sort (l : List Int) : List Int :=
  match l with
  | [] => []
  | h :: t => sorted_insert h (insertion_sort t)

-- Main function definitions
def find_negative_intersection (range1 : List Int) (range2 : List Int) (h_precond : find_negative_intersection_precond range1 range2) : List Int :=
  -- !benchmark @start code
  let common := range1.filter (λ x => range2.contains x)
  insertion_sort common
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_sorted (l : List Int) : Prop :=
  ∀ i j, i < j → j < l.length → l[i]! ≤ l[j]!

def is_intersection (result : List Int) (range1 range2 : List Int) : Prop :=
  ∀ x, x ∈ result ↔ (x ∈ range1 ∧ x ∈ range2)

-- Postcondition definitions
@[reducible, simp]
def find_negative_intersection_postcond (range1 : List Int) (range2 : List Int) (result: List Int) (h_precond : find_negative_intersection_precond range1 range2) : Prop :=
  -- !benchmark @start postcond
  is_sorted result ∧ is_intersection result range1 range2
  -- !benchmark @end postcond


-- Proof content
theorem find_negative_intersection_postcond_satisfied (range1: List Int) (range2: List Int) (h_precond : find_negative_intersection_precond range1 range2) :
    find_negative_intersection_postcond range1 range2 (find_negative_intersection range1 range2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_39768_codeexercises_139768