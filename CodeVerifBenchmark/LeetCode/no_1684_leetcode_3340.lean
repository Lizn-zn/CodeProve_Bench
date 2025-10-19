import Mathlib

-- Precondition auxiliary definitions
def digitSum (s : String) (even : Bool) : Nat :=
  let chars := s.toList
  let indexedChars := List.zipWith (·, ·) chars (List.range chars.length)
  let filteredDigits := indexedChars.filter (fun (c, i) => (i % 2 == 0) = even)
  let digits := filteredDigits.map (fun (c, _) => c.toNat - '0'.toNat)
  digits.foldl (· + ·) 0

-- Precondition definitions
@[reducible, simp]
def isBalanced_precond (num : String) : Prop :=
  -- !benchmark @start precond
  2 ≤ num.length ∧ num.length ≤ 100 ∧ ∀ c ∈ num.toList, c.toNat - '0'.toNat < 10 ∧ '0'.toNat ≤ c.toNat
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Calculate the sum of digits at even or odd indices in a string of digits. -/
def digitSumEfficient (s : String) (parity : Bool) : Nat :=
  let chars := s.data
  let rec loop (i : Nat) (acc : Nat) : Nat :=
    if h : i < chars.length then
      let c := chars.get ⟨i, h⟩
      let digit := (c.val - '0'.val).toNat
      if (i % 2 = 0) = parity then
        loop (i+1) (acc + digit)
      else
        loop (i+1) acc
    else
      acc
  loop 0 0

-- Main function definitions
def isBalanced (num : String) (h_precond : isBalanced_precond (num)) : Bool :=
  -- !benchmark @start code
  let sumEven := digitSumEfficient num true
  let sumOdd := digitSumEfficient num false
  sumEven == sumOdd
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def isBalanced_postcond (num : String) (result: Bool) (h_precond : isBalanced_precond (num)) : Prop :=
  -- !benchmark @start postcond
  result = (digitSum num true = digitSum num false)
  -- !benchmark @end postcond


-- Proof content
theorem isBalanced_postcond_satisfied (num: String) (h_precond : isBalanced_precond (num)) :
    isBalanced_postcond (num) (isBalanced (num) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof