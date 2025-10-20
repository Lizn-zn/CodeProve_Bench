import Mathlib

namespace no_62238_codeexercises_162238


-- Precondition definitions
@[reducible, simp]
def check_books_precond (librarian_inventory : List String) (patron_list : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the implementation

-- Main function definitions
def check_books (librarian_inventory : List String) (patron_list : List String) (h_precond : check_books_precond librarian_inventory patron_list) : List String :=
  -- !benchmark @start code
  let rec loop (remaining : List String) (unavailable : List String) : List String :=
    match remaining with
    | [] => unavailable.reverse
    | book :: rest =>
      if book ∉ librarian_inventory then
        loop rest (book :: unavailable)
      else
        loop rest unavailable
  loop patron_list []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_unavailable (book : String) (inventory : List String) : Prop :=
  book ∉ inventory

def unavailable_books (requested : List String) (inventory : List String) : List String :=
  requested.filter (λ book => book ∉ inventory)

-- Postcondition definitions
@[reducible, simp]
def check_books_postcond (librarian_inventory : List String) (patron_list : List String) (result: List String) (h_precond : check_books_precond librarian_inventory patron_list) : Prop :=
  -- !benchmark @start postcond
  result = unavailable_books patron_list librarian_inventory
  -- !benchmark @end postcond


-- Proof content
theorem check_books_postcond_satisfied (librarian_inventory: List String) (patron_list: List String) (h_precond : check_books_precond librarian_inventory patron_list) :
    check_books_postcond librarian_inventory patron_list (check_books librarian_inventory patron_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_62238_codeexercises_162238