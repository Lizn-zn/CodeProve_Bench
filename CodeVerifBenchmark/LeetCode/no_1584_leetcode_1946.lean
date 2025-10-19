import Mathlib

-- Precondition auxiliary definitions
def digitCharToNat (c : Char) : Option Nat :=
  if c.isDigit then
    some (c.toNat - '0'.toNat)
  else
    none

def isValidChangeMap (change : List Nat) : Prop :=
  change.length = 10 ∧ ∀ d ∈ change, d < 10

def String.toDigitList (s : String) : List Nat :=
  s.data.filter (·.isDigit) |>.map (·.toNat - '0'.toNat)

def isDigitString (s : String) : Prop :=
  s.data.all (·.isDigit)

-- Precondition definitions
@[reducible, simp]
def maximumNumber_precond (num : String) (change : List Nat) : Prop :=
  -- !benchmark @start precond
  num ≠ "" ∧ isDigitString num ∧ isValidChangeMap change
  -- !benchmark @end precond


-- Code auxiliary definitions
def findMutationRange (digits : List Nat) (change : List Nat) : Option (Nat × Nat) :=
  let arr := digits.toArray
  let changeArr := change.toArray
  let n := arr.size

  -- Find the first index where mutation increases the digit
  let firstIdx := Id.run do
    let mut i := 0
    while h : i < n do
      let d := arr[i]
      let newD := changeArr[d]!
      if newD > d then
        break
      i := i + 1
    pure i

  if firstIdx = n then
    none  -- No beneficial mutation found
  else
    -- Extend the mutation range as long as it doesn't decrease the value
    let lastIdx := Id.run do
      let mut j := firstIdx + 1
      while h : j < n do
        let d := arr[j]
        let newD := changeArr[d]!
        if newD < d then
          break
        j := j + 1
      pure j
    (firstIdx, lastIdx)

def mutateSubstring (digits : List Nat) (change : List Nat) (startIdx : Nat) (endIdx : Nat) : List Nat :=
  let arr := digits.toArray
  let changeArr := change.toArray
  let n := arr.size
  let indices := List.range n
  indices.map (fun i =>
    if startIdx ≤ i ∧ i < endIdx then
      changeArr[arr[i]!]!
    else
      arr[i]!
  )

-- Main function definitions
def maximumNumber (num : String) (change : List Nat) (h_precond : maximumNumber_precond (num) (change)) : String :=
  -- !benchmark @start code
  let digits := num.toDigitList
  match findMutationRange digits change with
  | none => num
  | some (startIdx, endIdx) =>
    let mutatedDigits := mutateSubstring digits change startIdx endIdx
    String.mk (mutatedDigits.map (fun d => Char.ofNat (d + '0'.toNat)))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def isSubstringMutation (originalDigits : List Nat) (mutatedDigits : List Nat) (change : List Nat) : Prop :=
  ∃ (startIdx endIdx : Nat),
    startIdx ≤ endIdx ∧
    endIdx ≤ originalDigits.length ∧
    (∀ i < originalDigits.length,
      if startIdx ≤ i ∧ i < endIdx then
        mutatedDigits.get! i = change.get! (originalDigits.get! i)
      else
        mutatedDigits.get! i = originalDigits.get! i)

def lexicographicallyGreaterOrEqual (s1 s2 : String) : Prop :=
  let digits1 := s1.toDigitList
  let digits2 := s2.toDigitList
  if digits1.length > digits2.length then
    True
  else if digits1.length < digits2.length then
    False
  else
    digits1 >= digits2

-- Postcondition definitions
@[reducible, simp]
def maximumNumber_postcond (num : String) (change : List Nat) (result: String) (h_precond : maximumNumber_precond (num) (change)) : Prop :=
  -- !benchmark @start postcond
  let originalDigits := num.toDigitList
  let resultDigits := result.toDigitList
  isSubstringMutation originalDigits resultDigits change ∧
  (∀ otherResult : String,
    let otherResultDigits := otherResult.toDigitList
    isSubstringMutation originalDigits otherResultDigits change →
    lexicographicallyGreaterOrEqual result otherResult)
  -- !benchmark @end postcond


-- Proof content
theorem maximumNumber_postcond_satisfied (num: String) (change: List Nat) (h_precond : maximumNumber_precond (num) (change)) :
    maximumNumber_postcond (num) (change) (maximumNumber (num) (change) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof