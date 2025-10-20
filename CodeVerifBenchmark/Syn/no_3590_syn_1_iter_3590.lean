import Mathlib

namespace no_3590_syn_1_iter_3590


-- Precondition definitions
@[reducible, simp]
def stringToCharCodes_precond (start : UInt8) (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def getFirstByte (c : Char) : UInt8 :=
  let bytes := c.toString.toUTF8
  if bytes.isEmpty then 0 else bytes.get! 0

def getCodePoint (c : Char) : Nat :=
  c.toNat

-- Main function definitions
def stringToCharCodes (start : UInt8) (s : String) (h_precond : stringToCharCodes_precond (start) (s)) : Finset Nat :=
  -- !benchmark @start code
  let chars := s.toList.toFinset
  let filtered_chars := Finset.filter (λ c => getFirstByte c ≥ start) chars
  Finset.image getCodePoint filtered_chars
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- (getFirstByte and getCodePoint moved above since they're used in the code)

-- Postcondition definitions
@[reducible, simp]
def stringToCharCodes_postcond (start : UInt8) (s : String) (result: Finset Nat) (h_precond : stringToCharCodes_precond (start) (s)) : Prop :=
  -- !benchmark @start postcond
  result = Finset.filter (λ n => ∃ (c : Char), c ∈ s.data ∧ getCodePoint c = n ∧ getFirstByte c ≥ start) 
            (Finset.image getCodePoint (Finset.filter (λ c => getFirstByte c ≥ start) (s.data.toFinset)))
  -- !benchmark @end postcond


-- Proof content
theorem stringToCharCodes_postcond_satisfied (start: UInt8) (s: String) (h_precond : stringToCharCodes_precond (start) (s)) :
    stringToCharCodes_postcond (start) (s) (stringToCharCodes (start) (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_3590_syn_1_iter_3590