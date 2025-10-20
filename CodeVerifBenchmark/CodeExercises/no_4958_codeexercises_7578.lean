import Mathlib

namespace no_4958_codeexercises_7578


-- Precondition definitions
@[reducible, simp]
def remove_duplicates_precond (lst : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def remove_duplicates_aux (lst : List Nat) : List Nat :=
  match lst with
  | [] => []
  | x :: xs => 
    if x ∈ xs then
      remove_duplicates_aux xs
    else
      x :: remove_duplicates_aux xs

-- Main function definitions
def remove_duplicates (lst : List Nat) (h_precond : remove_duplicates_precond lst) : List Nat :=
  -- !benchmark @start code
  let rec aux : List Nat → List Nat := λ
    | [] => []
    | x :: xs => 
      if x ∈ xs then
        aux xs
      else
        x :: aux xs
  aux lst
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def List.hasNoDuplicates : List Nat → Prop
  | [] => True
  | (x :: xs) => ¬(x ∈ xs) ∧ List.hasNoDuplicates xs

def List.isPermutationOf (l1 l2 : List Nat) : Prop :=
  ∀ x, l1.count x = l2.count x

-- Postcondition definitions
@[reducible, simp]
def remove_duplicates_postcond (lst : List Nat) (result: List Nat) (h_precond : remove_duplicates_precond lst) : Prop :=
  -- !benchmark @start postcond
  List.hasNoDuplicates result ∧ List.isPermutationOf result lst
  -- !benchmark @end postcond


-- Proof content
theorem remove_duplicates_postcond_satisfied (lst: List Nat) (h_precond : remove_duplicates_precond lst) :
    remove_duplicates_postcond lst (remove_duplicates lst h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_4958_codeexercises_7578