import Mathlib

-- Precondition auxiliary definitions
def countChar (s : String) (c : Char) : Nat :=
  s.data.foldl (fun acc ch => if ch = c then acc + 1 else acc) 0

def isOpenBracket (c : Char) : Bool := c = '['

def isBalancedStringAux (chars : List Char) (openCount : Nat) : Bool :=
  match chars with
  | [] => openCount = 0
  | c :: cs =>
    if c = '[' then
      isBalancedStringAux cs (openCount + 1)
    else if openCount > 0 then
      isBalancedStringAux cs (openCount - 1)
    else
      false

def isBalancedString (s : String) : Bool :=
  isBalancedStringAux s.data 0

-- Precondition definitions
@[reducible, simp]
def minSwapsToBalance_precond (s : String) : Prop :=
  -- !benchmark @start precond
  s.length ≥ 2 ∧ s.length % 2 = 0 ∧
  countChar s '[' = s.length / 2 ∧
  countChar s ']' = s.length / 2
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute the maximum imbalance of closing brackets
def maxClosingImbalance (chars : List Char) : Nat :=
  let rec loop (chars : List Char) (balance : Int) (maxImbalance : Nat) : Nat :=
    match chars with
    | [] => maxImbalance
    | c :: cs =>
      let newBalance := if c = '[' then balance + 1 else balance - 1
      let newMaxImbalance := if newBalance < 0 then max maxImbalance (Int.natAbs (-newBalance)) else maxImbalance
      loop cs newBalance newMaxImbalance
  loop chars 0 0

-- Main function definitions
def minSwapsToBalance (s : String) (h_precond : minSwapsToBalance_precond (s)) : Nat :=
  -- !benchmark @start code
  let chars := s.data
  let maxImbalance := maxClosingImbalance chars
  (maxImbalance + 1) / 2
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def imbalanceCount (s : String) : Nat :=
  let chars := s.data
  let rec loop (chars : List Char) (balance : Int) (maxImbalance : Nat) : Nat :=
    match chars with
    | [] => maxImbalance
    | c :: cs =>
      let newBalance := if c = '[' then balance + 1 else balance - 1
      let newMaxImbalance := if newBalance < 0 then max (maxImbalance) (Int.natAbs (-newBalance)) else maxImbalance
      loop cs newBalance newMaxImbalance
  loop chars 0 0

-- Postcondition definitions
@[reducible, simp]
def minSwapsToBalance_postcond (s : String) (result: Nat) (h_precond : minSwapsToBalance_precond (s)) : Prop :=
  -- !benchmark @start postcond
  let requiredSwaps := (imbalanceCount s + 1) / 2
  result = requiredSwaps
  -- !benchmark @end postcond


-- Proof content
theorem minSwapsToBalance_postcond_satisfied (s: String) (h_precond : minSwapsToBalance_precond (s)) :
    minSwapsToBalance_postcond (s) (minSwapsToBalance (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof