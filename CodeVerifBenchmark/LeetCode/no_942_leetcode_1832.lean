import Mathlib

-- Precondition auxiliary definitions
def isLowerCaseEnglishLetter (c : Char) : Prop :=
  c.val ≥ 'a'.val ∧ c.val ≤ 'z'.val

def allLowerCaseEnglishLetters (s : String) : Prop :=
  ∀ c ∈ s.data, isLowerCaseEnglishLetter c

-- Precondition definitions
@[reducible, simp]
def isPangram_precond (sentence : String) : Prop :=
  -- !benchmark @start precond
  1 ≤ sentence.length ∧ sentence.length ≤ 1000 ∧ allLowerCaseEnglishLetters sentence
  -- !benchmark @end precond


-- Code auxiliary definitions
def charSet (s : String) : List Char :=
  s.data.eraseDup

def isPangramAux (chars : List Char) : Bool :=
  chars.length = 26

-- Main function definitions
def isPangram (sentence : String) (h_precond : isPangram_precond (sentence)) : Bool :=
  -- !benchmark @start code
  let chars := charSet sentence
  isPangramAux chars
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def containsAllLetters (s : String) : Prop :=
  ∀ (c : Char), isLowerCaseEnglishLetter c → c ∈ s.data

-- Postcondition definitions
@[reducible, simp]
def isPangram_postcond (sentence : String) (result: Bool) (h_precond : isPangram_precond (sentence)) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ containsAllLetters sentence
  -- !benchmark @end postcond


-- Proof content
theorem isPangram_postcond_satisfied (sentence: String) (h_precond : isPangram_precond (sentence)) :
    isPangram_postcond (sentence) (isPangram (sentence) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

