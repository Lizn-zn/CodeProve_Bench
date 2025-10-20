import Mathlib

namespace no_26767_codeexercises_126767


-- Precondition definitions
@[reducible, simp]
def remove_duplicates_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to remove duplicates while preserving order
def remove_duplicates_aux : List Int → List Int → List Int
  | [], acc => acc.reverse
  | x :: xs, acc => 
    if acc.contains x then
      remove_duplicates_aux xs acc
    else
      remove_duplicates_aux xs (x :: acc)

-- Main function definitions
def remove_duplicates (lst : List Int) (h_precond : remove_duplicates_precond (lst)) : List Int :=
  -- !benchmark @start code
  match lst with
  | [] => []
  | _ => remove_duplicates_aux lst []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def List.NoDuplicates (l : List Int) : Prop :=
  ∀ (x : Int), (l.count x ≤ 1)

def List.Permutation (l1 l2 : List Int) : Prop :=
  ∀ (x : Int), l1.count x = l2.count x

-- Postcondition definitions
@[reducible, simp]
def remove_duplicates_postcond (lst : List Int) (result: List Int) (h_precond : remove_duplicates_precond (lst)) : Prop :=
  -- !benchmark @start postcond
  List.NoDuplicates result ∧
  List.Permutation lst result ∧
  ∀ (x : Int), x ∈ result → x ∈ lst
  -- !benchmark @end postcond


-- Proof content
theorem remove_duplicates_postcond_satisfied (lst: List Int) (h_precond : remove_duplicates_precond (lst)) :
    remove_duplicates_postcond (lst) (remove_duplicates (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_26767_codeexercises_126767