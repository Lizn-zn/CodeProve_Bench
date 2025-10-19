import Mathlib

-- Precondition definitions
@[reducible, simp]
def remove_unavailable_books_precond (books : List String) (unavailable_books : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the implementation

-- Main function definitions
def remove_unavailable_books (books : List String) (unavailable_books : List String) (h_precond : remove_unavailable_books_precond (books) (unavailable_books)) : Prod (List String) Nat :=
  -- !benchmark @start code
  let filtered_books := books.filter (λ book => ¬ unavailable_books.contains book)
  let removed_count := books.length - filtered_books.length
  Prod.mk filtered_books removed_count
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_removed (books : List String) (unavailable_books : List String) : Nat :=
  books.filter (λ book => unavailable_books.contains book) |>.length

def remove_unavailable (books : List String) (unavailable_books : List String) : List String :=
  books.filter (λ book => ¬ unavailable_books.contains book)

-- Postcondition definitions
@[reducible, simp]
def remove_unavailable_books_postcond (books : List String) (unavailable_books : List String) (result: Prod (List String) Nat) (h_precond : remove_unavailable_books_precond (books) (unavailable_books)) : Prop :=
  -- !benchmark @start postcond
  let (result_books, result_count) := result
  result_books = remove_unavailable books unavailable_books ∧
  result_count = count_removed books unavailable_books
  -- !benchmark @end postcond


-- Proof content
theorem remove_unavailable_books_postcond_satisfied (books: List String) (unavailable_books: List String) (h_precond : remove_unavailable_books_precond (books) (unavailable_books)) :
    remove_unavailable_books_postcond (books) (unavailable_books) (remove_unavailable_books (books) (unavailable_books) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof