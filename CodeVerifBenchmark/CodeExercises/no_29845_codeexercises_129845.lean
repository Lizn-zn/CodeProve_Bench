import Mathlib

namespace no_29845_codeexercises_129845


-- Precondition definitions
@[reducible, simp]
def find_duplicates_in_list_precond (list1 : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def find_duplicates_in_list_aux (list1 : List Nat) : Set Nat :=
  let seen : List Nat := []
  let duplicates : List Nat := []
  let rec helper (remaining : List Nat) (seen_acc : List Nat) (dups_acc : List Nat) : List Nat :=
    match remaining with
    | [] => dups_acc
    | x :: xs => 
      if x ∈ seen_acc then
        if x ∈ dups_acc then
          helper xs seen_acc dups_acc
        else
          helper xs seen_acc (x :: dups_acc)
      else
        helper xs (x :: seen_acc) dups_acc
  {x | x ∈ helper list1 [] []}

-- Main function definitions
def find_duplicates_in_list (list1 : List Nat) (h_precond : find_duplicates_in_list_precond (list1)) : Set Nat :=
  -- !benchmark @start code
  find_duplicates_in_list_aux list1
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_occurrences (l : List Nat) (x : Nat) : Nat :=
  l.filter (λ y => y = x) |>.length

def is_duplicate (l : List Nat) (x : Nat) : Prop :=
  count_occurrences l x > 1

-- Postcondition definitions
@[reducible, simp]
def find_duplicates_in_list_postcond (list1 : List Nat) (result: Set Nat) (h_precond : find_duplicates_in_list_precond (list1)) : Prop :=
  -- !benchmark @start postcond
  ∀ (x : Nat), x ∈ result ↔ is_duplicate list1 x
  -- !benchmark @end postcond


-- Proof content
theorem find_duplicates_in_list_postcond_satisfied (list1: List Nat) (h_precond : find_duplicates_in_list_precond (list1)) :
    find_duplicates_in_list_postcond (list1) (find_duplicates_in_list (list1) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_29845_codeexercises_129845