import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_characters_precond (word : String) (character : Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def find_characters (word : String) (character : Char) (h_precond : find_characters_precond (word) (character)) : List Nat :=
  -- !benchmark @start code
  let rec loop (i : Nat) (result : List Nat) (chars : List Char) : List Nat :=
    match chars with
    | [] => result
    | c :: rest => 
      if c = character then
        loop (i + 1) (result ++ [i]) rest
      else
        loop (i + 1) result rest
  loop 0 [] word.toList
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def indices_of_char (s : String) (c : Char) : List Nat :=
  (s.toList.enum.filter (λ ⟨i, ch⟩ => ch = c)).map Prod.fst

-- Postcondition definitions
@[reducible, simp]
def find_characters_postcond (word : String) (character : Char) (result: List Nat) (h_precond : find_characters_precond (word) (character)) : Prop :=
  -- !benchmark @start postcond
  result = indices_of_char word character
  -- !benchmark @end postcond


-- Proof content
theorem find_characters_postcond_satisfied (word: String) (character: Char) (h_precond : find_characters_precond (word) (character)) :
    find_characters_postcond (word) (character) (find_characters (word) (character) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof