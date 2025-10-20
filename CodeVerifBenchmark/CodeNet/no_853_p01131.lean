import Mathlib

namespace no_853_p01131


-- Postcondition auxiliary definitions
-- Define the button mappings for the keitai phone
def buttonMap : Fin 10 → List Char
  | 0 => []  -- Confirm button, no characters
  | 1 => ['.', ',', '!', '?', ' ']
  | 2 => ['a', 'b', 'c']
  | 3 => ['d', 'e', 'f']
  | 4 => ['g', 'h', 'i']
  | 5 => ['j', 'k', 'l']
  | 6 => ['m', 'n', 'o']
  | 7 => ['p', 'q', 'r', 's']
  | 8 => ['t', 'u', 'v']
  | 9 => ['w', 'x', 'y', 'z']

-- Convert a character digit to a natural number
def charToDigit (c : Char) : Option Nat :=
  if c.isDigit then some (c.toNat - '0'.toNat) else none

-- Precondition definitions
@[reducible, simp]
def decodeKeitaiMessage_precond (input : String) : Prop :=
  -- !benchmark @start precond
  -- Input must be a string of digits (0-9)
  input.all (fun c => c.isDigit)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to get character from button map with bounds checking
def getCharFromButton (digit : Nat) (count : Nat) : Option Char :=
  if h : digit < 10 then
    let chars := buttonMap ⟨digit, h⟩
    if chars.length > 0 then
      let idx := (count - 1) % chars.length
      some (chars[idx]!)
    else
      none
  else
    none

-- Process characters iteratively
def processKeitaiInput (input : String) : String :=
  let chars := input.toList
  let rec go (cs : List Char) (currentButton : Option Nat) (count : Nat) (acc : String) : String :=
    match cs with
    | [] => acc
    | c :: rest =>
      match charToDigit c with
      | none => acc
      | some digit =>
        if digit = 0 then
          -- Confirm button pressed
          match currentButton with
          | none => go rest none 0 acc
          | some btn =>
            match getCharFromButton btn count with
            | none => go rest none 0 acc
            | some ch => go rest none 0 (acc.push ch)
        else
          -- Number button pressed
          match currentButton with
          | none => go rest (some digit) 1 acc
          | some btn =>
            if btn = digit then
              -- Same button, increment count
              go rest (some digit) (count + 1) acc
            else
              -- Different button without confirm - shouldn't happen in valid input
              go rest (some digit) 1 acc
  go chars none 0 ""

-- Main function definitions
def decodeKeitaiMessage (input : String) (h_precond : decodeKeitaiMessage_precond (input)) : String :=
  -- !benchmark @start code
  processKeitaiInput input
  -- !benchmark @end code


-- Process the input string to decode the keitai message
def decodeKeitaiMessageSpec (input : String) : String :=
  let chars := input.toList
  let rec processChars (cs : List Char) (currentButton : Option Nat) (count : Nat) (acc : List Char) : List Char :=
    match cs with
    | [] => acc
    | c :: rest =>
      match charToDigit c with
      | none => acc  -- Invalid input, stop processing
      | some digit =>
        if digit = 0 then
          -- Confirm button pressed
          match currentButton with
          | none => processChars rest none 0 acc  -- Nothing to confirm
          | some btn =>
            if h : btn < 10 then
              let chars := buttonMap ⟨btn, h⟩
              if chars.length > 0 then
                let idx := (count - 1) % chars.length
                let char := chars[idx]!
                processChars rest none 0 (acc ++ [char])
              else
                processChars rest none 0 acc
            else
              processChars rest none 0 acc
        else
          -- Number button pressed
          match currentButton with
          | none => processChars rest (some digit) 1 acc
          | some btn =>
            if btn = digit then
              -- Same button, increment count
              if h : digit < 10 then
                let chars := buttonMap ⟨digit, h⟩
                processChars rest (some digit) (count + 1) acc
              else
                processChars rest (some digit) (count + 1) acc
            else
              -- Different button - this shouldn't happen with valid input
              -- (previous button should be confirmed first)
              processChars rest (some digit) 1 acc
  String.mk (processChars chars none 0 [])

-- Postcondition definitions
@[reducible, simp]
def decodeKeitaiMessage_postcond (input : String) (result: String) (h_precond : decodeKeitaiMessage_precond (input)) : Prop :=
  -- !benchmark @start postcond
  -- The result should match the decoded message according to the keitai message specification
  result = decodeKeitaiMessageSpec input
  -- !benchmark @end postcond


-- Proof content
theorem decodeKeitaiMessage_postcond_satisfied (input: String) (h_precond : decodeKeitaiMessage_precond (input)) :
    decodeKeitaiMessage_postcond (input) (decodeKeitaiMessage (input) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_853_p01131