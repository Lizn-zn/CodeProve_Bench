import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_matching_chars_precond (string : String) (target_char : Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_matching_chars (string : String) (target_char : Char) (h_precond : find_matching_chars_precond (string) (target_char)) : List Nat :=
  -- !benchmark @start code
  let rec loop (s : List Char) (idx : Nat) (acc : List Nat) : List Nat :=
    match s with
    | [] => acc.reverse
    | h :: t => 
      if h = target_char then
        loop t (idx + 1) (idx :: acc)
      else
        loop t (idx + 1) acc
  loop string.data 0 []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def find_matching_chars_indices (s : String) (c : Char) : List Nat :=
  s.toList.enum.filter (λ ⟨_, char⟩ => char = c) |>.map Prod.fst

-- Postcondition definitions
@[reducible, simp]
def find_matching_chars_postcond (string : String) (target_char : Char) (result: List Nat) (h_precond : find_matching_chars_precond (string) (target_char)) : Prop :=
  -- !benchmark @start postcond
  result = find_matching_chars_indices string target_char
  -- !benchmark @end postcond


-- Proof content
theorem find_matching_chars_postcond_satisfied (string: String) (target_char: Char) (h_precond : find_matching_chars_precond (string) (target_char)) :
    find_matching_chars_postcond (string) (target_char) (find_matching_chars (string) (target_char) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

