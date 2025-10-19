import Mathlib

-- Precondition definitions
@[reducible, simp]
def list_intersection_precond (lst1 : List α) (lst2 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- no code_aux needed

-- Main function definitions
def list_intersection [DecidableEq α] (lst1 : List α) (lst2 : List α) (h_precond : list_intersection_precond lst1 lst2) : List α :=
  -- !benchmark @start code
  let rec find_common (l1 : List α) (l2 : List α) : List α :=
    match l1 with
    | [] => []
    | hd :: tl => 
      if hd ∈ l2 then 
        hd :: find_common tl l2
      else 
        find_common tl l2
  find_common lst1 lst2
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def list_intersection_mem (x : α) (lst1 lst2 : List α) : Prop :=
  x ∈ lst1 ∧ x ∈ lst2

-- Postcondition definitions
@[reducible, simp]
def list_intersection_postcond (lst1 : List α) (lst2 : List α) (result: List α) (h_precond : list_intersection_precond lst1 lst2) : Prop :=
  -- !benchmark @start postcond
  ∀ x, x ∈ result ↔ list_intersection_mem x lst1 lst2
  -- !benchmark @end postcond


-- Proof content
theorem list_intersection_postcond_satisfied [DecidableEq α] (lst1: List α) (lst2: List α) (h_precond : list_intersection_precond lst1 lst2) :
    list_intersection_postcond lst1 lst2 (list_intersection lst1 lst2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof