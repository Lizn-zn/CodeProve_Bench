import Mathlib

namespace no_6676_codeexercises_106676


-- Precondition definitions
@[reducible, simp]
def sort_list_of_strings_precond (lst : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def sort_list_of_strings (lst : List String) (h_precond : sort_list_of_strings_precond (lst)) : List String :=
  -- !benchmark @start code
  let sorted := lst.toArray.qsort (λ a b => a ≤ b)
  sorted.toList
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def Sorted (lst : List String) : Prop :=
  ∀ i j : Nat, i < j → j < lst.length → lst[i]! ≤ lst[j]!

def IsPermutation (lst result : List String) : Prop :=
  ∀ s : String, lst.count s = result.count s

-- Postcondition definitions
@[reducible, simp]
def sort_list_of_strings_postcond (lst : List String) (result: List String) (h_precond : sort_list_of_strings_precond (lst)) : Prop :=
  -- !benchmark @start postcond
  Sorted result ∧ IsPermutation lst result
  -- !benchmark @end postcond


-- Proof content
theorem sort_list_of_strings_postcond_satisfied (lst: List String) (h_precond : sort_list_of_strings_precond (lst)) :
    sort_list_of_strings_postcond (lst) (sort_list_of_strings (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_6676_codeexercises_106676