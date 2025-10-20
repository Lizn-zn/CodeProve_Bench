import Mathlib

namespace no_56610_codeexercises_156610


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def check_book_availability_precond (library : List (String × Bool)) (book_name : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the implementation

-- Main function definitions
def check_book_availability (library : List (String × Bool)) (book_name : String) (h_precond : check_book_availability_precond (library) (book_name)) : Bool :=
  -- !benchmark @start code
  match library.find? (λ (entry : String × Bool) => entry.fst = book_name) with
  | some (_, available) => available
  | none => false
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Auxiliary function to check if a book exists in the library
def book_exists (library : List (String × Bool)) (book_name : String) : Bool :=
  library.any (λ (entry : String × Bool) => entry.fst = book_name)

-- Auxiliary function to get the availability status of a book
def get_book_availability (library : List (String × Bool)) (book_name : String) : Prop :=
  ∃ (available : Bool), (book_name, available) ∈ library

-- Postcondition definitions
@[reducible, simp]
def check_book_availability_postcond (library : List (String × Bool)) (book_name : String) (result: Bool) (h_precond : check_book_availability_precond (library) (book_name)) : Prop :=
  -- !benchmark @start postcond
  if book_exists library book_name then
    ∃ (available : Bool), (book_name, available) ∈ library ∧ result = available
  else
    result = false
  -- !benchmark @end postcond


-- Proof content
theorem check_book_availability_postcond_satisfied (library: List (String × Bool)) (book_name: String) (h_precond : check_book_availability_precond (library) (book_name)) :
    check_book_availability_postcond (library) (book_name) (check_book_availability (library) (book_name) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_56610_codeexercises_156610