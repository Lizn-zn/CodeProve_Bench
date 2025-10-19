import Mathlib

-- Precondition definitions
@[reducible, simp]
def setToAsciiArray_precond (s : Set Int) : Prop :=
  -- !benchmark @start precond
  Set.Finite s
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to check if an integer is a valid ASCII value
def isAscii (n : Int) : Bool := 0 ≤ n ∧ n ≤ 127

-- Helper function to convert an integer to a character (assuming it's valid ASCII)
def intToChar (n : Int) : Char :=
  Char.ofNat (Int.toNat n)

-- Main function definitions
noncomputable def setToAsciiArray (s : Set Int) (h_precond : setToAsciiArray_precond (s)) : Array Char :=
  -- !benchmark @start code
  -- Filter valid ASCII integers, sort them, and convert to characters
  let finite_s : Finset Int := Set.Finite.toFinset h_precond
  let validInts : Finset Int := Finset.filter (λ x => isAscii x) finite_s
  let sortedInts : List Int := validInts.sort (λ a b => a ≤ b)
  sortedInts.map intToChar |>.toArray
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def isValidAscii (n : Int) : Prop := 0 ≤ n ∧ n ≤ 127

noncomputable def sortedAsciiChars (s : Set Int) (h_finite : Set.Finite s) : List Char :=
  let finite_s : Finset Int := Set.Finite.toFinset h_finite
  let validInts : Finset Int := Finset.filter (λ x => (isAscii x : Bool)) finite_s
  let sortedInts : List Int := validInts.sort (λ a b => a ≤ b)
  sortedInts.map (λ n => Char.ofNat (Int.toNat n))

-- Postcondition definitions
@[reducible, simp]
def setToAsciiArray_postcond (s : Set Int) (result: Array Char) (h_precond : setToAsciiArray_precond (s)) : Prop :=
  -- !benchmark @start postcond
  result.toList = sortedAsciiChars s h_precond
  -- !benchmark @end postcond


-- Proof content
theorem setToAsciiArray_postcond_satisfied (s: Set Int) (h_precond : setToAsciiArray_precond (s)) :
    setToAsciiArray_postcond (s) (setToAsciiArray (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof