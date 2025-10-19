import Mathlib

-- Precondition definitions
@[reducible, simp]
def char_with_index_precond (chars : List Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def enumerate_code (l : List α) : List (α × Nat) :=
  l.zip (List.range l.length)

-- Main function definitions
def char_with_index (chars : List Char) (h_precond : char_with_index_precond (chars)) : List (Char × Nat) :=
  -- !benchmark @start code
  let rec aux : List Char → Nat → List (Char × Nat) := λ chars idx =>
    match chars with
    | [] => []
    | c :: cs => (c, idx) :: aux cs (idx + 1)
  aux chars 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def enumerate_post (l : List α) : List (α × Nat) :=
  l.zip (List.range l.length)

-- Postcondition definitions
@[reducible, simp]
def char_with_index_postcond (chars : List Char) (result: List (Char × Nat)) (h_precond : char_with_index_precond (chars)) : Prop :=
  -- !benchmark @start postcond
  result = enumerate_post chars
  -- !benchmark @end postcond


-- Proof content
theorem char_with_index_postcond_satisfied (chars: List Char) (h_precond : char_with_index_precond (chars)) :
    char_with_index_postcond (chars) (char_with_index (chars) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof