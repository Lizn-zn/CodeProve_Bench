import Mathlib

-- Precondition auxiliary definitions
/-- Check if a character is a digit -/
def Char.isDigit' (c : Char) : Bool :=
  '0' ≤ c ∧ c ≤ '9'

/-- Get the list of characters from a string -/
def String.chars (s : String) : List Char :=
  s.data

/-- Count occurrences of each digit in a string -/
def String.digitCounts (s : String) : List Nat :=
  List.map (fun d => (s.chars.filter (· = Char.ofNat d)).length) (List.range 10)

/-- Check if one list of natural numbers is less than or equal to another pointwise -/
def List.Nat.le (l₁ l₂ : List Nat) : Prop :=
  ∀ i, i < l₁.length → l₁.get! i ≤ l₂.get! i

/-- A helper function to check if we can move smaller digits leftward through sorting operations -/
def canMoveLeft (s : String) (pos : Nat) (targetChar : Char) : Prop :=
  let chars := s.chars
  let targetVal := targetChar.toNat
  -- For all positions before pos, if they contain a digit greater than targetChar,
  -- there must be a way to bring a smaller or equal digit to that position
  ∀ i, i < pos → 
    let charAtI := chars.get! i
    charAtI.toNat > targetVal →
      ∃ j, j ≥ pos ∧ Char.toNat (chars.get! j) ≤ Char.toNat charAtI

/-- Main condition for transformation possibility -/
def canTransformCondition (s t : String) : Prop :=
  s.length = t.length ∧
  s.digitCounts = t.digitCounts ∧
  ∀ i, i < t.length → canMoveLeft s i (t.chars.get! i)

-- Precondition definitions
@[reducible, simp]
def canTransform_precond (s : String) (t : String) : Prop :=
  s.length = t.length ∧
  (∀ c, c ∈ s.chars → Char.isDigit' c) ∧
  (∀ c, c ∈ t.chars → Char.isDigit' c)

-- Code auxiliary definitions
/-- Helper function to check if we can move smaller digits to earlier positions -/
def canMoveLeftCheck (chars : List Char) (targetPos : Nat) (targetChar : Char) : Bool :=
  let targetVal := targetChar.toNat
  let prefixList := chars.take targetPos
  let suffixList := chars.drop targetPos
  -- For every character in the prefix that is larger than targetChar,
  -- there must exist a character in the suffix that is ≤ that character
  prefixList.all (fun c => 
    if c.toNat > targetVal then
      suffixList.any (· ≤ c)
    else
      true
  )

/-- Check if transformation is possible by verifying all conditions -/
def canTransformImpl (s t : String) : Bool :=
  if s.length ≠ t.length then
    false
  else
    let sChars := s.chars
    let tChars := t.chars
    if s.digitCounts ≠ t.digitCounts then
      false
    else
      -- Check for each position in target if we can move required character there
      List.range t.length |>.all (fun i =>
        canMoveLeftCheck sChars i (tChars.get! i)
      )

-- Main function definitions
def canTransform (s : String) (t : String) (h_precond : canTransform_precond (s) (t)) : Bool :=
  canTransformImpl s t

-- Postcondition auxiliary definitions
-- Removed the problematic instance declaration that tried to synthesize decidability

-- Postcondition definitions
@[reducible, simp]
def canTransform_postcond (s : String) (t : String) (result: Bool) (h_precond : canTransform_precond (s) (t)) : Prop :=
  result ↔ canTransformCondition s t

-- Proof content
theorem canTransform_postcond_satisfied (s: String) (t: String) (h_precond : canTransform_precond (s) (t)) :
    canTransform_postcond (s) (t) (canTransform (s) (t) h_precond) h_precond := by
  sorry