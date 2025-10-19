import Mathlib

-- Precondition definitions
@[reducible, simp]
def intersect_lists_precond (list1 : List α) (list2 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def intersect_lists [DecidableEq α] (list1 : List α) (list2 : List α) (h_precond : intersect_lists_precond (list1) (list2)) : List α :=
  -- !benchmark @start code
  match list1, list2 with
  | [], _ => []
  | _, [] => []
  | x::xs, ys => 
    if ys.contains x then
      x :: intersect_lists xs (ys.erase x) h_precond
    else
      intersect_lists xs ys h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def List.elem_count [DecidableEq α] (x : α) (l : List α) : Nat :=
  l.filter (λ y => y == x) |>.length

def List.is_submultiset [DecidableEq α] (l1 l2 : List α) : Prop :=
  ∀ x, List.elem_count x l1 ≤ List.elem_count x l2

-- Postcondition definitions
@[reducible, simp]
def intersect_lists_postcond [DecidableEq α] (list1 : List α) (list2 : List α) (result: List α) (h_precond : intersect_lists_precond (list1) (list2)) : Prop :=
  -- !benchmark @start postcond
  ∀ x, List.elem_count x result = min (List.elem_count x list1) (List.elem_count x list2) ∧
       List.is_submultiset result list1 ∧
       List.is_submultiset result list2
  -- !benchmark @end postcond


-- Proof content
theorem intersect_lists_postcond_satisfied [DecidableEq α] (list1: List α) (list2: List α) (h_precond : intersect_lists_precond (list1) (list2)) :
    intersect_lists_postcond (list1) (list2) (intersect_lists (list1) (list2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof