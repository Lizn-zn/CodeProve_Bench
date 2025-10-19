import Mathlib

-- Precondition auxiliary definitions
/-- Define what constitutes a vowel character -/
def isVowel (c : Char) : Bool :=
  c = 'a' || c = 'e' || c = 'i' || c = 'o' || c = 'u' ||
  c = 'A' || c = 'E' || c = 'I' || c = 'O' || c = 'U'

-- Precondition definitions
@[reducible, simp]
def capitalize_vowels_precond (text : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function to capitalize a vowel character -/
def capitalizeVowel (c : Char) : Char :=
  if isVowel c then
    match c with
    | 'a' => 'A' | 'e' => 'E' | 'i' => 'I' | 'o' => 'O' | 'u' => 'U'
    | _ => c  -- For already uppercase vowels, keep as is
  else
    c

/-- Helper function to process each character in the string -/
def processChar (c : Char) : Char :=
  if isVowel c then capitalizeVowel c else c

-- Main function definitions
def capitalize_vowels (text : String) (h_precond : capitalize_vowels_precond (text)) : String :=
  -- !benchmark @start code
  String.map processChar text
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Helper function to capitalize a vowel character for postcondition -/
def capitalizeVowelPost (c : Char) : Char :=
  if isVowel c then
    match c with
    | 'a' => 'A' | 'e' => 'E' | 'i' => 'I' | 'o' => 'O' | 'u' => 'U'
    | _ => c  -- For already uppercase vowels, keep as is
  else
    c

/-- Helper function to process each character in the string for postcondition -/
def processCharPost (c : Char) : Char :=
  if isVowel c then capitalizeVowelPost c else c

-- Postcondition definitions
@[reducible, simp]
def capitalize_vowels_postcond (text : String) (result: String) (h_precond : capitalize_vowels_precond (text)) : Prop :=
  -- !benchmark @start postcond
  result = String.map processCharPost text
  -- !benchmark @end postcond


-- Proof content
theorem capitalize_vowels_postcond_satisfied (text: String) (h_precond : capitalize_vowels_precond (text)) :
    capitalize_vowels_postcond (text) (capitalize_vowels (text) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof