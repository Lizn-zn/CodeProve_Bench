import Mathlib

namespace no_1912_p02860


-- Precondition definitions
@[reducible, simp]
def isDoubleConcatenation_precond (n : Nat) (s : String) : Prop :=
  -- !benchmark @start precond
  s.length = n
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to check if two substrings are equal
def substringEqual (s : String) (start1 start2 len : Nat) : Bool :=
  let rec check (i : Nat) : Bool :=
    if i >= len then true
    else if s.get ⟨start1 + i⟩ != s.get ⟨start2 + i⟩ then false
    else check (i + 1)
  check 0

-- Main function definitions
def isDoubleConcatenation (n : Nat) (s : String) (h_precond : isDoubleConcatenation_precond (n) (s)) : Bool :=
  -- !benchmark @start code
  if n % 2 == 1 then
      false
    else
      let m := n / 2
      let rec checkHalves (i : Nat) : Bool :=
        if i >= m then true
        else if s.get ⟨i⟩ != s.get ⟨i + m⟩ then false
        else checkHalves (i + 1)
      checkHalves 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper definition to check if a string is a concatenation of two copies of some string
def isDoubleConcatenationString (s : String) : Prop :=
  ∃ (t : String), s = t ++ t

-- Postcondition definitions
@[reducible, simp]
def isDoubleConcatenation_postcond (n : Nat) (s : String) (result: Bool) (h_precond : isDoubleConcatenation_precond (n) (s)) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ isDoubleConcatenationString s
  -- !benchmark @end postcond


-- Proof content
theorem isDoubleConcatenation_postcond_satisfied (n: Nat) (s: String) (h_precond : isDoubleConcatenation_precond (n) (s)) :
    isDoubleConcatenation_postcond (n) (s) (isDoubleConcatenation (n) (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1912_p02860