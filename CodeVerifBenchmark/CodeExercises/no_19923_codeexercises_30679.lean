import Mathlib

namespace no_19923_codeexercises_30679


-- Precondition auxiliary definitions
-- All spectral classes are valid (O, B, A, F, G, K, M)
def valid_spectral_class (s : String) : Prop :=
  s = "O" ∨ s = "B" ∨ s = "A" ∨ s = "F" ∨ s = "G" ∨ s = "K" ∨ s = "M"

-- Precondition definitions
@[reducible, simp]
def count_spectral_classes_precond (stars : List String) : Prop :=
  -- !benchmark @start precond
  ∀ s ∈ stars, valid_spectral_class s
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to count occurrences of each spectral class
def count_classes (stars : List String) : List (String × Nat) :=
  let classes := ["O", "B", "A", "F", "G", "K", "M"]
  classes.map (λ cls => (cls, stars.filter (λ s => s = cls) |>.length))

-- Helper function to filter out zero counts
def filter_nonzero (counts : List (String × Nat)) : List (String × Nat) :=
  counts.filter (λ (_, count) => count > 0)

-- Main function definitions
def count_spectral_classes (stars : List String) (h_precond : count_spectral_classes_precond stars) : List (String × Nat) :=
  -- !benchmark @start code
  let counts := count_classes stars
  filter_nonzero counts
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Define the set of all valid spectral classes
def spectral_classes : List String := ["O", "B", "A", "F", "G", "K", "M"]

-- Helper to count occurrences of a class in the list
def count_class (stars : List String) (cls : String) : Nat :=
  stars.filter (λ s => s = cls) |>.length

-- Helper to check if result contains all spectral classes with correct counts
def result_has_correct_counts (stars : List String) (result : List (String × Nat)) : Prop :=
  ∀ cls ∈ spectral_classes, 
    (∃ entry ∈ result, entry.1 = cls ∧ entry.2 = count_class stars cls) ∧
    (∀ entry ∈ result, entry.1 = cls → entry.2 = count_class stars cls)

-- Helper to check that result only contains valid spectral classes
def result_only_valid_classes (result : List (String × Nat)) : Prop :=
  ∀ entry ∈ result, entry.1 ∈ spectral_classes

-- Helper to check that result has no duplicate classes
def result_no_duplicates (result : List (String × Nat)) : Prop :=
  result.map Prod.fst |>.Nodup

-- Postcondition definitions
@[reducible, simp]
def count_spectral_classes_postcond (stars : List String) (result: List (String × Nat)) (h_precond : count_spectral_classes_precond stars) : Prop :=
  -- !benchmark @start postcond
  result_has_correct_counts stars result ∧
  result_only_valid_classes result ∧
  result_no_duplicates result
  -- !benchmark @end postcond


-- Proof content
theorem count_spectral_classes_postcond_satisfied (stars: List String) (h_precond : count_spectral_classes_precond stars) :
    count_spectral_classes_postcond stars (count_spectral_classes stars h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_19923_codeexercises_30679