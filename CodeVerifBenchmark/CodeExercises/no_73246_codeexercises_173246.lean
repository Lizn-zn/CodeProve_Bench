import Mathlib

namespace no_73246_codeexercises_173246


-- Precondition definitions
@[reducible, simp]
def find_not_equal_index_precond (elements : List (Nat ⊕ String)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/--
  Helper function to check if a Nat ⊕ String element matches a given index.
  For Sum.inl (Nat), checks if the number equals the index.
  For Sum.inr (String), checks if the string equals the string representation of the index.
-/
def element_matches_index : Nat ⊕ String → Nat → Bool
  | Sum.inl n, idx => n = idx
  | Sum.inr s, idx => s = toString idx

-- Main function definitions
def find_not_equal_index (elements : List (Nat ⊕ String)) (h_precond : find_not_equal_index_precond (elements)) : Int :=
  -- !benchmark @start code
  let rec loop (lst : List (Nat ⊕ String)) (idx : Nat) : Int :=
    match lst with
    | [] => -1
    | x :: xs => 
      if element_matches_index x idx then
        loop xs (idx + 1)
      else
        idx
  loop elements 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/--
  `find_not_equal_index_aux` defines the core logic for finding the first index where an element
  doesn't match its index, or returns -1 if all elements match.
-/
def find_not_equal_index_aux : List (Nat ⊕ String) → Nat → Int
  | [], _ => -1
  | (Sum.inl n :: rest), idx => 
    if n = idx then find_not_equal_index_aux rest (idx + 1) else idx
  | (Sum.inr s :: rest), idx => 
    if s = toString idx then find_not_equal_index_aux rest (idx + 1) else idx

-- Postcondition definitions
@[reducible, simp]
def find_not_equal_index_postcond (elements : List (Nat ⊕ String)) (result: Int) (h_precond : find_not_equal_index_precond (elements)) : Prop :=
  -- !benchmark @start postcond
  result = find_not_equal_index_aux elements 0
  -- !benchmark @end postcond


-- Proof content
theorem find_not_equal_index_postcond_satisfied (elements: List (Nat ⊕ String)) (h_precond : find_not_equal_index_precond (elements)) :
    find_not_equal_index_postcond (elements) (find_not_equal_index (elements) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_73246_codeexercises_173246