import Mathlib

namespace no_37727_codeexercises_137727


-- Precondition definitions
@[reducible, simp]
def find_intersection_precond (lst1 : List α) (lst2 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def is_intersection_aux (lst1 lst2 result : List α) : Prop :=
  ∀ x : α, x ∈ result ↔ (x ∈ lst1 ∧ x ∈ lst2) ∧ (∀ y : α, y ∈ result → y = x → x ∈ result)

-- Main function definitions
def find_intersection [DecidableEq α] (lst1 : List α) (lst2 : List α) (h_precond : find_intersection_precond (lst1) (lst2)) : List α :=
  -- !benchmark @start code
  match lst1, lst2 with
  | [], _ => []
  | _, [] => []
  | x :: xs, ys => 
    if x ∈ ys then
      let rest := find_intersection xs ys h_precond
      if x ∈ rest then rest else x :: rest
    else
      find_intersection xs ys h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_intersection_post (lst1 lst2 result : List α) : Prop :=
  ∀ x : α, x ∈ result ↔ (x ∈ lst1 ∧ x ∈ lst2) ∧ (∀ y : α, y ∈ result → y = x → x ∈ result)

-- Postcondition definitions
@[reducible, simp]
def find_intersection_postcond (lst1 : List α) (lst2 : List α) (result: List α) (h_precond : find_intersection_precond (lst1) (lst2)) : Prop :=
  -- !benchmark @start postcond
  is_intersection_post lst1 lst2 result
  -- !benchmark @end postcond


-- Proof content
theorem find_intersection_postcond_satisfied [DecidableEq α] (lst1: List α) (lst2: List α) (h_precond : find_intersection_precond (lst1) (lst2)) :
    find_intersection_postcond (lst1) (lst2) (find_intersection (lst1) (lst2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_37727_codeexercises_137727