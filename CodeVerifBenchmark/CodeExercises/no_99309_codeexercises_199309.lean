import Mathlib

namespace no_99309_codeexercises_199309


-- Precondition definitions
@[reducible, simp]
def intersection_looping_strings_precond (string1 : String) (string2 : String) : Prop :=
  -- !benchmark @start precond
  ¬string1.isEmpty ∧ ¬string2.isEmpty
  -- !benchmark @end precond


-- Code auxiliary definitions
def countOccurrences (s : String) (c : Char) : Nat :=
  (s.toList.filter (λ x => x = c)).length

def minOccurrences (s1 s2 : String) (c : Char) : Nat :=
  min (countOccurrences s1 c) (countOccurrences s2 c)

def buildIntersection (s1 s2 : String) : String :=
  let chars1 := s1.toList
  let chars2 := s2.toList
  let allChars := chars1.union chars2
  let result := allChars.foldl (λ acc c => 
    let count := minOccurrences s1 s2 c
    acc ++ (List.replicate count c)) []
  ⟨result⟩

-- Main function definitions
def intersection_looping_strings (string1 : String) (string2 : String) (h_precond : intersection_looping_strings_precond string1 string2) : String :=
  -- !benchmark @start code
  if h : string1.isEmpty ∨ string2.isEmpty then
    have : ¬intersection_looping_strings_precond string1 string2 := by
      intro h'
      rcases h' with ⟨h1, h2⟩
      rcases h with (h_empty1 | h_empty2)
      · exact h1 h_empty1
      · exact h2 h_empty2
    absurd h_precond this
  else
    let result := buildIntersection string1 string2
    result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def isIntersection (s1 s2 result : String) : Prop :=
  ∀ (c : Char), c ∈ result.toList ↔ (c ∈ s1.toList ∧ c ∈ s2.toList) ∧ 
    (result.toList.filter (λ x => x = c)).length = min 
      ((s1.toList.filter (λ x => x = c)).length) 
      ((s2.toList.filter (λ x => x = c)).length)

-- Postcondition definitions
@[reducible, simp]
def intersection_looping_strings_postcond (string1 : String) (string2 : String) (result: String) (h_precond : intersection_looping_strings_precond string1 string2) : Prop :=
  -- !benchmark @start postcond
  isIntersection string1 string2 result
  -- !benchmark @end postcond


-- Proof content
theorem intersection_looping_strings_postcond_satisfied (string1: String) (string2: String) (h_precond : intersection_looping_strings_precond string1 string2) :
    intersection_looping_strings_postcond string1 string2 (intersection_looping_strings string1 string2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_99309_codeexercises_199309