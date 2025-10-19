import Mathlib

-- Precondition definitions
@[reducible, simp]
def print_artists_with_long_names_precond (artists : List String) (min_length : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- no code_aux needed

-- Main function definitions
def print_artists_with_long_names (artists : List String) (min_length : Nat) (h_precond : print_artists_with_long_names_precond artists min_length) : IO Unit :=
  -- !benchmark @start code
  do
    let filtered_artists := artists.filter (λ artist => artist.length ≥ min_length)
    filtered_artists.forM (λ artist => IO.println artist)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def print_artists_with_long_names_postcond (artists : List String) (min_length : Nat) (result: IO Unit) (h_precond : print_artists_with_long_names_precond artists min_length) : Prop :=
  -- !benchmark @start postcond
  ∀ (artist : String), artist ∈ artists → String.length artist ≥ min_length → IO.println artist = pure ()
  -- !benchmark @end postcond


-- Proof content
theorem print_artists_with_long_names_postcond_satisfied (artists: List String) (min_length: Nat) (h_precond : print_artists_with_long_names_precond artists min_length) :
    print_artists_with_long_names_postcond artists min_length (print_artists_with_long_names artists min_length h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof