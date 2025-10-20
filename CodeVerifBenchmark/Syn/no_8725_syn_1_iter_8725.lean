import Mathlib

namespace no_8725_syn_1_iter_8725


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def char_frequencies_precond (arr : Array Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def countOccurrences (arr : Array Char) (c : Char) : Nat :=
  arr.foldl (λ count x => if x = c then count + 1 else count) 0

def getUniqueChars (arr : Array Char) : List Char :=
  arr.toList.eraseDups

-- Main function definitions
def char_frequencies (arr : Array Char) (h_precond : char_frequencies_precond (arr)) : List (Char × Nat) :=
  -- !benchmark @start code
  let uniqueChars := getUniqueChars arr
  uniqueChars.map (λ c => (c, countOccurrences arr c))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def List.uniquePairs (l : List (Char × Nat)) : Prop :=
  ∀ (c : Char), (l.filter (λ p => p.1 = c)).length ≤ 1

def List.containsAllChars (l : List (Char × Nat)) (arr : Array Char) : Prop :=
  ∀ (c : Char), c ∈ arr → ∃ (freq : Nat), (c, freq) ∈ l

def List.correctFrequencies (l : List (Char × Nat)) (arr : Array Char) : Prop :=
  ∀ (c : Char) (freq : Nat), (c, freq) ∈ l → freq = ((arr.toList).filter (λ x => x = c)).length

-- Postcondition definitions
@[reducible, simp]
def char_frequencies_postcond (arr : Array Char) (result: List (Char × Nat)) (h_precond : char_frequencies_precond (arr)) : Prop :=
  -- !benchmark @start postcond
  List.uniquePairs result ∧ 
  List.containsAllChars result arr ∧ 
  List.correctFrequencies result arr
  -- !benchmark @end postcond


-- Proof content
theorem char_frequencies_postcond_satisfied (arr: Array Char) (h_precond : char_frequencies_precond (arr)) :
    char_frequencies_postcond (arr) (char_frequencies (arr) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_8725_syn_1_iter_8725