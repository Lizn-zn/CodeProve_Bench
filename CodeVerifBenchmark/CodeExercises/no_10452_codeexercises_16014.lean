import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_book_status_precond (books_list : List (String × Bool)) (book_name : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_book_status (books_list : List (String × Bool)) (book_name : String) (h_precond : find_book_status_precond (books_list) (book_name)) : Option Bool :=
  -- !benchmark @start code
  match books_list.find? (λ (book : String × Bool) => book.fst = book_name) with
  | none => none
  | some (_, status) => some status
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def find_book_status_postcond (books_list : List (String × Bool)) (book_name : String) (result: Option Bool) (h_precond : find_book_status_precond (books_list) (book_name)) : Prop :=
  -- !benchmark @start postcond
  match books_list.find? (λ (book : String × Bool) => book.fst = book_name) with
  | none => result = none
  | some (_, status) => result = some status
  -- !benchmark @end postcond


-- Proof content
theorem find_book_status_postcond_satisfied (books_list: List (String × Bool)) (book_name: String) (h_precond : find_book_status_precond (books_list) (book_name)) :
    find_book_status_postcond (books_list) (book_name) (find_book_status (books_list) (book_name) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

