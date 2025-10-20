import Mathlib

namespace no_87651_codeexercises_187651


-- Precondition auxiliary definitions
structure Book where
  pages : Nat

-- Precondition definitions
@[reducible, simp]
def count_books_precond (books : List Book) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the implementation

-- Main function definitions
def count_books (books : List Book) (h_precond : count_books_precond (books)) : Nat :=
  -- !benchmark @start code
  match books with
  | [] => 0
  | b :: bs =>
    if b.pages > 500 then
      1 + count_books bs h_precond
    else
      0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_until_short (books : List Book) : Nat :=
  match books with
  | [] => 0
  | b :: bs => 
    if b.pages > 500 then
      1 + count_until_short bs
    else
      0

-- Postcondition definitions
@[reducible, simp]
def count_books_postcond (books : List Book) (result: Nat) (h_precond : count_books_precond (books)) : Prop :=
  -- !benchmark @start postcond
  result = count_until_short books
  -- !benchmark @end postcond


-- Proof content
theorem count_books_postcond_satisfied (books: List Book) (h_precond : count_books_precond (books)) :
    count_books_postcond (books) (count_books (books) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_87651_codeexercises_187651