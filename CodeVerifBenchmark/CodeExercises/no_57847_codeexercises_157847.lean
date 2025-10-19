import Mathlib

-- Precondition definitions
@[reducible, simp]
def count_duplicates_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def count_occurrences_in_string (s : String) (c : Char) : Nat :=
  s.foldl (λ count char => if char = c then count + 1 else count) 0

def find_duplicate_chars (s : String) : Finset Char :=
  let chars := s.toList
  let unique_chars := chars.eraseDups
  unique_chars.filter (λ c => count_occurrences_in_string s c > 1) |>.toFinset

-- Main function definitions
def count_duplicates (s : String) (h_precond : count_duplicates_precond (s)) : Nat :=
  -- !benchmark @start code
  let chars := s.toList
  let unique_chars := chars.eraseDups
  let duplicate_set := unique_chars.filter (λ c => count_occurrences_in_string s c > 1) |>.toFinset
  duplicate_set.card
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_occurrences (s : String) (c : Char) : Nat :=
  s.toList.filter (λ x => x = c) |>.length

def is_duplicate (s : String) (c : Char) : Prop :=
  count_occurrences s c > 1

def duplicate_chars (s : String) : Finset Char :=
  (s.toList.toFinset).filter (λ c => count_occurrences s c > 1)

-- Postcondition definitions
@[reducible, simp]
def count_duplicates_postcond (s : String) (result: Nat) (h_precond : count_duplicates_precond (s)) : Prop :=
  -- !benchmark @start postcond
  result = (duplicate_chars s).card
  -- !benchmark @end postcond


-- Proof content
theorem count_duplicates_postcond_satisfied (s: String) (h_precond : count_duplicates_precond (s)) :
    count_duplicates_postcond (s) (count_duplicates (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof