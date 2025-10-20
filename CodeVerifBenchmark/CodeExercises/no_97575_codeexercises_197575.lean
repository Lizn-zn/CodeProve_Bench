import Mathlib

namespace no_97575_codeexercises_197575


-- Precondition definitions
@[reducible, simp]
def remove_duplicates_precond (animal_list : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to remove duplicates while preserving order
def remove_duplicates_aux : List String → List String → List String
  | [], acc => acc.reverse
  | x::xs, acc => 
    if x ∈ acc then 
      remove_duplicates_aux xs acc 
    else 
      remove_duplicates_aux xs (x::acc)

-- Alternative implementation using Lean's dedup function
def remove_duplicates_simple (animal_list : List String) : List String :=
  animal_list.dedup

-- Main function definitions
def remove_duplicates (animal_list : List String) (h_precond : remove_duplicates_precond (animal_list)) : List String :=
  -- !benchmark @start code
  let rec aux : List String → List String → List String :=
    λ
    | [], acc => acc.reverse
    | x::xs, acc => 
      if x ∈ acc then 
        aux xs acc 
      else 
        aux xs (x::acc)
  aux animal_list []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def List.hasNoDuplicates (l : List String) : Prop :=
  ∀ (x : String), x ∈ l → l.count x = 1

def List.isPermutationOf (l1 l2 : List String) : Prop :=
  ∀ (x : String), l1.count x = l2.count x

-- Postcondition definitions
@[reducible, simp]
def remove_duplicates_postcond (animal_list : List String) (result: List String) (h_precond : remove_duplicates_precond (animal_list)) : Prop :=
  -- !benchmark @start postcond
  List.hasNoDuplicates result ∧ List.isPermutationOf result animal_list
  -- !benchmark @end postcond


-- Proof content
theorem remove_duplicates_postcond_satisfied (animal_list: List String) (h_precond : remove_duplicates_precond (animal_list)) :
    remove_duplicates_postcond (animal_list) (remove_duplicates (animal_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_97575_codeexercises_197575