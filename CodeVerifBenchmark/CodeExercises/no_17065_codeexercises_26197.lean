import Mathlib

namespace no_17065_codeexercises_26197


-- Precondition definitions
@[reducible, simp]
def find_characters_precond (s : String) (c : Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_characters (s : String) (c : Char) (h_precond : find_characters_precond (s) (c)) : List Nat :=
  -- !benchmark @start code
  let rec aux (s : List Char) (c : Char) (idx : Nat) : List Nat :=
    match s with
    | [] => []
    | h :: t => 
      if h = c then 
        idx :: aux t c (idx + 1)
      else 
        aux t c (idx + 1)
  aux s.data c 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def indices_of_char (s : String) (c : Char) : List Nat :=
  s.toList.enum.filter (λ (i, ch) => ch = c) |>.map Prod.fst

-- Postcondition definitions
@[reducible, simp]
def find_characters_postcond (s : String) (c : Char) (result: List Nat) (h_precond : find_characters_precond (s) (c)) : Prop :=
  -- !benchmark @start postcond
  result = indices_of_char s c
  -- !benchmark @end postcond


-- Proof content
theorem find_characters_postcond_satisfied (s: String) (c: Char) (h_precond : find_characters_precond (s) (c)) :
    find_characters_postcond (s) (c) (find_characters (s) (c) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_17065_codeexercises_26197