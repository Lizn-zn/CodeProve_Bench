import Mathlib

namespace no_93607_codeexercises_193607


-- Precondition definitions
@[reducible, simp]
def get_books_by_category_precond (category : String) (book_dict : List (String × String)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def get_books_by_category_filter (category : String) (book_dict : List (String × String)) : List String :=
  (book_dict.filter (λ book => book.2 = category)).map Prod.fst

-- Main function definitions
def get_books_by_category (category : String) (book_dict : List (String × String)) (h_precond : get_books_by_category_precond (category) (book_dict)) : Option (List String) :=
  -- !benchmark @start code
  if h : ∃ (book : String × String), book ∈ book_dict ∧ book.2 = category then
    some (get_books_by_category_filter category book_dict)
  else
    none
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def get_books_by_category_exists (category : String) (book_dict : List (String × String)) : Prop :=
  ∃ (book : String × String), book ∈ book_dict ∧ book.2 = category

-- Postcondition definitions
@[reducible, simp]
def get_books_by_category_postcond (category : String) (book_dict : List (String × String)) (result: Option (List String)) (h_precond : get_books_by_category_precond (category) (book_dict)) : Prop :=
  -- !benchmark @start postcond
  match result with
  | none => ¬ get_books_by_category_exists category book_dict
  | some books => books = get_books_by_category_filter category book_dict
  -- !benchmark @end postcond


-- Proof content
theorem get_books_by_category_postcond_satisfied (category: String) (book_dict: List (String × String)) (h_precond : get_books_by_category_precond (category) (book_dict)) :
    get_books_by_category_postcond (category) (book_dict) (get_books_by_category (category) (book_dict) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_93607_codeexercises_193607