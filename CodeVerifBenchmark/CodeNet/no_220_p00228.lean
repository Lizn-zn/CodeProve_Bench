import Mathlib

-- Precondition auxiliary definitions
-- Mapping from digit to its 7-segment representation
def digitToSegment : Nat → Nat
  | 0 => 0b0111111
  | 1 => 0b0000110
  | 2 => 0b1011011
  | 3 => 0b1001111
  | 4 => 0b1100110
  | 5 => 0b1101101
  | 6 => 0b1111101
  | 7 => 0b0100111
  | 8 => 0b1111111
  | 9 => 0b1101111
  | _ => 0

-- Precondition definitions
@[reducible, simp]
def sevenSegmentDisplay_precond (digits : List Nat) : Prop :=
  -- !benchmark @start precond
  -- All digits must be in range [0, 9]
    ∀ d ∈ digits, d ≤ 9
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Convert a natural number to its binary string representation with padding
def natToBinaryString (n : Nat) (width : Nat) : String :=
  let rec toBinary (n : Nat) : List Char :=
    if n = 0 then []
    else (if n % 2 = 0 then '0' else '1') :: toBinary (n / 2)
  let bits := toBinary n
  let padded := bits ++ List.replicate (width - bits.length) '0'
  String.mk padded.reverse

-- Helper function to process digits and generate signals
def processDigits (digits : List Nat) (current : Nat) : List String :=
  match digits with
  | [] => []
  | d :: rest =>
    let target := digitToSegment d
    let signal := Nat.xor current target
    natToBinaryString signal 7 :: processDigits rest target

-- Main function definitions
def sevenSegmentDisplay (digits : List Nat) (h_precond : sevenSegmentDisplay_precond (digits)) : List String :=
  -- !benchmark @start code
  processDigits digits 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Compute the expected signal sequence for a list of digits
def computeSignals (digits : List Nat) : List String :=
  let rec helper (ds : List Nat) (current : Nat) : List String :=
    match ds with
    | [] => []
    | d :: rest =>
      let target := digitToSegment d
      let signal := Nat.xor current target
      natToBinaryString signal 7 :: helper rest target
  helper digits 0

-- Postcondition definitions
@[reducible, simp]
def sevenSegmentDisplay_postcond (digits : List Nat) (result: List String) (h_precond : sevenSegmentDisplay_precond (digits)) : Prop :=
  -- !benchmark @start postcond
  -- The result must match the expected signal sequence
    result = computeSignals digits
  -- !benchmark @end postcond


-- Proof content
theorem sevenSegmentDisplay_postcond_satisfied (digits: List Nat) (h_precond : sevenSegmentDisplay_precond (digits)) :
    sevenSegmentDisplay_postcond (digits) (sevenSegmentDisplay (digits) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof