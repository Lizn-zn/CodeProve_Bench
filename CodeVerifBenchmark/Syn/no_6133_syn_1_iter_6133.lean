import Mathlib

-- Precondition auxiliary definitions
inductive UnionType (α : Type u) (β : Type v) where
  | left : α → UnionType α β
  | right : β → UnionType α β

-- Precondition definitions
@[reducible, simp]
def chars_to_unicode_precond (chars : UnionType (Array Char) (List Char)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Postcondition auxiliary definitions
def toCodePointArray (chars : Array Char) : Array Int :=
  chars.map (λ c => (Char.toNat c : Int))

def toCodePointList (chars : List Char) : Array Int :=
  chars.toArray.map (λ c => (Char.toNat c : Int))

-- Main function definitions
def chars_to_unicode (chars : UnionType (Array Char) (List Char)) (h_precond : chars_to_unicode_precond chars) : Array Int :=
  -- !benchmark @start code
  match chars with
  | UnionType.left arr => toCodePointArray arr
  | UnionType.right lst => toCodePointList lst
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def chars_to_unicode_postcond (chars : UnionType (Array Char) (List Char)) (result: Array Int) (h_precond : chars_to_unicode_precond chars) : Prop :=
  -- !benchmark @start postcond
  match chars with
  | UnionType.left arr => result = toCodePointArray arr
  | UnionType.right lst => result = toCodePointList lst
  -- !benchmark @end postcond


-- Proof content
theorem chars_to_unicode_postcond_satisfied (chars: UnionType (Array Char) (List Char)) (h_precond : chars_to_unicode_precond chars) :
    chars_to_unicode_postcond chars (chars_to_unicode chars h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof