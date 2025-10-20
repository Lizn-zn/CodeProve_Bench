import Mathlib

namespace no_132_leetcode_248


-- Precondition auxiliary definitions
/-- A helper function to check whether a character is a valid strobogrammatic digit -/
def isStrobogrammaticDigit : Char → Bool
  | '0' => true
  | '1' => true
  | '6' => true
  | '8' => true
  | '9' => true
  | _ => false

/-- A helper function to check whether a string represents a valid strobogrammatic number -/
def isStrobogrammatic (s : String) : Bool :=
  let validDigits := s.data.all isStrobogrammaticDigit
  let reversed := s.data.reverse
  let mapped := reversed.map (fun c =>
    match c with
    | '6' => '9'
    | '9' => '6'
    | _ => c)
  validDigits && s.data == mapped

/-- Convert a string to a natural number, returning none if it's not a valid non-negative integer -/
def stringToNat (s : String) : Option Nat :=
  if s = "0" then some 0
  else if s.data.head? = some '0' then none  -- Leading zero not allowed except for "0"
  else
    let digits := s.data.map (fun c => c.toNat - '0'.toNat)
    if digits.all (fun d => d < 10) then
      let acc : Nat := 0
      let result := digits.foldl (fun acc d => acc * 10 + d) acc
      some result
    else
      none

/-- Check if a string represents a valid number (digits only, no leading zeros unless it's "0") -/
def isValidNumberString (s : String) : Bool :=
  match stringToNat s with
  | some _ => true
  | none => false

-- Precondition definitions
@[reducible, simp]
def countStrobogrammaticInRange_precond (low : String) (high : String) : Prop :=
  -- !benchmark @start precond
  isValidNumberString low ∧ isValidNumberString high ∧
    match stringToNat low, stringToNat high with
    | some lowNum, some highNum => lowNum ≤ highNum
    | _, _ => False
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Generate all strobogrammatic numbers of a given length -/
def generateStrobogrammatic (n : Nat) (finalLength : Nat) : List String :=
  if n = 0 then [""] else
  if n = 1 then ["0", "1", "8"] else
  let prev := generateStrobogrammatic (n - 2) finalLength
  let result : List String := []
  let result := prev.foldl (fun acc s =>
    acc ++ ["0" ++ s ++ "0"] ++
           ["1" ++ s ++ "1"] ++
           ["6" ++ s ++ "9"] ++
           ["8" ++ s ++ "8"] ++
           ["9" ++ s ++ "6"]
  ) result
  if n ≠ finalLength then
    result
  else
    result.filter (fun s => match s.data.head? with | some c => c ≠ '0' | none => false)

/-- Count strobogrammatic numbers of length n -/
def countStrobogrammaticOfLength (n : Nat) : Nat :=
  (generateStrobogrammatic n n).length

/-- Check if a string (representing a number) is in the range [lowStr, highStr] -/
def isInRange (s : String) (lowStr : String) (highStr : String) : Bool :=
  let sNum := stringToNat s
  let lowNum := stringToNat lowStr
  let highNum := stringToNat highStr
  match sNum, lowNum, highNum with
  | some sVal, some lowVal, some highVal =>
    lowVal ≤ sVal ∧ sVal ≤ highVal
  | _, _, _ => false

-- Main function definitions
def countStrobogrammaticInRange (low : String) (high : String) (h_precond : countStrobogrammaticInRange_precond (low) (high)) : Nat :=
  -- !benchmark @start code
  let lowNum := stringToNat low
  let highNum := stringToNat high
  match lowNum, highNum with
  | some lowVal, some highVal =>
    -- Determine the range of lengths to consider
    let lowLen := low.length
    let highLen := high.length
    let total : Nat := 0
    let total := List.range (highLen + 1 - lowLen) |>.foldl (fun acc i =>
      let len := lowLen + i
      let strobos := generateStrobogrammatic len len
      acc + (
        if len = lowLen ∨ len = highLen then
          -- Need to check each number in the range
          (strobos.filter (fun numStr => isInRange numStr low high)).length
        else
          -- All numbers of this length are in range
          strobos.length
      )
    ) total
    total
  | _, _ => 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Count strobogrammatic numbers in a range given as natural numbers -/
def countStrobogrammaticInRangeNat (low high : Nat) : Nat :=
  let candidates := List.range (high + 1 - low) |>.map (fun i => low + i)
  (candidates.filter (fun n =>
    let s := toString n
    isStrobogrammatic s
  )).length

/-- Convert a natural number to its string representation -/
def toString (n : Nat) : String :=
  if n = 0 then "0"
  else
    let rec go (n : Nat) (acc : List Char) : List Char :=
      if n = 0 then acc
      else go (n / 10) ((Char.ofNat ((n % 10) + '0'.toNat)) :: acc)
    String.mk (go n [])

-- Postcondition definitions
@[reducible, simp]
def countStrobogrammaticInRange_postcond (low : String) (high : String) (result: Nat) (h_precond : countStrobogrammaticInRange_precond (low) (high)) : Prop :=
  -- !benchmark @start postcond
  let lowNum := stringToNat low
  let highNum := stringToNat high
  match lowNum, highNum with
  | some lowVal, some highVal =>
    result = countStrobogrammaticInRangeNat lowVal highVal
  | _, _ => False
  -- !benchmark @end postcond


-- Proof content
theorem countStrobogrammaticInRange_postcond_satisfied (low: String) (high: String) (h_precond : countStrobogrammaticInRange_precond (low) (high)) :
    countStrobogrammaticInRange_postcond (low) (high) (countStrobogrammaticInRange (low) (high) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_132_leetcode_248