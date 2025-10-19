import Mathlib

-- Precondition definitions
@[reducible, simp]
def compare_collections_precond (lst : List Nat) (arr : Array Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def list_extra_elements (lst : List Nat) (arr : Array Nat) : List Nat :=
  let arr_set : List Nat := arr.toList
  (lst.filter (λ x => ¬ (arr_set.contains x))).eraseDups

def array_extra_elements (lst : List Nat) (arr : Array Nat) : List Nat :=
  let lst_set : List Nat := lst.eraseDups
  ((arr.toList).filter (λ x => ¬ (lst_set.contains x))).eraseDups

def format_extra_elements (extra : List Nat) : String :=
  match extra with
  | [] => ""
  | _ => s!" {extra}"

-- Main function definitions
def compare_collections (lst : List Nat) (arr : Array Nat) (h_precond : compare_collections_precond (lst) (arr)) : String :=
  -- !benchmark @start code
  let list_extra := list_extra_elements lst arr
  let array_extra := array_extra_elements lst arr
  match (list_extra.isEmpty, array_extra.isEmpty) with
  | (true, true) => "Equal sets"
  | (false, true) => "List has extra elements:" ++ (format_extra_elements list_extra)
  | (true, false) => "Array has extra elements:" ++ (format_extra_elements array_extra)
  | (false, false) => "Both have extra elements"
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- (These are the same as the code auxiliary definitions above)

-- Postcondition definitions
@[reducible, simp]
def compare_collections_postcond (lst : List Nat) (arr : Array Nat) (result: String) (h_precond : compare_collections_precond (lst) (arr)) : Prop :=
  -- !benchmark @start postcond
  let list_extra := list_extra_elements lst arr
  let array_extra := array_extra_elements lst arr
  match (list_extra.isEmpty, array_extra.isEmpty) with
  | (true, true) => result = "Equal sets"
  | (false, true) => result = "List has extra elements:" ++ (format_extra_elements list_extra)
  | (true, false) => result = "Array has extra elements:" ++ (format_extra_elements array_extra)
  | (false, false) => result = "Both have extra elements"
  -- !benchmark @end postcond


-- Proof content
theorem compare_collections_postcond_satisfied (lst: List Nat) (arr: Array Nat) (h_precond : compare_collections_precond (lst) (arr)) :
    compare_collections_postcond (lst) (arr) (compare_collections (lst) (arr) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof