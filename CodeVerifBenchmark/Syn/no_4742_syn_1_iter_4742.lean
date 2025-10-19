import Mathlib

-- Precondition definitions
@[reducible, simp]
def split_chars_to_words_precond (chars : Array Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def isWhitespace (c : Char) : Bool :=
  c = ' ' ∨ c = '\t' ∨ c = '\n'

-- Main function definitions
def split_chars_to_words (chars : Array Char) (h_precond : split_chars_to_words_precond (chars)) : List String :=
  -- !benchmark @start code
  let rec helper (i : Nat) (current : List Char) (acc : List String) : List String :=
    if i ≥ chars.size then
      match current.reverse with
      | [] => acc
      | nonEmpty => String.mk nonEmpty :: acc
    else
      let c := chars[i]!
      if isWhitespace c then
        match current.reverse with
        | [] => helper (i + 1) [] acc
        | nonEmpty => helper (i + 1) [] (String.mk nonEmpty :: acc)
      else
        helper (i + 1) (c :: current) acc
  helper 0 [] [] |>.reverse
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def extractWords (chars : Array Char) : List String :=
  let rec helper (i : Nat) (current : List Char) (acc : List String) : List String :=
    if i ≥ chars.size then
      match current.reverse with
      | [] => acc
      | nonEmpty => String.mk nonEmpty :: acc
    else
      let c := chars[i]!
      if isWhitespace c then
        match current.reverse with
        | [] => helper (i + 1) [] acc
        | nonEmpty => helper (i + 1) [] (String.mk nonEmpty :: acc)
      else
        helper (i + 1) (c :: current) acc
  helper 0 [] [] |>.reverse

-- Postcondition definitions
@[reducible, simp]
def split_chars_to_words_postcond (chars : Array Char) (result: List String) (h_precond : split_chars_to_words_precond (chars)) : Prop :=
  -- !benchmark @start postcond
  result = extractWords chars
  -- !benchmark @end postcond


-- Proof content
theorem split_chars_to_words_postcond_satisfied (chars: Array Char) (h_precond : split_chars_to_words_precond (chars)) :
    split_chars_to_words_postcond (chars) (split_chars_to_words (chars) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof