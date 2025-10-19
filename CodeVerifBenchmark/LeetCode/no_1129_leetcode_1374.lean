import Mathlib

-- Precondition auxiliary definitions
def isLowerCaseEnglishLetter (c : Char) : Bool :=
  'a' ≤ c ∧ c ≤ 'z'

def Char.count (s : String) (c : Char) : Nat :=
  s.data.filter (fun x => x = c) |>.length

def String.oddCharCounts (s : String) : Prop :=
  ∀ c : Char, isLowerCaseEnglishLetter c = true →
    (c.count s) % 2 = 1 ∨ (c.count s) = 0

-- Precondition definitions
@[reducible, simp]
def generateOddCharacterString_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ n ∧ n ≤ 500
  -- !benchmark @end precond


-- Code auxiliary definitions
def repeatChar (c : Char) (n : Nat) : String :=
  String.mk <| List.replicate n c

-- Main function definitions
def generateOddCharacterString (n : Nat) (h_precond : generateOddCharacterString_precond (n)) : String :=
  -- !benchmark @start code
  
    if n % 2 = 1 then
      repeatChar 'a' n
    else
      let s1 := repeatChar 'a' (n - 1)
      s1 ++ "b"
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def generateOddCharacterString_postcond (n : Nat) (result: String) (h_precond : generateOddCharacterString_precond (n)) : Prop :=
  -- !benchmark @start postcond
  result.length = n ∧
    (result.data.all (fun c => isLowerCaseEnglishLetter c = true)) ∧
    result.oddCharCounts
  -- !benchmark @end postcond


-- Proof content
theorem generateOddCharacterString_postcond_satisfied (n: Nat) (h_precond : generateOddCharacterString_precond (n)) :
    generateOddCharacterString_postcond (n) (generateOddCharacterString (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof