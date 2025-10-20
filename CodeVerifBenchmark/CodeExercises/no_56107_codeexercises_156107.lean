import Mathlib

namespace no_56107_codeexercises_156107


-- Precondition definitions
@[reducible, simp]
def compare_and_append_precond (list1 : List (Nat × Nat)) (list2 : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  ¬ list1.isEmpty ∧ ¬ list2.isEmpty
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def compare_and_append (list1 : List (Nat × Nat)) (list2 : List (Nat × Nat)) (h_precond : compare_and_append_precond (list1) (list2)) : List Nat :=
  -- !benchmark @start code
  match list1, list2 with
  | [], _ => by
    exfalso
    rcases h_precond with ⟨h1, h2⟩
    simp at h1
  | _, [] => by
    exfalso
    rcases h_precond with ⟨h1, h2⟩
    simp at h2
  | hd1::tl1, hd2::tl2 =>
    let pairs1 := List.flatMap (λ p => [p.1, p.2]) list1
    let pairs2 := List.flatMap (λ p => [p.1, p.2]) list2
    let common := List.filter (λ x => List.elem x pairs2) pairs1
    List.eraseDups common
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def common_elements (list1 : List (Nat × Nat)) (list2 : List (Nat × Nat)) : List Nat :=
  let pairs1 := List.flatMap (λ p => [p.1, p.2]) list1
  let pairs2 := List.flatMap (λ p => [p.1, p.2]) list2
  let common := List.filter (λ x => List.elem x pairs2) pairs1
  List.eraseDups common

-- Postcondition definitions
@[reducible, simp]
def compare_and_append_postcond (list1 : List (Nat × Nat)) (list2 : List (Nat × Nat)) (result: List Nat) (h_precond : compare_and_append_precond (list1) (list2)) : Prop :=
  -- !benchmark @start postcond
  result = common_elements list1 list2
  -- !benchmark @end postcond


-- Proof content
theorem compare_and_append_postcond_satisfied (list1: List (Nat × Nat)) (list2: List (Nat × Nat)) (h_precond : compare_and_append_precond (list1) (list2)) :
    compare_and_append_postcond (list1) (list2) (compare_and_append (list1) (list2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_56107_codeexercises_156107