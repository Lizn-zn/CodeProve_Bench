import Mathlib

namespace no_11074_codeexercises_111074


-- Precondition definitions
@[reducible, simp]
def remove_duplicates_from_dictionary_precond (dictionary : List (String × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- Postcondition auxiliary definitions
def remove_duplicates_from_dictionary_aux (dictionary : List (String × Nat)) : List (String × Nat) :=
  let seen : List Nat := []
  let rec helper (pairs : List (String × Nat)) (seen_so_far : List Nat) : List (String × Nat) :=
    match pairs with
    | [] => []
    | (k, v) :: rest => 
      if v ∈ seen_so_far then
        helper rest seen_so_far
      else
        (k, v) :: helper rest (v :: seen_so_far)
  helper dictionary seen

-- Postcondition definitions
@[reducible, simp]
def remove_duplicates_from_dictionary_postcond (dictionary : List (String × Nat)) (result: List (String × Nat)) (h_precond : remove_duplicates_from_dictionary_precond dictionary) : Prop :=
  -- !benchmark @start postcond
  result = remove_duplicates_from_dictionary_aux dictionary ∧
  ∀ (k : String) (v : Nat), (k, v) ∈ result → (k, v) ∈ dictionary ∧
  ∀ (k' : String) (v' : Nat), (k', v') ∈ result → v = v' → k = k' ∧ v = v'
  -- !benchmark @end postcond

-- Main function definitions
def remove_duplicates_from_dictionary (dictionary : List (String × Nat)) (h_precond : remove_duplicates_from_dictionary_precond dictionary) : List (String × Nat) :=
  -- !benchmark @start code
  let seen : List Nat := []
  let rec helper (pairs : List (String × Nat)) (seen_so_far : List Nat) : List (String × Nat) :=
    match pairs with
    | [] => []
    | (k, v) :: rest => 
      if v ∈ seen_so_far then
        helper rest seen_so_far
      else
        (k, v) :: helper rest (v :: seen_so_far)
  helper dictionary seen
  -- !benchmark @end code

-- Proof content
theorem remove_duplicates_from_dictionary_postcond_satisfied (dictionary: List (String × Nat)) (h_precond : remove_duplicates_from_dictionary_precond dictionary) :
    remove_duplicates_from_dictionary_postcond dictionary (remove_duplicates_from_dictionary dictionary h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_11074_codeexercises_111074