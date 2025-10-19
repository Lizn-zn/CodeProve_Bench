import Mathlib

-- Precondition definitions
@[reducible, simp]
def check_book_status_precond (book_id : Nat) (library : List (Nat × String)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def find_book_status (book_id : Nat) (library : List (Nat × String)) : Option String :=
  library.find? (λ (id_status : Nat × String) => id_status.fst = book_id) |>.map Prod.snd

-- Main function definitions
def check_book_status (book_id : Nat) (library : List (Nat × String)) (h_precond : check_book_status_precond (book_id) (library)) : String :=
  -- !benchmark @start code
  match find_book_status book_id library with
  | some "available" => "Book is available"
  | some "borrowed" => "Book is borrowed"
  | some _ => "Book is not found in the library"  -- This case handles unexpected status values
  | none => "Book is not found in the library"
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_available (book_id : Nat) (library : List (Nat × String)) : Prop :=
  ∃ (status : String), (book_id, status) ∈ library ∧ status = "available"

def is_borrowed (book_id : Nat) (library : List (Nat × String)) : Prop :=
  ∃ (status : String), (book_id, status) ∈ library ∧ status = "borrowed"

def is_not_found (book_id : Nat) (library : List (Nat × String)) : Prop :=
  ¬∃ (status : String), (book_id, status) ∈ library

-- Postcondition definitions
@[reducible, simp]
def check_book_status_postcond (book_id : Nat) (library : List (Nat × String)) (result: String) (h_precond : check_book_status_precond (book_id) (library)) : Prop :=
  -- !benchmark @start postcond
  (result = "Book is available" ∧ is_available book_id library) ∨
  (result = "Book is borrowed" ∧ is_borrowed book_id library) ∨
  (result = "Book is not found in the library" ∧ is_not_found book_id library)
  -- !benchmark @end postcond


-- Proof content
theorem check_book_status_postcond_satisfied (book_id: Nat) (library: List (Nat × String)) (h_precond : check_book_status_precond (book_id) (library)) :
    check_book_status_postcond (book_id) (library) (check_book_status (book_id) (library) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

