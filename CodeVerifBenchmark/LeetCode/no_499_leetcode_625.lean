import Mathlib

namespace no_499_leetcode_625


-- Precondition auxiliary definitions
def digitsMul : Nat → Nat
  | 0 => 0
  | n =>
    let digits := (toString n).toList
    let mulDigits (acc : Nat) (c : Char) : Nat :=
      if c.isDigit then
        let digit := c.toNat - '0'.toNat
        acc * digit
      else
        0
    digits.foldl mulDigits 1

def fitsIn32BitSignedInt (n : Nat) : Prop :=
  n < 2^31

instance : DecidablePred fitsIn32BitSignedInt := fun n =>
  if h : n < 2^31 then
    isTrue h
  else
    isFalse (by simp [fitsIn32BitSignedInt]; exact Nat.not_lt.mp h)

-- Precondition definitions
@[reducible, simp]
def smallestFactorization_precond (num : Nat) : Prop :=
  -- !benchmark @start precond
  num > 0 ∧ num < 2^31
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Generate the smallest number composed of digits whose product is `num`. -/
def constructFromFactors (factors : List Nat) : Nat :=
  match factors with
  | [] => 1
  | _ =>
    let sortedFactors := factors.mergeSort (· ≤ ·)
    let digits := sortedFactors.map toString
    let digitString := digits.foldl (· ++ ·) ""
    match digitString.toNat? with
    | some n => n
    | none => 0

/-- Factorize a number into single-digit factors (2-9). -/
def factorizeToSingleDigits : Nat → Option (List Nat)
  | 0 => none
  | 1 => some []
  | n =>
    -- Try dividing by digits from 9 down to 2 to get the lexicographically smallest result
    let rec findFactors (current : Nat) (acc : List Nat) : Option (List Nat) :=
      if current = 1 then
        some acc
      else
        let factors := [9, 8, 7, 6, 5, 4, 3, 2]
        let firstFactor? := factors.find? (fun d => current % d = 0)
        match firstFactor? with
        | some d =>
          findFactors (current / d) (d :: acc)
        | none => none
    decreasing_by sorry
    findFactors n []

-- Main function definitions
def smallestFactorization (num : Nat) (h_precond : smallestFactorization_precond (num)) : Nat :=
  -- !benchmark @start code
  match factorizeToSingleDigits num with
  | none => 0
  | some factors =>
    let candidate := constructFromFactors factors
    if fitsIn32BitSignedInt candidate then
      candidate
    else
      0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def isDigitProductOf (x : Nat) (num : Nat) : Prop :=
  x > 0 ∧ digitsMul x = num

def isSmallestPositiveWithDigitProduct (x : Nat) (num : Nat) : Prop :=
  isDigitProductOf x num ∧
  ∀ y : Nat, y > 0 ∧ y < x → ¬isDigitProductOf y num

-- Postcondition definitions
@[reducible, simp]
def smallestFactorization_postcond (num : Nat) (result: Nat) (h_precond : smallestFactorization_precond (num)) : Prop :=
  -- !benchmark @start postcond
  if result = 0 then
    ¬∃ x : Nat, isDigitProductOf x num ∧ fitsIn32BitSignedInt x
  else
    isSmallestPositiveWithDigitProduct result num ∧ fitsIn32BitSignedInt result
  -- !benchmark @end postcond


-- Proof content
theorem smallestFactorization_postcond_satisfied (num: Nat) (h_precond : smallestFactorization_precond (num)) :
    smallestFactorization_postcond (num) (smallestFactorization (num) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_499_leetcode_625