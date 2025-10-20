import Mathlib

namespace no_4812_codeexercises_104812


-- Precondition definitions
@[reducible, simp]
def remove_duplicates_precond (numbers : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def remove_duplicates_aux (numbers : List Nat) : List Nat :=
  match numbers with
  | [] => []
  | x :: xs => 
    if x ∈ remove_duplicates_aux xs then
      remove_duplicates_aux xs
    else
      x :: remove_duplicates_aux xs

-- Main function definitions
def remove_duplicates (numbers : List Nat) (h_precond : remove_duplicates_precond numbers) : List Nat :=
  -- !benchmark @start code
  match numbers with
  | [] => []
  | x :: xs => 
    let rest := remove_duplicates xs (by
      simp [remove_duplicates_precond])
    if x ∈ rest then
      rest
    else
      x :: rest
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def remove_duplicates_postcond_aux (numbers result : List Nat) : Prop :=
  ∀ x, x ∈ result ↔ x ∈ numbers ∧ (result.filter (λ y => y = x)).length = 1

-- Postcondition definitions
@[reducible, simp]
def remove_duplicates_postcond (numbers : List Nat) (result: List Nat) (h_precond : remove_duplicates_precond numbers) : Prop :=
  -- !benchmark @start postcond
  remove_duplicates_postcond_aux numbers result
  -- !benchmark @end postcond


-- Proof content
theorem remove_duplicates_postcond_satisfied (numbers: List Nat) (h_precond : remove_duplicates_precond numbers) :
    remove_duplicates_postcond numbers (remove_duplicates numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_4812_codeexercises_104812