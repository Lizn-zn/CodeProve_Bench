import Mathlib

-- Precondition definitions
@[reducible, simp]
def process_nums_precond (a : Nat) (b : Nat) (chars : Array Char) (nums : Array Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def isDigit (c : Char) : Bool :=
  let asciiVal := c.toNat
  asciiVal ≥ 48 ∧ asciiVal ≤ 57

-- Main function definitions
def process_nums (a : Nat) (b : Nat) (chars : Array Char) (nums : Array Nat) (h_precond : process_nums_precond (a) (b) (chars) (nums)) : Array Nat :=
  -- !benchmark @start code
  let minLength := min chars.size nums.size
  Array.ofFn fun (i : Fin minLength) => 
    let c := chars[i]!
    let n := nums[i]!
    if isDigit c then
      n + a
    else
      max (n - b) 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def processElement (a : Nat) (b : Nat) (c : Char) (n : Nat) : Nat :=
  if isDigit c then
    n + a
  else
    max (n - b) 0

-- Postcondition definitions
@[reducible, simp]
def process_nums_postcond (a : Nat) (b : Nat) (chars : Array Char) (nums : Array Nat) (result: Array Nat) (h_precond : process_nums_precond (a) (b) (chars) (nums)) : Prop :=
  -- !benchmark @start postcond
  let minLength := min chars.size nums.size
  result.size = minLength ∧
  ∀ (i : Fin minLength), 
    result[i]! = processElement a b (chars[i]!) (nums[i]!)
  -- !benchmark @end postcond


-- Proof content
theorem process_nums_postcond_satisfied (a: Nat) (b: Nat) (chars: Array Char) (nums: Array Nat) (h_precond : process_nums_precond (a) (b) (chars) (nums)) :
    process_nums_postcond (a) (b) (chars) (nums) (process_nums (a) (b) (chars) (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof