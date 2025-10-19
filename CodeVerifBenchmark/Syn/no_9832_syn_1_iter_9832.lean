import Mathlib

-- Precondition definitions
@[reducible, simp]
def generate_char_array_precond (char_code : UInt8) (count : Int) : Prop :=
  -- !benchmark @start precond
  count ≥ 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def generate_char_array (char_code : UInt8) (count : Int) (h_precond : generate_char_array_precond (char_code) (count)) : Array Char :=
  -- !benchmark @start code
  if count = 0 then
    #[]  -- Return empty array when count is 0
  else
    let char := Char.ofNat (char_code.toNat)
    Array.mkArray (Int.toNat count) char
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def generate_char_array_postcond (char_code : UInt8) (count : Int) (result: Array Char) (h_precond : generate_char_array_precond (char_code) (count)) : Prop :=
  -- !benchmark @start postcond
  result.size = Int.toNat count ∧ ∀ i : Fin result.size, result[i]! = Char.ofNat (char_code.toNat)
  -- !benchmark @end postcond


-- Proof content
theorem generate_char_array_postcond_satisfied (char_code: UInt8) (count: Int) (h_precond : generate_char_array_precond (char_code) (count)) :
    generate_char_array_postcond (char_code) (count) (generate_char_array (char_code) (count) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

