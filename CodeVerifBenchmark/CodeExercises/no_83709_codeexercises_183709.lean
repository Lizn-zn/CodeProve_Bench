import Mathlib

-- Precondition definitions
@[reducible, simp]
def check_books_availability_precond (books_checked_out : List String) (books_returned : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def check_books_availability (books_checked_out : List String) (books_returned : List String) (h_precond : check_books_availability_precond books_checked_out books_returned) : List String :=
  -- !benchmark @start code
  let available_books := books_checked_out.filter (λ book => books_returned.contains book)
  available_books.eraseDups
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def check_books_availability_postcond (books_checked_out : List String) (books_returned : List String) (result: List String) (h_precond : check_books_availability_precond books_checked_out books_returned) : Prop :=
  -- !benchmark @start postcond
  result = books_checked_out.filter (λ book => books_returned.contains book) ∧
  result.Nodup
  -- !benchmark @end postcond


-- Proof content
theorem check_books_availability_postcond_satisfied (books_checked_out: List String) (books_returned: List String) (h_precond : check_books_availability_precond books_checked_out books_returned) :
    check_books_availability_postcond books_checked_out books_returned (check_books_availability books_checked_out books_returned h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof