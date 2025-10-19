import Mathlib

-- Precondition definitions
@[reducible, simp]
def print_athlete_combinations_precond (athletes : List String) : Prop :=
  -- !benchmark @start precond
  athletes.length ≥ 2
  -- !benchmark @end precond


-- Code auxiliary definitions
def all_pairs {α : Type} (l : List α) : List (α × α) :=
  match l with
  | [] => []
  | x :: xs => (xs.map (λ y => (x, y))) ++ all_pairs xs

def all_pairs_no_duplicates {α : Type} (l : List α) : List (α × α) :=
  match l with
  | [] => []
  | x :: xs => (xs.map (λ y => (x, y))) ++ all_pairs_no_duplicates xs

def print_combinations (pairs : List (String × String)) : Unit :=
  ()

-- Main function definitions
def print_athlete_combinations (athletes : List String) (h_precond : print_athlete_combinations_precond (athletes)) : Unit :=
  -- !benchmark @start code
  let pairs := all_pairs_no_duplicates athletes
  print_combinations pairs
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def all_pairs_post {α : Type} (l : List α) : List (α × α) :=
  match l with
  | [] => []
  | x :: xs => (xs.map (λ y => (x, y))) ++ all_pairs_post xs

def all_pairs_no_duplicates_post {α : Type} (l : List α) : List (α × α) :=
  match l with
  | [] => []
  | x :: xs => (xs.map (λ y => (x, y))) ++ all_pairs_no_duplicates_post xs

def print_combinations_post (pairs : List (String × String)) : Unit :=
  ()

-- Postcondition definitions
@[reducible, simp]
def print_athlete_combinations_postcond (athletes : List String) (result: Unit) (h_precond : print_athlete_combinations_precond (athletes)) : Prop :=
  -- !benchmark @start postcond
  let pairs := all_pairs_no_duplicates_post athletes
  result = print_combinations_post pairs ∧
    ∀ (a b : String), (a, b) ∈ pairs → a ∈ athletes ∧ b ∈ athletes ∧ a ≠ b ∧
      ∀ (c d : String), (c, d) ∈ pairs → (c = a ∧ d = b) ∨ (c = b ∧ d = a) → False
  -- !benchmark @end postcond


-- Proof content
theorem print_athlete_combinations_postcond_satisfied (athletes: List String) (h_precond : print_athlete_combinations_precond (athletes)) :
    print_athlete_combinations_postcond (athletes) (print_athlete_combinations (athletes) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof