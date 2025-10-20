import Mathlib

namespace no_1419_leetcode_2843


-- Precondition auxiliary definitions
def IsSymmetric (n : Nat) : Bool :=
  let s := toString n
  let len := s.length
  if len % 2 ≠ 0 then
    false
  else
    let half := len / 2
    let firstHalf := s.take half
    let secondHalf := s.drop half
    (firstHalf.foldl (fun acc c => acc + (c.toNat - '0'.toNat)) 0) =
    (secondHalf.foldl (fun acc c => acc + (c.toNat - '0'.toNat)) 0)

-- Precondition definitions
@[reducible, simp]
def countSymmetricIntegers_precond (low : Nat) (high : Nat) : Prop :=
  -- !benchmark @start precond
  low > 0 ∧ high > 0 ∧ low ≤ high ∧ high ≤ 10000
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Check if a list of digits represents a symmetric number -/
def digitsIsSymmetric (digits : List Nat) : Bool :=
  let len := digits.length
  if len % 2 ≠ 0 then
    false
  else
    let half := len / 2
    let firstHalf := digits.take half
    let secondHalf := digits.drop half
    (firstHalf.foldl (·+·) 0) = (secondHalf.foldl (·+·) 0)

/-- Convert a natural number to a list of its digits -/
def Nat.toDigitsAux : Nat → List Nat
  | 0 => [0]
  | n =>
    let rec go (m : Nat) (acc : List Nat) : List Nat :=
      if m = 0 then acc else go (m / 10) ((m % 10)::acc)
    go n []

def Nat.toDigits' (n : Nat) : List Nat :=
  Nat.toDigitsAux n |>.reverse

-- Main function definitions
def countSymmetricIntegers (low : Nat) (high : Nat) (h_precond : countSymmetricIntegers_precond (low) (high)) : Nat :=
  -- !benchmark @start code
  let nums := List.range (high - low + 1) |>.map (· + low)
  nums.filter (fun n => digitsIsSymmetric (Nat.toDigits' n)) |>.length
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def countSymmetricIntegers_postcond (low : Nat) (high : Nat) (result: Nat) (h_precond : countSymmetricIntegers_precond (low) (high)) : Prop :=
  -- !benchmark @start postcond
  result = ((List.range (high - low + 1)).map (fun i => low + i) |>.filter IsSymmetric |>.length)
  -- !benchmark @end postcond


-- Proof content
theorem countSymmetricIntegers_postcond_satisfied (low: Nat) (high: Nat) (h_precond : countSymmetricIntegers_precond (low) (high)) :
    countSymmetricIntegers_postcond (low) (high) (countSymmetricIntegers (low) (high) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1419_leetcode_2843